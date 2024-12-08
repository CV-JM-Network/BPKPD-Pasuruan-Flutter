import 'package:bpkpd_pasuruan_app/screens/register.dart';
import 'package:flutter/material.dart';

void main() {
  // runApp(DevicePreview(
  //   builder: (context) => const MyApp(),
  // ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Register(),
    );
  }
}
