import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController tecEmail = TextEditingController();
    TextEditingController tecPassword = TextEditingController();

    Column column = Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
          child: TextFormField(
            controller: tecEmail,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Email",
              labelStyle: TextStyle(color: Colors.white),
            ),
            cursorColor: const Color.fromRGBO(22, 36, 71, 1),
          ),

        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
          child: TextFormField(
            controller: tecPassword,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Password",
              labelStyle: TextStyle(color: Colors.white),
            ),
            cursorColor: const Color.fromRGBO(35, 41, 49, 1),
            obscureText: true,
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: TextButton(onPressed: () {}, child: const Text("ACEPTAR")),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: TextButton(onPressed: () {}, child: const Text("REGISTRARSE")),
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
      body: SingleChildScrollView(child: column),
      appBar: appBar,
      backgroundColor: const Color.fromRGBO(57, 62, 70, 1),
    );
  }
}