import 'package:flutter/material.dart';
import '../screens/main_client/buy_program/core/app_color.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final String image;

  const CustomCard(
      {super.key,
      required this.title,
      required this.isSelected,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isSelected ? AppColors.primaryColor : Colors.white,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            Image.asset(
              width: 50,
              height: 60,
              fit: BoxFit.cover,
              image,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const Expanded(
              child: SizedBox(), // SizedBox to occupy remaining space
            ),
            Icon(
              Icons.check,
              color: isSelected ? AppColors.primaryColor : Colors.grey[100],
            ),
          ],
        ),
      ),
    );
  }
}
