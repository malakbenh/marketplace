import 'package:flutter/material.dart';


import '../../../../../model_widgets/custom_page.dart';

class ProductDetailScreen1 extends StatelessWidget {
  const ProductDetailScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    const String productName = 'Protein';
    const String price = "650.00";
    const String imagePath =
        'asset/images/Favorite/Rectangle 19.png'; 
    const String description =
        "Les protéines sont composées de 20 acides aminés. Lysine, arginine, leucine, valine, méthionine";
    return const ProductDetailPageCustom(
      productName: productName,
      price: price,
      imagePath: imagePath,
      description: description,
    );
  }
}
