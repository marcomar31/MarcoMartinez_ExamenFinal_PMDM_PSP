import 'package:flutter/material.dart';

class OnBoardingFormField extends StatelessWidget {
  final TextEditingController tec;
  final String label;
  final bool isPassword;

  const OnBoardingFormField({super.key,
    required this.tec,
    required this.label,
    required this.isPassword
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      child: TextFormField(
        controller: tec,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
        ),
        cursorColor: const Color.fromRGBO(35, 41, 49, 1),
        cursorHeight: 25,
        obscureText: isPassword,
      ),
    );
  }

}