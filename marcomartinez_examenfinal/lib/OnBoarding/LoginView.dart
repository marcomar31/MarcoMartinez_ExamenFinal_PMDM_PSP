import 'package:flutter/material.dart';
import 'package:marcomartinez_examenfinal/CustomizedObjects/TextFormFields.dart';
import 'package:marcomartinez_examenfinal/Singleton/FirebaseAdmin.dart';

import '../CustomizedObjects/Buttons.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  late BuildContext _context = _context;

  FirebaseAdmin fbAdmin = FirebaseAdmin();
  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _context = context;

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
              child: RoundedGreenButton(text: "ACEPTAR", function: _iniciarSesion),
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

  Future<void> _iniciarSesion() async {
    if (await fbAdmin.logInWithEmail(tecEmail.text, tecPassword.text)) {
      Navigator.of(_context).popAndPushNamed("/home_view");
    }
  }
}