import 'dart:convert';

import 'package:bpkpd_pasuruan_app/screens/password_verification.dart';
import 'package:bpkpd_pasuruan_app/screens/widget/text_widget.dart';
import 'package:flutter/material.dart';

import '../api_service/api_service.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _forgotPassword() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response =
          await _apiService.forgotPassword(_emailController.text.trim());

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'Success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'])),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => PaasswordVerification(
                      email: _emailController.text.trim(),
                    )),
          );
        } else {
          setState(() {
            _errorMessage =
                'Failed to send password reset link: ${responseData['message']}';
          });
        }
      } else if (response.statusCode == 400) {
        setState(() {
          _errorMessage =
              'Bad Request: ${jsonDecode(response.body)['message']}';
        });
      } else if (response.statusCode == 500) {
        setState(() {
          _errorMessage = 'Internal Server Error';
        });
      } else {
        setState(() {
          _errorMessage =
              'Failed to send password reset link: HTTP Status Code ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
      print('Exception: $e');
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
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios_rounded)),
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
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  errorText: _errorMessage,
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
                    borderSide:
                        const BorderSide(color: Colors.green, width: 2.0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
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
                        onPressed: _forgotPassword,
                        child: Text(
                          'Send Reset Link',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
