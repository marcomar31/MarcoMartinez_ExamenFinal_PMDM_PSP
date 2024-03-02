import 'package:flutter/material.dart';
import 'package:marcomartinez_examenfinal/OnBoarding/LoginView.dart';
import 'package:marcomartinez_examenfinal/OnBoarding/RegisterView.dart';

import '../CustomizedObjects/Buttons.dart';

class OnBoarding extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  var selectedIndex = 0;
  bool isBtnLoginPulsado = true;
  bool isBtnRegisterPulsado = false;

  @override
  Widget build(BuildContext context) {
    Widget page;

    OnBoardingTopMenuButton btnLogin = OnBoardingTopMenuButton(
      text: 'LOGIN',
      function: () {
        setState(() {
          selectedIndex = 0;
          isBtnLoginPulsado = true;
          isBtnRegisterPulsado = false;
        });
      },
      isPulsado: isBtnLoginPulsado,
    );

    OnBoardingTopMenuButton btnRegister = OnBoardingTopMenuButton(
      text: 'REGISTER',
      function: () {
        setState(() {
          selectedIndex = 1;
          isBtnLoginPulsado = false;
          isBtnRegisterPulsado = true;
        });
      },
      isPulsado: isBtnRegisterPulsado,
    );

    switch (selectedIndex) {
      case 0:
        page = LoginView();
        break;
      case 1:
        page = RegisterView();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        backgroundColor: const Color.fromRGBO(10, 35, 65, 1.0),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  btnLogin,
                  const SizedBox(width: 50,),
                  btnRegister
              ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Container(
                  color: const Color.fromRGBO(10, 35, 65, 1.0),
                  child: page,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}