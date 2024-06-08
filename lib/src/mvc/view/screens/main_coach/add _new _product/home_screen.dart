import 'package:flutter/material.dart';
import 'package:vitafit/src/mvc/model/models/user_session.dart';

import '../../../model_widgets/add_product_widget.dart';
import '../../../model_widgets/product_widget.dart';
//import 'package:poducts/widgets/add_product_widget.dart';
//import 'package:poducts/widgets/product_widget.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required UserSession userSession});
  int currentPage = 1;
  List<ProductWidget> products = [
    const ProductWidget(
        image: 'assets/photo1.png', title: 'Razor Air-Hyper-Brisk'),
    const ProductWidget(image: 'assets/pngwing 23.png', title: 'T-shirt')
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add New Product',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          elevation: 1.0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Center(
                        child: Container(
                          width: 400,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (widget.currentPage == 1) return;
                                  setState(() {
                                    widget.currentPage = 1;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(100, 70),
                                  backgroundColor: widget.currentPage == 1
                                      ? Colors.black
                                      : const Color.fromARGB(
                                          255, 209, 206, 206),
                                ),
                                child: const Text(
                                  'Healthy Products',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (widget.currentPage == 2) return;
                                  setState(() {
                                    widget.currentPage = 2;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(100, 70),
                                  backgroundColor: widget.currentPage == 2
                                      ? Colors.black
                                      : const Color.fromARGB(
                                          255, 209, 206, 206),
                                ),
                                child: const Text(
                                  'Sport Materials',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (widget.currentPage == 3) return;
                                  setState(() {
                                    widget.currentPage = 3;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(100, 70),
                                  backgroundColor: widget.currentPage == 3
                                      ? Colors.black
                                      : const Color.fromARGB(
                                          255, 209, 206, 206),
                                ),
                                child: const Text(
                                  'Sports Wear',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if(widget.currentPage == 1)  AddProductWidget(currentPage: 1),
                    if(widget.currentPage == 2)  AddProductWidget(currentPage: 2),
                    if(widget.currentPage == 3)  AddProductWidget(currentPage: 3)
                    ]))));
  }
}