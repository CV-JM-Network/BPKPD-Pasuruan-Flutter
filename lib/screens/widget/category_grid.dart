import 'package:flutter/material.dart';

import 'text_widget.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Image.asset('assets/tax.png'),
            ),
            const SizedBox(
              height: 9,
            ),
            TextWidget(
                text: text,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700])
          ],
        ),
      ),
    );
  }
}
