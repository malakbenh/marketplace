import 'package:flutter/material.dart';
import 'package:vitafit/src/mvc/view/screens/main_store/healthy_product/favorite.dart';

import '../const/app_const.dart';
import 'SubPages/Favorite/discribtion_fav1.dart';
import 'SubPages/Favorite/discribtion_fav2.dart';
import 'SubPages/Favorite/discribtion_fav3.dart';
import 'favorite.dart';
import 'favorite.dart';

class Favorite extends StatelessWidget {
  const Favorite({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite"),
        centerTitle: true,
      ),
      body: GridView.builder(
        itemCount: Banners.sportMaterials.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              if (index == 0) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const ProductDetailScreen1();
                }));
              } else if (index == 1) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const ProductDetailPage2();
                }));
              } else if (index == 2) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const ProductDetailPage3();
                }));
              } else {}
            },
            child: Banners.Favorite[index],
          );
        },
      ),
    );
  }
}
