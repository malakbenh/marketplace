import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final double price;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final Color backgroundColor;
  final String? colorText;
  final String? sizeText;
  final String? typetext;
  final int quantity;

  const ProductWidget({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.onAdd,
    required this.onRemove,
    required this.backgroundColor,
    this.colorText,
    this.sizeText,
    this.typetext,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // تحديد ارتفاع ثابت للكارد
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the card
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Left side image
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Container(
                    color: backgroundColor,
                    child: Image.asset(
                      imagePath,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Right side details
              // Right side details
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Color(0xffEE7A53),
                                ),
                                onPressed: () {
                                  // Delete action
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (colorText != null) Text("Color: $colorText"),
                      if (sizeText != null) Text("$typetext: $sizeText"),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${price.toStringAsFixed(2)}DA',
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    icon: const Icon(
                                        Icons.remove_circle_outlined,
                                        color: Color(0xffEE7A53)),
                                    onPressed: onRemove,
                                  ),
                                ),
                                Text('$quantity',
                                    style: const TextStyle(fontSize: 20)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_rounded,
                                      color: Color(0xffEE7A53)),
                                  onPressed: onAdd,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
