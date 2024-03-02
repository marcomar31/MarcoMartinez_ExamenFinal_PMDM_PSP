import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marcomartinez_examenfinal/CustomizedObjects/TextFormFields.dart';
import 'package:marcomartinez_examenfinal/OnBoarding/PhoneLoginView.dart';
import 'package:marcomartinez_examenfinal/Singleton/FirebaseAdmin.dart';

import '../CustomizedObjects/Buttons.dart';
import '../Singleton/PlatformAdmin.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  late final BuildContext _context;

  final FirebaseAdmin fbAdmin = FirebaseAdmin();
  final TextEditingController tecEmail = TextEditingController();
  final TextEditingController tecPassword = TextEditingController();

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: OnBoardingFormField(tec: tecEmail, label: "Email", isPassword: false, icon: Icons.email_rounded, iconColor: const Color.fromRGBO(115, 208, 156, 1.0),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: OnBoardingFormField(tec: tecPassword, label: "Password", isPassword: true, icon: Icons.lock_rounded, iconColor: const Color.fromRGBO(115, 208, 156, 1.0),),
                ),
                if (PlatformAdmin.isAndroidPlatform() || PlatformAdmin.isIOSPlatform())
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: GestureDetector(
                        child: const Text(
                          'Iniciar sesión con número de teléfono',
                          style: TextStyle(
                            color: Color.fromRGBO(115, 208, 156, 1.0),
                            decoration: TextDecoration.underline,
                            decorationColor: Color.fromRGBO(115, 208, 156, 1.0),
                          ),
                        ),
                        onTap: () async {
                          await SystemChannels.textInput.invokeMethod('TextInput.hide');
                            showModalBottomSheet(
                              context: context,
                              isDismissible: false,
                              builder: (BuildContext context) {
                                return PhoneLoginView();
                              },
                            );
                          },
                      ),
                    ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
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
      if (await fbAdmin.descargarPerfil() != null) {
        Navigator.of(_context).popAndPushNamed("/home_view");
      } else {
        Navigator.of(_context).popAndPushNamed("/creaperfil_view");
      }
    }
  }
}