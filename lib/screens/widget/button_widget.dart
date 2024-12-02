import 'package:bpkpd_pasuruan_app/screens/verification_code.dart';
import 'package:flutter/material.dart';

import 'text_widget.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    required this.text,
    this.navigator,
    super.key,
  });

  final String text;
  final Navigator? navigator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VerificationCode()));
                ;
              },
              child: TextWidget(
                  text: text,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white))),
    );
  }
}
