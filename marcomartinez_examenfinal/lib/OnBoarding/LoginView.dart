import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    Column column = const Column(
      children: [
      ],
    );


    AppBar appBar = AppBar(
      title: const Text(
        "LOGIN",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: const Color.fromRGBO(35, 41, 49, 1),
      automaticallyImplyLeading: false,
    );


    return Scaffold(
      body: SingleChildScrollView(child: column),
      appBar: appBar,
      backgroundColor: const Color.fromRGBO(57, 62, 70, 1),
    );
  }
}