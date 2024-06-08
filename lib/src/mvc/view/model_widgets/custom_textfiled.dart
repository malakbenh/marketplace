import 'package:flutter/material.dart';

class CustomTextFiled extends StatelessWidget {
   CustomTextFiled({Key? key, required this.hint}) : super(key: key);
String hint ;
  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.only(top: 20),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          hintText: hint,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}
