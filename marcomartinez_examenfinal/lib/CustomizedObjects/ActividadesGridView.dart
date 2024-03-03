import 'package:flutter/material.dart';

import '../FirestoreObjects/FActividad.dart';
import 'ActividadesListView.dart';

class PostGridCellView extends StatelessWidget {

  final List<FActividad> posts;

  const PostGridCellView({
    super.key,
    required this.posts,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
      ),
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(color: Colors.blue,
          alignment: Alignment.center,child:
          PostCellView(
            sText: posts[index].nombre,
            dFontSize: 20,
          ),
        );
      },
    );

  }
}