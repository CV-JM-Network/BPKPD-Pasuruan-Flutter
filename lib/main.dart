import 'package:bpkpd_pasuruan_app/screens/login.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';

void main() {
  // runApp(DevicePreview(
  //   builder: (context) => const MyApp(),
  // ));
  EmailOTP.config(
    appName: 'BPKPD Pasuruan App',
    otpType: OTPType.numeric,
    emailTheme: EmailTheme.v3,
    appEmail: 'me@jaylangkung.com',
    otpLength: 4,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Login(),
    );
  }
}
