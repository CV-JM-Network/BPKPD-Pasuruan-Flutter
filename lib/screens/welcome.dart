import 'package:flutter/material.dart';

import 'widget/text_widget.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              scale: 1.5,
            ),
            const SizedBox(
              height: 35,
            ),
            TextWidget(
              text: "BPKPD Pasuruan",
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
            const SizedBox(
              height: 15,
            ),
            TextWidget(
              text:
                  "Scelerisque duis non eget morbi ac ac lacus pretium. Euismod dolor ut risus aenean etiam commodo sodales orci. ",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
