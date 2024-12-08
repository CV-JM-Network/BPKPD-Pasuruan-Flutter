import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({super.key, required this.passwordController});

  final TextEditingController passwordController;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.passwordController,
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: 'Enter your password',
        hintStyle:
            TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w400),
        prefixIcon: const Icon(
          Icons.lock_outlined,
        ),
        prefixIconColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.focused) ? Colors.green : Colors.grey),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.green,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.green, width: 2.0),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
