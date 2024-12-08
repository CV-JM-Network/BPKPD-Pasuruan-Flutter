import 'package:bpkpd_pasuruan_app/screens/widget/text_widget.dart';
import 'package:flutter/material.dart';

import 'widget/category_grid.dart';

class JenisPengajuan extends StatefulWidget {
  const JenisPengajuan({super.key});

  @override
  State<JenisPengajuan> createState() => _JenisPengajuanState();
}

class _JenisPengajuanState extends State<JenisPengajuan> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 248, 247),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Image.asset('assets/logo.png'),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.menu_rounded),
          ),
        ],
        title: const Text("BPKPD Pasuruan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
                text: "Welcome, Mutia",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800]),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: width,
              height: 120,
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
            ),
            const SizedBox(
              height: 25,
            ),
            TextWidget(
                text: "Jenis Pengajuan",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800]),
            const SizedBox(
              height: 15,
            ),
            GridView(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 20),
              children: const [
                CategoryGrid(
                  text: "NPWPD",
                ),
                CategoryGrid(
                  text: "PBB",
                ),
                CategoryGrid(
                  text: "NPWPD",
                ),
                CategoryGrid(
                  text: "NPWPD",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
