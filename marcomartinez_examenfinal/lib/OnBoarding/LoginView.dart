import 'package:flutter/material.dart';
import 'package:marcomartinez_examenfinal/CustomizedObjects/TextFormFields.dart';

import '../CustomizedObjects/Buttons.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController tecEmail = TextEditingController();
    TextEditingController tecPassword = TextEditingController();

    Column column = Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
          child: OnBoardingFormField(tec: tecEmail, label: "Email", isPassword: false)
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
          child: OnBoardingFormField(tec: tecPassword, label: "Password", isPassword: true)
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: RoundedGreenButton(text: "ACEPTAR", function: () {}),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: RoundedGreenButton(text: "REGISTRARSE", function: () {}),
            ),
          ],
        ),
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
      body: SingleChildScrollView(child: Center(child: column)),
      appBar: appBar,
      backgroundColor: const Color.fromRGBO(57, 62, 70, 1),
    );
  }
}