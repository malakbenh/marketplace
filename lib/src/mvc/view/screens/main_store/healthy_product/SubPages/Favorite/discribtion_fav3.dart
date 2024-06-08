import 'package:flutter/material.dart';


import '../../../../../model_widgets/custom_page.dart';

class ProductDetailPage3 extends StatelessWidget {
  const ProductDetailPage3({super.key});

  @override
  Widget build(BuildContext context) {
    const String productName = 'Protein';
    const String price = "1500";
    final List<String> sizes = ['2kg', '3kg', '4kg', '5kg', '7kg'];
    final List<Color> colors = [
      const Color(0xff000000),
      const Color(0xff435E33),
      const Color(0xff74450E),
    ];
    const String imagePath = 'asset/images/Favorite/pngwing 3 (1).png';
    const String description =
        "L’entraînement d'haltères est l'un des sports de force les plus efficaces et est idéal pour construire et maintenir les muscles du bras, de la poitrine et du dos. ";
    return ProductDetailPageCustom(
      productName: productName,
      price: price,
      sizes: sizes,
      colors: colors,
      imagePath: imagePath, description: description, 
    );
  }
}
