import 'package:flutter/material.dart';

import 'Main/HomeView.dart';
import 'OnBoarding/LoginView.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Examen Marco 2Ev",
      routes: {
        '/login_view': (context) => LoginView(),
        '/home_view': (context) => HomeView()
      },
      initialRoute: '/login_view',
      debugShowCheckedModeBanner: false,
    );
  }
  
}