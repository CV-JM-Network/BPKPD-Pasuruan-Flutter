import 'package:bpkpd_pasuruan_app/screens/login.dart';
import 'package:bpkpd_pasuruan_app/screens/widget/passwordField_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api_service/api_service.dart';
import '../api_service/registrasi/registration_request.dart';
import '../api_service/wa_api_service.dart';
import 'verification_code.dart';
import 'widget/inputField_widget.dart';
import 'widget/text_widget.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isFocused = false;
  int? _sliding = 1;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _telponController = TextEditingController();
  String? deviceToken = "deviceId"; // Initialize with null

  final _apiService = OCAWaApiService();

  bool _isLoading = false;

  void _sendMessage() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 246, 248, 247),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                              if (newValue == 0) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()));
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
                    height: 55,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 55),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    final request = RegistrationRequest(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      nama: _namaController.text,
                                      alamat: _alamatController.text,
                                      telpon: _telponController.text,
                                      deviceToken: deviceToken!,
                                    );

                                    final response = await ApiService()
                                        .registerUser(request);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(response.message)),
                                    );

                                    _sendMessage();
                                    // Navigate to Confirmation Screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VerificationCode(
                                          email: _emailController.text,
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Registration failed: $e')),
                                    );
                                  }
                                }
                              },
                              child: const TextWidget(
                                  text: "Sign up",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

Widget buildSegment(String text) => Container(
      padding: EdgeInsets.all(10),
      child: Text(text),
    );
