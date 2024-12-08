import 'package:bpkpd_pasuruan_app/screens/login.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'widget/text_widget.dart';

class VerificationCode extends StatefulWidget {
  const VerificationCode({super.key, required this.email});

  final String email;

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  bool isFocused = false;

  final _codeController = TextEditingController();
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    EmailOTP.config(
      appName: 'BPKPD Pasuruan App',
      otpType: OTPType.numeric,
      emailTheme: EmailTheme.v3,
      appEmail: 'me@jaylangkung.com',
      otpLength: 4,
    );
  }

  Future<void> _verifyOTP(String pin) async {
    try {
      bool isVerified = await EmailOTP.verifyOTP(otp: pin);

      if (isVerified) {
        // Navigate to the next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Invalid OTP';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Verification failed: $e';
      });
    }
  }

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
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                        child: TextWidget(
                            text: "Verification Code",
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
                text: "Verification Code",
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800]),
            const SizedBox(
              height: 10,
            ),
            TextWidget(
                text:
                    "Please enter the verification code that we sent to your email ${widget.email}",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey[700]),
            const SizedBox(
              height: 45,
            ),
            SizedBox(
              width: double.infinity,
              child: Pinput(
                length: 4,
                crossAxisAlignment: CrossAxisAlignment.center,
                onChanged: (value) {
                  if (value.length == 4) {
                    _verifyOTP(value);
                  }
                },
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Center(
              child: Column(
                children: [
                  TextWidget(
                    text: "Didn't receive code?",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700],
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
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
                    onTap: () {},
                    child: TextWidget(
                        text: "Resend",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isFocused ? Colors.green : Colors.grey[700]),
                  ),
                ],
              ),
            ),

            // const SizedBox(
            //   height: 100,
            // ),
            // const ButtonWidget(
            //   text: "Submit",
            // ),
          ],
        ),
      ),
    );
  }
}
