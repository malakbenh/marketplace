import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../model/models/product.dart';
import '../../../model_widgets/ProductCard.dart';
import '../const/app_const.dart';

class HomeStore extends StatelessWidget {
  const HomeStore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  child: Image.asset(
                    "assets/images/other/Ellipse 27.png",
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          top: 50, left: 30, right: 30, bottom: 90),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                prefix: const SizedBox(
                                  width: 15,
                                ),
                                contentPadding: const EdgeInsets.all(1),
                                suffixIcon: const Icon(Icons.search),
                                hintText: "Search",
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_active,
                              color: Colors.white,
                              size: 26,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 150,
              child: Swiper(
                autoplay: true,
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(Banners.banners[index]);
                },
                itemCount: Banners.banners.length,
              ),
            ),
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "SALES DISCOUNT",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "View All",
                          style: TextStyle(
                            color: Color(0xffEE7A53),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .where('onSale', isEqualTo: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                            child: Text('No products available.'));
                      }
                      var productDocs = snapshot.data!.docs;
                      return GridView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: productDocs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 8 / 7.4,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          var productData =
                              productDocs[index].data() as Map<String, dynamic>;
                          var product = Product(
                            title: productData['title'],
                            description: productData['description'],
                            productImage: productData['imagePath'],
                            originalPrice: productData['originalPrice'],
                            discountPrice: productData['discountPrice'],
                            category: productData['category'],
                            onSale: productData['onSale'],
                            uid: productData['uid'],
                          );
                          return ProductCard(
                            imagePath: product.productImage!,
                            title: product.title!,
                            price:
                                '\$${product.discountPrice ?? product.originalPrice}',
                            originalPrice: product.discountPrice != null
                                ? '\$${product.originalPrice}'
                                : null,
                            rating: 4.5, // Assuming a static rating for now
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Popular Products",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => HealthyProduct(),
                      //         )
                      //         );
                      //   },
                      //   child: const Text(
                      //     "View All",
                      //     style: TextStyle(
                      //       color: Color(0xffEE7A53),
                      //       fontSize: 16,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                            child: Text('No products available.'));
                      }
                      var productDocs = snapshot.data!.docs;
                      return GridView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: productDocs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 8 / 7.4,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          var productData =
                              productDocs[index].data() as Map<String, dynamic>;
                          var product = Product(
                            title: productData['title'],
                            description: productData['description'],
                            productImage: productData['imagePath'],
                            originalPrice: productData['originalPrice'],
                            discountPrice: productData['discountPrice'],
                            category: productData['category'],
                            onSale: productData['onSale'],
                            uid: productData['uid'],
                          );
                          return ProductCard(
                            imagePath: product.productImage!,
                            title: product.title!,
                            price:
                                '\$${product.discountPrice ?? product.originalPrice}',
                            originalPrice: product.discountPrice != null
                                ? '\$${product.originalPrice}'
                                : null,
                            rating: 4.5, // Assuming a static rating for now
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.25,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
