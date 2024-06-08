import 'package:flutter/material.dart';
import '../../../../../controller/services.dart';
import '../../../../../model/models.dart';
import '../../../../model_widgets/product_item.dart';

class HealthyProduct extends StatefulWidget {
  final String category;

  const HealthyProduct({Key? key, required this.category}) : super(key: key);

  @override
  _HealthyProductState createState() => _HealthyProductState();
}

class _HealthyProductState extends State<HealthyProduct> {
  late Future<List<Product>> _healthyProducts;

  @override
  void initState() {
    super.initState();
    _healthyProducts = ProductsService().getProductsByCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Product>>(
        future: _healthyProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found in this category'));
          } else {
            final products = snapshot.data!;
            return GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (BuildContext context, int index) {
                return ProductItem(product: products[index]);
              },
            );
          }
        },
      ),
    );
  }
}
