import 'package:flutter/material.dart';

class SizeDot extends StatelessWidget {
  final String size;
  final double dotSize;
  final Color? backgroundColor; // Optional background color
  final Color textColor; // Text color with default value

  const SizeDot({
    Key? key,
    required this.size,
    this.dotSize = 32.0, // Default dot size
    this.backgroundColor, // Optional background color
    this.textColor = const Color(0xffEE7A53), // Default text color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: backgroundColor != null // Check if background color is provided
          ? _withBackground() // Use container with background
          : _withoutBackground(), // Use container without background
    );
  }

  Widget _withBackground() {
    return Container(
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dotSize / 2), // Perfectly round
        color: backgroundColor,
      ),
      child: Center(
        child: Text(
          size,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _withoutBackground() {
    return Container(
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dotSize / 2), // Perfectly round
        border: Border.all(
          color: const Color(0xffEE7A53),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          size,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
