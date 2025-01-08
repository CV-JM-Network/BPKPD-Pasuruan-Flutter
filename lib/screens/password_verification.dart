import 'dart:convert';

import 'package:bpkpd_pasuruan_app/screens/new_password.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../api_service/api_service.dart';
import '../api_service/wa_api_service.dart';
import 'widget/text_widget.dart';

class PaasswordVerification extends StatefulWidget {
  const PaasswordVerification({super.key, required this.email});

  final String email;

  @override
  State<PaasswordVerification> createState() => _PaasswordVerificationState();
}

class _PaasswordVerificationState extends State<PaasswordVerification> {
  bool isFocused = false;
  final OCAWaApiService _apiService = OCAWaApiService();
  final ApiService apiService = ApiService();

  final _codeController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = true;

  Future<void> _verifyCode(String otp) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await apiService.verifyCode(
        otp,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'Success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'])),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => NewPassword(
                      email: widget.email.toString(),
                    )),
          );
        } else {
          setState(() {
            _errorMessage = 'Verification failed: ${responseData['message']}';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Verification failed: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
      print('Exception: $e'); // Log the exception for debugging
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
                    "Please enter the verification code that we sent to your WhatsApp number",
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
                    _verifyCode(value);
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
