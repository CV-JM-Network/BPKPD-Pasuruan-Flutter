import 'package:bpkpd_pasuruan_app/screens/forgot_password.dart';
import 'package:bpkpd_pasuruan_app/screens/jenis_pengajuan.dart';
import 'package:bpkpd_pasuruan_app/screens/widget/inputField_widget.dart';
import 'package:bpkpd_pasuruan_app/screens/widget/passwordField_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_service/api_service.dart';
import '../api_service/login/login_response.dart';
import 'widget/text_widget.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;
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

    print("Last Login Time: $lastLoginTime"); // Debugging point

    if (lastLoginTime != null) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      print("Current Time: $currentTime");

      // Cek apakah sudah lebih dari 24 jam (86400000 milidetik)
      if (currentTime - lastLoginTime > 86400000) {
        print("Session expired (more than 24 hours). Logging out...");
        await logout(); // Logout jika lebih dari 24 jam
        return {'isLoggedIn': false}; // Kembalikan status logout
      }
    } else {
      print(
          "No last login time stored"); // Debugging jika tidak ada waktu login sebelumnya
    }

    final username = prefs.getString('username');
    final idUser = prefs.getInt('idUser');

    if (username != null && idUser != null) {
      print("User session valid"); // Debugging point
      return {
        'isLoggedIn': true,
        'username': username,
        'idUser': idUser,
      };
    } else {
      print("User session invalid"); // Debugging point
      return {'isLoggedIn': false};
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('idUser');
    await prefs.remove('last_login_time'); // Hapus waktu login
  }

  Future<void> saveLoginData(String userName, int idUser) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', userName);
    await prefs.setInt('idUser', idUser);
    await prefs.setInt('last_login_time',
        DateTime.now().millisecondsSinceEpoch); // Menyimpan waktu login
    print(
        "Login data saved: $userName, $idUser, ${DateTime.now().millisecondsSinceEpoch}");
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
        // Setelah login berhasil
        Map<String, dynamic> sessionData = await getUserSession();
        print("Session Data: $sessionData");

        // await _apiService.saveAuthToken(loginResponse.tokenAuth);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => JenisPengajuan(
                      username: userName,
                      idUser: idUser,
                    )));
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserSession(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            final data = snapshot.data as Map<String, dynamic>;
            if (data['isLoggedIn']) {
              return JenisPengajuan(
                username: data['username'],
                idUser: data['idUser'],
              );
            } else {
              return const Login(); // Kembali ke halaman login jika session expired
            }
          }
          return Scaffold(
              backgroundColor: const Color.fromARGB(255, 246, 248, 247),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
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
                                    builder: (context) =>
                                        const ForgotPassword()));
                          },
                          child: TextWidget(
                              text: "Forgot Password?",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color:
                                  isFocused ? Colors.green : Colors.grey[700]),
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
                ),
              ));
        });
  }
}

Widget buildSegment(String text) => Container(
      padding: const EdgeInsets.all(10),
      child: Text(text),
    );
