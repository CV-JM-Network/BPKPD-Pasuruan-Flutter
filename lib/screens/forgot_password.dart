import 'package:bpkpd_pasuruan_app/screens/widget/text_widget.dart';
import 'package:flutter/material.dart';

import 'widget/button_widget.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 248, 247),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 65,
            ),
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.arrow_back_ios_rounded),
                ),
                const SizedBox(
                  width: 35,
                ),
                Expanded(
                  child: Container(
                    height: 40,
                    // width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                        child: TextWidget(
                            text: "Forgot Password",
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800])),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 35,
            ),
            TextWidget(
                text: "Forgot password?",
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800]),
            const SizedBox(
              height: 10,
            ),
            TextWidget(
                text:
                    "Fill in your email and we'll send a code to reset your password",
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
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your email',
                hintStyle: TextStyle(
                    color: Colors.grey[500], fontWeight: FontWeight.w400),
                prefixIcon: const Icon(
                  Icons.email_outlined,
                ),
                prefixIconColor: WidgetStateColor.resolveWith((states) =>
                    states.contains(WidgetState.focused)
                        ? Colors.green
                        : Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.green, width: 2.0),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            ButtonWidget(
              text: "Submit",
            ),
          ],
        ),
      ),
    );
  }
}
