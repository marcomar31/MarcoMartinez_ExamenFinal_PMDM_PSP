import 'package:flutter/material.dart';

import '../Singleton/PlatformAdmin.dart';

class ActividadesListView extends StatelessWidget {
  final String sText;
  final double dFontSize;
  final int iPosicion;
  final String? imageUrl;
  final Function(int indice)? onPressed;

  const ActividadesListView({
    super.key,
    required this.sText,
    required this.dFontSize,
    this.imageUrl,
    required this.iPosicion,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
        onPressed!(iPosicion);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        height: 70,
        child: Row(
          children: [
            if (imageUrl != null)
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: PlatformAdmin.isWebPlatform()
                ? const SizedBox(
                    width: 50,
                    height: 50,
                    // child: createImageCodecFromUrl(),
                  )
                : Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
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
      ),
    );
  }
}
