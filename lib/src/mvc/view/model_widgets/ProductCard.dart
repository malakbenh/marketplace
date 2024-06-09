import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String price;
  final String? originalPrice;
  final double rating;

  const ProductCard({
    required this.imagePath,
    required this.title,
    required this.price,
    this.originalPrice,
    required this.rating,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isNetworkImage = imagePath.startsWith('http');

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              SizedBox(
                width: 140,
                child: isNetworkImage
                  ? CachedNetworkImage(
                    fit: BoxFit.contain,
                    height: 150,
                    width: double.infinity,
                    imageUrl: imagePath,
                    progressIndicatorBuilder: (context, url, progress) => const SizedBox(
                        width: 180, child: Center(child: CircularProgressIndicator())),
                    imageBuilder: (context, imageProvider) => Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  )
                  : ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                      child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTmWru8q17zpOzzzT1s475ZS_8fOL1GS0teSw&s',
                          fit: BoxFit.contain, height: 120, width: double.infinity),
                    ),),
              const Icon(CupertinoIcons.heart, color: Colors.red,)
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Column(children: [if (originalPrice != null)
                      Text(
                        originalPrice!,
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),]),
                    Spacer(),
                    Icon(Icons.star, color: Colors.orange,),
                    Text(rating.toString())
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
