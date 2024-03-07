import 'package:flutter/material.dart';
import 'package:marcomartinez_examenfinal/OnBoarding/LoginView.dart';
import 'package:marcomartinez_examenfinal/OnBoarding/RegisterView.dart';

import '../CustomizedObjects/Buttons.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<StatefulWidget> createState() => OnBoardingState();
}

class OnBoardingState extends State<OnBoarding> {
  late OnBoardingState onBoardingState;

  var selectedIndex = 0;
  bool isBtnLoginPulsado = true;
  bool isBtnRegisterPulsado = false;

  @override
  void initState() {
    super.initState();
    onBoardingState = this;
    updateSelectedIndex(0, true, false);
  }

  @override
  Widget build(BuildContext context) {
    Widget page;

    OnBoardingTopMenuButton btnLogin = OnBoardingTopMenuButton(
      text: 'LOGIN',
      function: () {
        updateSelectedIndex(0, true, false);
      },
      isPulsado: isBtnLoginPulsado,
    );

    OnBoardingTopMenuButton btnRegister = OnBoardingTopMenuButton(
      text: 'REGISTER',
      function: () {
        updateSelectedIndex(1, false, true);
      },
      isPulsado: isBtnRegisterPulsado,
    );

    switch (selectedIndex) {
      case 0:
        page = const LoginView();
        break;
      case 1:
        page = const RegisterView();
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

  void updateSelectedIndex(int index, bool isLoginSelected, bool isRegisterSelected) {
    setState(() {
      selectedIndex = index;
      isBtnLoginPulsado = isLoginSelected;
      isBtnRegisterPulsado = isRegisterSelected;
    });
  }
}