import 'package:bpkpd_pasuruan_app/screens/widget/button_widget.dart';
import 'package:bpkpd_pasuruan_app/screens/widget/text_widget.dart';
import 'package:flutter/material.dart';

class FormPengajuan extends StatefulWidget {
  const FormPengajuan({super.key});

  @override
  State<FormPengajuan> createState() => _FormPengajuanState();
}

class _FormPengajuanState extends State<FormPengajuan> {
  final _currencies = [
    "Food",
    "Transport",
    "Personal",
    "Shopping",
    "Medical",
    "Rent",
    "Movie",
    "Salary"
  ];
  String? _currentSelectedValue = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 248, 247),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const Icon(Icons.arrow_back_ios_new_rounded),
        title: const Text("Permohonan NPWPD"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
                text: "Form Permohonan NPWPD",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600]),
            const SizedBox(
              height: 25,
            ),
            TextWidget(
                text: "Jenis Pengajuan",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600]),
            const SizedBox(
              height: 15,
            ),
            TextField(
              enabled: false,
              decoration: InputDecoration(
                labelText: 'NPWPD',
                border: OutlineInputBorder(
                  // borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Text.rich(TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red),
                children: [
                  TextSpan(
                      text: 'Tipe',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w700))
                ])),
            // TextWidget(
            //     text: "Tipe",
            //     fontSize: 14,
            //     fontWeight: FontWeight.w600,
            //     color: Colors.grey[600]),
            const SizedBox(
              height: 15,
            ),
            FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                      labelText: 'Pilih Tipe',
                      errorStyle: const TextStyle(
                          color: Colors.redAccent, fontSize: 16.0),
                      hintText: 'Silakan pilih tipe',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0))),
                  isEmpty: _currentSelectedValue == 'Silakan pilih tipe',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: _currentSelectedValue,
                      isDense: true,
                      onChanged: (String? newValue) => setState(() {
                        _currentSelectedValue = newValue;
                        state.didChange(newValue);
                      }),
                      items: _currencies.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 25,
            ),
            Text.rich(TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red),
                children: [
                  TextSpan(
                      text: 'Isi',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w700))
                ])),
            // TextWidget(
            //     text: "Isi",
            //     fontSize: 14,
            //     fontWeight: FontWeight.w600,
            //     color: Colors.grey[600]),
            const SizedBox(
              height: 15,
            ),
            FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                      labelText: 'Pilih ',
                      errorStyle: const TextStyle(
                          color: Colors.redAccent, fontSize: 16.0),
                      hintText: 'Silakan pilih tipe',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0))),
                  isEmpty: _currentSelectedValue == 'Silakan pilih tipe',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: _currentSelectedValue,
                      isDense: true,
                      onChanged: (String? newValue) => setState(() {
                        _currentSelectedValue = newValue;
                        state.didChange(newValue);
                      }),
                      items: _currencies.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Text.rich(TextSpan(
                text: "(*) ",
                style: const TextStyle(color: Colors.red),
                children: [
                  TextSpan(
                      text: "Wajib Diisi",
                      style: TextStyle(
                          color: Colors.grey[800], fontWeight: FontWeight.w600))
                ])),
            const SizedBox(
              height: 65,
            ),
            ButtonWidget(text: 'Submit')
          ],
        ),
      ),
    );
  }
}
