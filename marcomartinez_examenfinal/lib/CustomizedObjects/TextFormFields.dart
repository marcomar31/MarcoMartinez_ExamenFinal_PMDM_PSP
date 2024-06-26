import 'package:flutter/material.dart';

class OnBoardingFormField extends StatelessWidget {
  final TextEditingController tec;
  final String label;
  final bool isPassword;
  final IconData? icon;
  final Color? iconColor;
  final String? mensajeError;

  const OnBoardingFormField({
    super.key,
    required this.tec,
    required this.label,
    required this.isPassword,
    this.icon,
    this.iconColor,
    this.mensajeError
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: iconColor != null
              ? Icon(icon, color: iconColor)
              : Icon(icon),
            ),
          Expanded(
            child: TextFormField(
              controller: tec,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(color: Color.fromRGBO(73, 73, 73, 1.0)),
                border: const OutlineInputBorder(),
              ),
              cursorColor: const Color.fromRGBO(35, 41, 49, 1),
              cursorHeight: 25,
              obscureText: isPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return mensajeError;
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
