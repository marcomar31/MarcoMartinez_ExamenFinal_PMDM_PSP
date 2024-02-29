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
        const SizedBox(height: 90),
        SizedBox(
          height: 300,
          width: 400,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  child: OnBoardingFormField(tec: tecEmail, label: "Email", isPassword: false, icon: Icons.email_rounded, iconColor: const Color.fromRGBO(115, 208, 156, 1.0),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  child: OnBoardingFormField(tec: tecPassword, label: "Password", isPassword: true, icon: Icons.lock_rounded, iconColor: const Color.fromRGBO(115, 208, 156, 1.0),),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      child: RoundedGreenButton(text: "LOGIN", function: _iniciarSesion),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );

    return Scaffold(
      body: SingleChildScrollView(child: Center(child: column)),
      backgroundColor: const Color.fromRGBO(10, 35, 65, 1.0),
    );
  }

  Future<void> _iniciarSesion() async {
    if (await fbAdmin.logInWithEmail(tecEmail.text, tecPassword.text)) {
      Navigator.of(_context).popAndPushNamed("/home_view");
    }
  }
}