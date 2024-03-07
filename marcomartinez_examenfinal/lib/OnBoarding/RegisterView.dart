import 'package:flutter/material.dart';
import 'package:marcomartinez_examenfinal/CustomizedObjects/TextFormFields.dart';
import 'package:marcomartinez_examenfinal/Singleton/FirebaseAdmin.dart';

import '../CustomizedObjects/Buttons.dart';
import '../Singleton/PlatformAdmin.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late BuildContext _context = _context;

  late GlobalKey<FormState> _formKey;

  FirebaseAdmin fbAdmin = FirebaseAdmin();
  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecPassword = TextEditingController();
  TextEditingController tecRePassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    double screenWidth = PlatformAdmin.getScreenWidth(context);

    Column column = Column(
      children: [
        SizedBox(
          width: (screenWidth < 600) ? PlatformAdmin.getScreenWidth(context)-50 : 600,
          child: Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: OnBoardingFormField(tec: tecEmail, label: "Email", isPassword: false, icon: Icons.email_rounded, iconColor: const Color.fromRGBO(115, 208, 156, 1.0), mensajeError: "Por favor, ingrese su email"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: OnBoardingFormField(tec: tecPassword, label: "Password", isPassword: true, icon: Icons.lock_rounded, iconColor: const Color.fromRGBO(115, 208, 156, 1.0), mensajeError: "Por favor, ingrese su contraseña"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: OnBoardingFormField(tec: tecRePassword, label: "Repeat password", isPassword: true, icon: Icons.lock_rounded, iconColor: const Color.fromRGBO(115, 208, 156, 1.0), mensajeError: "Repita su contraseña"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: RoundedGreenButton(text: "REGISTRARSE", function: _creaUsuario),
                      ),
                    ],
                  ),
                ],
              ),
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

  Future<void> _creaUsuario() async {
    if (_formKey.currentState!.validate()) {
      await fbAdmin.createUser(
          tecEmail.text, tecPassword.text, tecRePassword.text, _context);
    }
  }
}
