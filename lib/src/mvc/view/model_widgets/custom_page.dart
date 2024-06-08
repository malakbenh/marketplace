import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'Favorite/color.dart';
import 'Favorite/size.dart';

class ProductDetailPageCustom extends StatelessWidget {
  final String productName;
  final String price;
  final List<String>? sizes;
  final List<Color>? colors;
  final String imagePath;
  final String description;

  const ProductDetailPageCustom({
    Key? key,
    required this.productName,
    required this.price,
    this.sizes = const [],
    this.colors = const [],
    required this.imagePath,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffE2FA9E),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color(0xffE2FA9E),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xffE2FA9E),
            height: screenHeight * 0.25,
            child: Center(
              child: Image.asset(imagePath),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            productName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            '${price.toString()}DA',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              _buildCounterButton(
                                context,
                                Icons.remove_circle,
                                () {
                                  // Decrease count
                                },
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "1", // Your dynamic count value here
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              _buildCounterButton(
                                context,
                                Icons.add_circle,
                                () {
                                  // Increase count
                                },
                              ),
                            ],
                          ),
                          RatingBarIndicator(
                            rating: 3, // Assuming 4 is your rating value
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Color(0xffF69372),
                            ),
                            itemCount: 5,
                            itemSize: 25.0,
                            direction: Axis.horizontal,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        description,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          if (colors != null && colors!.isNotEmpty) ...[
                            const Text(
                              "Color",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10),
                            ...colors!.map((color) => ColorDot(color: color)),
                          ],
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (sizes != null && sizes!.isNotEmpty) ...[
                            const Text(
                              "Size",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            ...sizes!.map((size) => SizeDot(
                                  size: size,
                                  backgroundColor:
                                      _getSizeBackgroundColor(size),
                                  textColor: _getTextColor(size),
                                )),
                          ],
                        ],
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: ElevatedButton.icon(
                            icon: const Icon(
                              Icons.shopping_bag_rounded,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Add To Cart",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffF69372),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 80.0,
                                vertical: 12.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color? _getSizeBackgroundColor(String size) {
    if (size == "37") {
      return const Color(0xffF69372);
    } else if (size == "3kg") {
      return const Color(0xffF69372);
    } else {
      return null;
    }
  }

  Color _getTextColor(String size) {
    return size == "37" || size == "3kg"
        ? Colors.white
        : const Color(0xffF69372);
  }

  Widget _buildCounterButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPress,
  ) {
    return IconButton(
      icon: Icon(icon, color: const Color(0xffF69372)),
      onPressed: onPress,
    );
  }
}
