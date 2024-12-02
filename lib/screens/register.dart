import 'package:bpkpd_pasuruan_app/screens/login.dart';
import 'package:bpkpd_pasuruan_app/screens/widget/passwordField_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget/emailField_widget.dart';
import 'widget/text_widget.dart';
import 'widget/usernameField_widget.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _obscureText = true;
  bool isFocused = false;
  int? _sliding = 1;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

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
                  text: "Username",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
                const SizedBox(
                  height: 15,
                ),
                const UsernameField(),
                const SizedBox(
                  height: 25,
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
                const EmailField(),
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
                const PasswordField(),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
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
                          onPressed: () {},
                          child: const TextWidget(
                              text: "Sign up",
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
      padding: EdgeInsets.all(10),
      child: Text(text),
    );
