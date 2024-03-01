import 'package:flutter/material.dart';
import 'package:marcomartinez_examenfinal/OnBoarding/CreaPerfilView.dart';
import 'package:marcomartinez_examenfinal/OnBoarding/OnBoarding.dart';

import 'Main/HomeView.dart';
import 'OnBoarding/LoginView.dart';
import 'OnBoarding/RegisterView.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Examen Marco 2Ev",
      routes: {
        '/onboarding_view': (context) => OnBoarding(),
        '/login_view': (context) => LoginView(),
        '/register_view': (context) => RegisterView(),
        '/creaperfil_view': (context) => const CreaPerfilView(),
        '/home_view': (context) => const HomeView(),
      },
      initialRoute: '/onboarding_view',
      debugShowCheckedModeBanner: false,
    );
  }
  
}