import 'package:flutter/material.dart';

class ActividadesListView extends StatelessWidget {
  final String sText;
  final double dFontSize;
  final String? imageUrl;

  const ActividadesListView({
    Key? key,
    required this.sText,
    required this.dFontSize,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          if (imageUrl != null)
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ),
          Expanded(
            child: Text(
              sText,
              style: TextStyle(
                color: Colors.white,
                fontSize: dFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
