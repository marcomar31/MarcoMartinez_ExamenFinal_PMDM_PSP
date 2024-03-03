import 'package:flutter/material.dart';
import 'package:marcomartinez_examenfinal/Singleton/HttpAdmin.dart';

import '../CustomizedObjects/BigCard.dart';

class BoredApiView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BoredApiViewState();
}

class _BoredApiViewState extends State<BoredApiView> {
  HttpAdmin httpAdmin = HttpAdmin();
  String idea = "Pulsa el botón";

  @override
  Widget build(BuildContext context) {
    Widget body = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: BigCard(string: idea),
          ),
        ],
      ),
    );

    AppBar appBar = AppBar(
      title: const Text(
        "BOREDAPI",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: const Color.fromRGBO(2, 25, 52, 1.0),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );

    return Scaffold(
      appBar: appBar,
      backgroundColor: const Color.fromRGBO(10, 35, 65, 1.0),
      body: Center(child: body),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromRGBO(2, 25, 52, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                String nuevaIdea = await httpAdmin.pedirActividadRandom();
                setState(() {
                  idea = nuevaIdea;
                });
              },
              child: const Text('Obtener idea nueva'),
            ),
          ],
        ),
      ),
    );
  }
}
