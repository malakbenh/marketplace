import 'dart:developer';
import 'dart:io';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:flutter/material.dart';
import 'package:vitafit/src/mvc/controller/services/product_service.dart';
import 'package:vitafit/src/mvc/model/models/product.dart';
import '../screens.dart';
import 'pickImageBottomSheet.dart';
import 'package:cool_dropdown/cool_dropdown.dart';

class AddProductWidget extends StatelessWidget {
  AddProductWidget({super.key, required this.currentPage});
  final int currentPage;
  final listDropdownController = DropdownController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController originalPriceController = TextEditingController();
  TextEditingController discountPriceController = TextEditingController();
  TextEditingController discountOptionalController = TextEditingController();
  TextEditingController stockQuantityController = TextEditingController();
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 411,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Product Image",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SharedData.productImage == null
                  ? InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (_) {
                              return const PickImageBottomSheet();
                            },
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))));
                      },
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(
                              width: 260, height: 200),
                          child: CustomPaint(
                            painter: DashedBorderPainter(),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Click to upload",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 112, 172, 114),
                                  ),
                                ),
                                SizedBox(height: 1),
                                Text(
                                  "or drag and drop",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 200,
                      child: Center(
                        child: Image.file(
                          File(SharedData.productImage),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
            ],
          ),
        ),
        Center(
          child: Container(
            width: 411,
            //height: 290,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "General Information",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 252, 253, 253),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      "Product Name",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  TextFormField(
                    controller: productNameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter product name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode
                        .onUserInteraction, // للتحقق التلقائي عند التفاعل
                  ),
                  const SizedBox(height: 10),
                  if (currentPage == 3) const SizedBox(height: 10),
                  if (currentPage == 3)
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 252, 253, 253),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        "Product Category",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  if (currentPage == 3)
                    CoolDropdown<String>(
                      dropdownList: [
                        CoolDropdownItem(label: 'shoes', value: 'حذاء'),
                        CoolDropdownItem(label: 'top', value: 'جورب'),
                        CoolDropdownItem(label: 'suite', value: 'حقيبة'),
                        CoolDropdownItem(label: 'brassiers', value: 'حقيبة')
                      ],
                      controller: listDropdownController,
                      onChange: (String) {},
                    ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 252, 253, 253),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      "Description",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            hintText: 'Enter la description',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Original Price",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "Discount Price",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 252, 253, 253),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            controller: originalPriceController,
                            decoration: const InputDecoration(
                              hintText: '',
                              hintStyle: TextStyle(
                                  fontSize:
                                      12), // Change 16 to the desired font size

                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ),
                      ),
                      const SizedBox(width: 100),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 252, 253, 253),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            controller: discountPriceController,
                            decoration: const InputDecoration(
                              hintText: '',
                              hintStyle: TextStyle(fontSize: 12),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // يُحدد توضيب العناصر في الجهة اليسرى
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Discount",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.45,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 5, top: 5), // ضبط المسافة بين العبارات
                        child: Text(
                          "Opstional",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter la discount opstional',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 252, 253, 253),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      "Stock Quantty",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter la Quantty',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (currentPage != 1)
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 252, 253, 253),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        "Weight",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  if (currentPage != 1)
                    Form(
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Enter le weight ',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 10),
                  if (currentPage != 1)
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 252, 253, 253),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        "color",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  if (currentPage != 1)
                    Form(
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: ' Enter le color',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 10),
                  if (currentPage != 1)
                    if (currentPage != 2)
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 252, 253, 253),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          " Show size",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                  if (currentPage != 1)
                    if (currentPage != 2)
                      Form(
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: ' Enter le show size',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                          ],
                        ),
                      ),
                  const SizedBox(height: 10),
                  if (currentPage != 1)
                    if (currentPage != 2)
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 252, 253, 253),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          "Size",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                  if (currentPage != 1)
                    if (currentPage != 2)
                      Form(
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: ' Enter le size',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                          ],
                        ),
                      ),

                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => addProductToDatabase(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff35a072), // لون الخلفية
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10), // الهامش الداخلي
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // الشكل الخارجي
                        ),
                      ),
                      child: const Text(
                        "Add Product",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Repeat this block as needed for other fields
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  addProductToDatabase() {
    Product newProduct = Product(
        category: currentPage == 1
            ? 'Healthy Product'
            : currentPage == 2
                ? 'Sports Materials'
                : currentPage == 3
                    ? 'Sports Wear'
                    : '',
        description: descriptionController.text,
        originalPrice: double.parse(originalPriceController.text),
        discountPrice: double.parse(discountPriceController.text),
        title: productNameController.text,
        productImage: SharedData.productImage);
    log('im here');
    ProductsService.addProduct(newProduct);
  }
}
