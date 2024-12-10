import 'package:bpkpd_pasuruan_app/screens/forgot_password.dart';
import 'package:bpkpd_pasuruan_app/screens/jenis_pengajuan.dart';
import 'package:bpkpd_pasuruan_app/screens/register.dart';
import 'package:bpkpd_pasuruan_app/screens/widget/inputField_widget.dart';
import 'package:bpkpd_pasuruan_app/screens/widget/passwordField_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  void _login() async {
    setState(() {
      _isLoading = true; // Tampilkan indikator loading
    });

    try {
      // Memanggil fungsi login dengan parameter yang sesuai
      final response = await _apiService.login(
        _emailController.text,
        _passwordController.text,
        'deviceId', // Device token yang digunakan
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
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => JenisPengajuan()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loginResponse.message)),
        );
      }
    } catch (e) {
      // Menampilkan pesan error jika terjadi exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Sembunyikan indikator loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    Expanded(
                      child: CupertinoSlidingSegmentedControl(
                        children: {
                          0: buildSegment("Sign in"),
                          1: buildSegment("Sign up"),
                        },
                        groupValue: _sliding,
                        onValueChanged: (int? newValue) {
                          setState(() {
                            _sliding = newValue;
                            if (newValue == 1) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Register()));
                            }
                          });
                        },
                      ),
                    ),
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
                Padding(
                  padding: const EdgeInsets.only(left: 230),
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
                  height: 25,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Expanded(
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: _login,
                              // onPressed: () async {
                              //   if (_formKey.currentState != null &&
                              //       _formKey.currentState!.validate()) {
                              //     try {
                              //       final request = LoginRequest(
                              //         email: _emailController.text,
                              //         password: _passwordController.text,
                              //         deviceToken: deviceToken!,
                              //       );

                              //       final response =
                              //           await ApiService().loginUser(request);

                              //       if (response.status == 'success') {
                              //         // Periksa status respon dari server
                              //         print(
                              //             'Login successful: ${response.message}');
                              //         ScaffoldMessenger.of(context).showSnackBar(
                              //           SnackBar(content: Text(response.message)),
                              //         );
                              //         Navigator.push(
                              //           context,
                              //           MaterialPageRoute(
                              //             builder: (context) => JenisPengajuan(),
                              //           ),
                              //         );
                              //       } else {
                              //         // Tampilkan pesan error jika status tidak 'success'
                              //         print('Login failed: ${response.message}');
                              //         ScaffoldMessenger.of(context).showSnackBar(
                              //           SnackBar(
                              //               content: Text(
                              //                   'Login failed: ${response.message}')),
                              //         );
                              //       }
                              //     } catch (e) {
                              //       print('Login failed: $e');
                              //       ScaffoldMessenger.of(context).showSnackBar(
                              //         SnackBar(content: Text('Login failed: $e')),
                              //       );
                              //     }
                              //   } else {
                              //     ScaffoldMessenger.of(context).showSnackBar(
                              //       SnackBar(content: Text('Formulir tidak valid')),
                              //     );
                              //   }
                              // },
                              child: const TextWidget(
                                  text: "sign in",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white))),
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
