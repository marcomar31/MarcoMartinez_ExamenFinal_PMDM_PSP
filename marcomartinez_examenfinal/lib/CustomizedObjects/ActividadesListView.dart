import 'package:flutter/material.dart';

class PostCellView extends StatelessWidget {

  final String sText;
  final double dFontSize;

  const PostCellView ({super.key,
    required this.sText,
    required this.dFontSize
  });

  @override
  Widget build(BuildContext context) {
    return Text(sText,
      style: TextStyle(
          color: Colors.white,
          fontSize: dFontSize),
    );
  }

}