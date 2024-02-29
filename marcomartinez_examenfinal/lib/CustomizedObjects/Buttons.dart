import 'package:flutter/material.dart';

class RoundedGreenButton extends StatelessWidget {
  final String text;
  final VoidCallback  function;

  const RoundedGreenButton({super.key,
    required this.text,
    required this.function
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: function,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromRGBO(115, 208, 156, 1.0),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: Text(text)
    );
  }

}