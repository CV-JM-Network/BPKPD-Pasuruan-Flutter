import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_service/api_service.dart';
import '../api_service/login/login_response.dart';
import '../api_service/wa_api_service.dart';
import 'forgot_password.dart';
import 'jenis_pengajuan.dart';
import 'verification_code.dart';
import 'widget/inputField_widget.dart';
import 'widget/passwordField_widget.dart';
import 'widget/text_widget.dart';

class StackLoginRegister extends StatefulWidget {
  const StackLoginRegister({super.key});

  @override
  State<StackLoginRegister> createState() => _StackLoginRegisterState();
}

class _StackLoginRegisterState extends State<StackLoginRegister> {
  int _sliding = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 248, 247),
      body: Padding(
        padding: const EdgeInsets.only(top: 85, right: 20, left: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CupertinoSlidingSegmentedControl<int>(
                    children: {
                      0: buildSegment("Sign in"),
                      1: buildSegment("Sign up"),
                    },
                    groupValue: _sliding,
                    onValueChanged: (int? newValue) {
                      setState(() {
                        _sliding = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: IndexedStack(
                index: _sliding,
                children: [
                  SignInPage(), // Halaman sign in
                  SignUpPage(), // Halaman sign up
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isFocused = false;
  int? _sliding = 0;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();

  bool _isLoading = false;

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  Future<Map<String, dynamic>> getUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLoginTime = prefs.getInt('last_login_time');

    print("Stored nama: ${prefs.getString('nama')}");
    print("Stored iduser: ${prefs.getInt('iduser')}");
    print("Stored last_login_time: ${prefs.getInt('last_login_time')}");

    if (lastLoginTime != null) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      // Cek apakah sesi login masih valid (misalnya, 1 menit untuk testing)
      if (currentTime - lastLoginTime > 300000) {
        print("Session expired. Logging out...");
        await logout();
        return {'isLoggedIn': false};
      }
    }

    final username = prefs.getString('nama');
    final idUser = prefs.getInt('iduser');

    if (username != null && idUser != null) {
      return {
        'isLoggedIn': true,
        'nama': username,
        'iduser': idUser,
      };
    } else {
      return {'isLoggedIn': false};
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("User logged out.");
  }

  Future<void> saveLoginData(String userName, int idUser) async {
    final prefs = await SharedPreferences.getInstance();
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    await prefs.setString('nama', userName);
    await prefs.setInt('iduser', idUser);
    await prefs.setInt('last_login_time', currentTime);

    print(
        "Login data saved: $userName, $idUser, Last Login Time: $currentTime");
  }

  void _login() async {
    setState(() {
      _isLoading = true; // Tampilkan indikator loading
    });

    try {
      // Memanggil fungsi login dengan parameter yang sesuai
      final response = await _apiService.login(
        _emailController.text,
        _passwordController.text,
        // 'deviceId', // Device token yang digunakan
      );

      // Menambahkan log untuk melihat response login
      print("Login response: $response");

      // Memparsing response menjadi LoginResponse
      final loginResponse = LoginResponse.fromJson(response);

      // Mengecek status login dan menampilkan pesan
      if (loginResponse.status.toLowerCase() == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loginResponse.message)),
        );

        // Navigasi ke halaman berikutnya setelah login berhasil

        final Map<String, dynamic> data = response["data"];
        final userName = data["nama"];
        final idUser = data["iduser"];
        await saveLoginData(userName, idUser);

        // Ambil session data untuk memastikan login tersimpan
        final sessionData = await getUserSession();
        if (sessionData['isLoggedIn']) {
          print("Login data saved and session valid.");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => JenisPengajuan(
                username: userName,
                idUser: idUser,
              ),
            ),
          );
        } else {
          // Jika ada masalah dengan sesi, tampilkan pesan error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error validating session.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loginResponse.message)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Sembunyikan indikator loading
      });
    }
  }

  late Future<Map<String, dynamic>> _futureSession;
  @override
  void initState() {
    super.initState();
    _futureSession = getUserSession(); // Panggil sekali saja
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 246, 248, 247),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 55,
              ),
              Row(
                children: [
                  // Expanded(
                  //   child: CupertinoSlidingSegmentedControl(
                  //     children: {
                  //       0: buildSegment("Sign in"),
                  //       1: buildSegment("Sign up"),
                  //     },
                  //     groupValue: _sliding,
                  //     onValueChanged: (int? newValue) {
                  //       setState(() {
                  //         _sliding = newValue;
                  //         if (newValue == 1) {
                  //           Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) =>
                  //                       const Register()));
                  //         }
                  //       });
                  //     },
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              TextWidget(
                  text: "Welcome back,",
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800]),
              const SizedBox(
                height: 10,
              ),
              TextWidget(
                  text: "Good to see you again.",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700]),
              const SizedBox(
                height: 45,
              ),
              TextWidget(
                text: "Email",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
              const SizedBox(
                height: 15,
              ),
              InputField(
                  controller: _emailController,
                  type: TextInputType.emailAddress,
                  text: 'Enter your email',
                  icon: Icons.email_outlined),
              const SizedBox(
                height: 25,
              ),
              TextWidget(
                text: "Password",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
              const SizedBox(
                height: 15,
              ),
              PasswordField(
                passwordController: _passwordController,
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      isFocused = true;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      isFocused = false;
                    });
                  },
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgotPassword()));
                  },
                  child: TextWidget(
                      text: "Forgot Password?",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isFocused ? Colors.green : Colors.grey[700]),
                ),
              ),
              const SizedBox(
                height: 85,
              ),
              Center(
                child: _isLoading
                    ? CircularProgressIndicator()
                    : SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _login,
                            child: const TextWidget(
                                text: "sign in",
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
              ),
            ],
          ),
        ));
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isFocused = false;
  int? _sliding = 1;

  final ApiService apiService = ApiService();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _telponController = TextEditingController();
  // String deviceToken = ''; // Initialize with an empty string

  final _apiService = OCAWaApiService();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _sendMessage() async {
    final phoneNumber = _telponController.text.trim();
    final name = _namaController.text.trim();
    const templateCodeId =
        "ff6a239f_29b7_4a83_ac0f_9a8bc688b04a:welcoming_template_02";

    if (phoneNumber.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _apiService.sendMessage(
        phoneNumber: phoneNumber,
        templateCodeId: templateCodeId,
        name: name,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Message sent successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send message: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final deviceToken = await apiService.getDeviceId();
      final response = await apiService.registerUser(
        _emailController.text,
        _passwordController.text,
        _namaController.text,
        _alamatController.text,
        _telponController.text,
        deviceToken,
      );

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        final message = responseBody['message'] as String;
        // Handle success response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful')),
        );
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(message)),
        // );
        await _sendMessage();
      } else {
        // Handle error response
        setState(() {
          _errorMessage = 'Failed to register: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 246, 248, 247),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 55,
                ),
                Row(
                  children: [
                    // Expanded(
                    //   child: CupertinoSlidingSegmentedControl(
                    //     children: {
                    //       0: buildSegment("Sign in"),
                    //       1: buildSegment("Sign up"),
                    //     },
                    //     groupValue: _sliding,
                    //     onValueChanged: (int? newValue) {
                    //       setState(() {
                    //         _sliding = newValue;
                    //         if (newValue == 0) {
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => const Login()));
                    //         }
                    //       });
                    //     },
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                TextWidget(
                    text: "Hello there,",
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800]),
                const SizedBox(
                  height: 10,
                ),
                TextWidget(
                    text: "We are excited to see you here.",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700]),
                const SizedBox(
                  height: 45,
                ),
                TextWidget(
                  text: "Email",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
                const SizedBox(
                  height: 15,
                ),
                InputField(
                  type: TextInputType.emailAddress,
                  controller: _emailController,
                  text: 'Enter your email',
                  icon: Icons.email_outlined,
                ),
                const SizedBox(
                  height: 25,
                ),
                TextWidget(
                  text: "Name",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
                const SizedBox(
                  height: 15,
                ),
                InputField(
                  controller: _namaController,
                  text: 'Enter your name',
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(
                  height: 25,
                ),
                TextWidget(
                  text: "Phone Number",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
                const SizedBox(
                  height: 15,
                ),
                InputField(
                  controller: _telponController,
                  text: 'Enter your phone number',
                  icon: Icons.phone_enabled_outlined,
                  type: TextInputType.number,
                ),
                const SizedBox(
                  height: 25,
                ),
                TextWidget(
                  text: "Address",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
                const SizedBox(
                  height: 15,
                ),
                InputField(
                  controller: _alamatController,
                  text: 'Enter your address',
                  icon: Icons.home_outlined,
                ),
                const SizedBox(
                  height: 25,
                ),
                TextWidget(
                  text: "Password",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
                const SizedBox(
                  height: 15,
                ),
                PasswordField(
                  passwordController: _passwordController,
                ),
                const SizedBox(
                  height: 85,
                ),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 55),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _register();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VerificationCode(
                                        phone_number: _telponController.text,
                                        nama: _namaController.text,
                                        // devideId: widget,
                                      ), // Kirim ID permohonan yang dipilih
                                    ),
                                  );
                                }
                              },
                              child: const TextWidget(
                                  text: "Sign up",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ),
                      ),
              ],
            ),
          ),
        ));
  }
}

Widget buildSegment(String text) => Container(
      padding: const EdgeInsets.all(10),
      child: Text(text),
    );
