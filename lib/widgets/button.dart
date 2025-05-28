import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isMobile;
  final bool color;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isMobile, 
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(isMobile ? 250 : 350, isMobile ? 48 : 60),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10 : 20,
          vertical: isMobile ? 14 : 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Bo cong mạnh
        ),
        backgroundColor: color ? Color(0xFF5F33E1) : Colors.white,
        foregroundColor: color ? Colors.white : Color(0xFF5F33E1),
        textStyle: TextStyle(
          fontSize: isMobile ? 14 : 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
