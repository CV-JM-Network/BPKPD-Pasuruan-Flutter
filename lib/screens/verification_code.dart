import 'package:bpkpd_pasuruan_app/api_service/wa_api_service.dart';
import 'package:bpkpd_pasuruan_app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../api_service/api_service.dart';
import '../api_service/registrasi/confirmation_request.dart';
import 'widget/text_widget.dart';

class VerificationCode extends StatefulWidget {
  const VerificationCode(
      {super.key, this.email, required this.phone_number, required this.nama});

  final String phone_number;
  final String nama;

  final String? email;

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  bool isFocused = false;
  final OCAWaApiService _apiService = OCAWaApiService();
  final ApiService apiService = ApiService();

  final _codeController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = true;

  Future<void> _sendMessage() async {
    final phoneNumber = widget.phone_number;
    final name = widget.nama;
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

  void _verifyOTP(String otp) async {
    setState(() {
      _isLoading = true; // Tampilkan indikator loading
    });

    try {
      final deviceToken = await apiService.getDeviceId();
      final request = ConfirmationRequest(
        kodeKonfirmasi: otp,
        deviceId: deviceToken, // Device ID asli
      );

      final response = await ApiService().confirmRegistration(request);

      if (response.status == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid OTP. Please try again.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Verification failed: $e")),
      );
      print(e);
    } finally {
      setState(() {
        _isLoading = false; // Sembunyikan indikator loading
      });
    }
  }

  // void _verifyOTP(String otp) async {
  //   setState(() {
  //     _isLoading = true; // Tampilkan indikator loading
  //   });

  //   try {
  //     final request = ConfirmationRequest(
  //       kodeKonfirmasi: otp,
  //       deviceId: 'blablab', // Sesuaikan dengan device ID yang dikirimkan
  //     );

  //     // Panggil API untuk verifikasi OTP
  //     final response = await ApiService().confirmRegistration(request);

  //     if (response.status == "success") {
  //       // OTP valid
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(response.message)),
  //       );

  //       // Navigasi ke halaman berikutnya
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => Login()),
  //       );
  //     } else {
  //       // OTP tidak valid
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Invalid OTP. Please try again.")),
  //       );
  //     }
  //   } catch (e) {
  //     // Tangani error
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Verification failed: $e")),
  //     );
  //   } finally {
  //     setState(() {
  //       _isLoading = false; // Sembunyikan indikator loading
  //     });
  //   }
  // }

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
                    onTap: _sendMessage,
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
