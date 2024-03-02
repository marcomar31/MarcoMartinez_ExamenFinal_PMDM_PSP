import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../CustomizedObjects/Buttons.dart';
import '../CustomizedObjects/TextFormFields.dart';
import '../Singleton/FirebaseAdmin.dart';

class PhoneLoginView extends StatefulWidget {
  const PhoneLoginView({super.key});

  @override
  State<StatefulWidget> createState() => _PhoneLoginViewState();
}

class _PhoneLoginViewState extends State<PhoneLoginView> {
  FirebaseAdmin fbAdmin = FirebaseAdmin();

  TextEditingController tecTelefono = TextEditingController();
  TextEditingController tecCodigo = TextEditingController();

  String sVerificationCode="";
  bool blMostrarVerificacion = false;

  void enviarTelefonoClicked() async {
    String sTelefono = tecTelefono.text;
    if (sTelefono.isNotEmpty) {
      await fbAdmin.verificarTelefono(
          sTelefono,
          verificacionCompletada,
          verificacionFallida,
          codeSent,
          codeAutoRetrievalTimeout
      );
    }
  }

  Future<void> enviarVerificacionClicked() async {
    String smsCode = tecCodigo.text;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: sVerificationCode, smsCode: smsCode);

    if (await fbAdmin.signInWithPhoneNumber(credential)) {
      if (await fbAdmin.descargarPerfil() != null) {
        Navigator.of(context).popAndPushNamed("/home_view");
      } else {
        Navigator.of(context).popAndPushNamed("/creaperfil_view");
      }
    }
  }

  void verificacionCompletada(PhoneAuthCredential p1) async{
    Navigator.of(context).popAndPushNamed("/home_view");
  }

  void verificacionFallida(FirebaseAuthException error) {
    if (error.code == 'invalid-phone-number') {
      print('The provided phone number is not valid.');
    }
  }


  void codeSent(String verificationId, int? forceResendingToken) async {
    sVerificationCode = verificationId;
    setState(() {
      blMostrarVerificacion = true;
    });
  }

  void codeAutoRetrievalTimeout(String verificationId) {

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 500,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: OnBoardingFormField(tec: tecTelefono, label: "Número de teléfono", isPassword: false),
              ),
              if (blMostrarVerificacion)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                  child: Text(
                    'Código de verificación enviado',
                    style: TextStyle(
                      color: Color.fromRGBO(115, 208, 156, 1.0),
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: RoundedGreenButton(text: "ENVIAR TELÉFONO", function: enviarTelefonoClicked),
                  ),
                ],
              ),
              if (blMostrarVerificacion)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: OnBoardingFormField(tec: tecCodigo, label: "Código de verificación", isPassword: false),
                ),
              if (blMostrarVerificacion)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: RoundedGreenButton(text: "VERIFICAR", function: enviarVerificacionClicked),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}