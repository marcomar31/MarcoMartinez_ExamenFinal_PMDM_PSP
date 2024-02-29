import 'package:flutter/material.dart';

import 'Main/HomeView.dart';
import 'OnBoarding/LoginView.dart';
import 'OnBoarding/RegisterView.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Examen Marco 2Ev",
      routes: {
        '/login_view': (context) => LoginView(),
        '/register_view': (context) => RegisterView(),
        '/home_view': (context) => HomeView()
      },
      initialRoute: '/login_view',
      debugShowCheckedModeBanner: false,
    );
  }
  
}