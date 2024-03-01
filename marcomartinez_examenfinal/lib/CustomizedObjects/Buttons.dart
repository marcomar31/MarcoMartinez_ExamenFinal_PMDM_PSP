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

class OnBoardingTopMenuButton extends StatelessWidget {
  final String text;
  final VoidCallback  function;
  final bool isPulsado;

  const OnBoardingTopMenuButton({super.key,
    required this.text,
    required this.function,
    required this.isPulsado
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 90,
      child: TextButton(
          onPressed: function,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: isPulsado ? const Color.fromRGBO(30, 51, 79, 1.0) : Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(70), topRight: Radius.circular(70), bottomLeft: Radius.elliptical(120, 160), bottomRight: Radius.elliptical(120, 160)),
            ),
          ),
          child: Text(text)
      ),
    );
  }

}