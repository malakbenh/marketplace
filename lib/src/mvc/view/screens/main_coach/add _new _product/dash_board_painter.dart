import 'package:flutter/material.dart';

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashLength = 10;
    const gapLength = 10;

    double currentLength = 0;

    while (currentLength < size.width) {
      canvas.drawLine(
        Offset(currentLength, 0),
        Offset(currentLength + dashLength, 0),
        paint,
      );
      currentLength += dashLength + gapLength;
    }

    currentLength = 0;
    while (currentLength < size.height) {
      canvas.drawLine(
        Offset(size.width, currentLength),
        Offset(size.width, currentLength + dashLength),
        paint,
      );
      currentLength += dashLength + gapLength;
    }

    currentLength = 0;
    while (currentLength < size.width) {
      canvas.drawLine(
        Offset(currentLength, size.height),
        Offset(currentLength + dashLength, size.height),
        paint,
      );
      currentLength += dashLength + gapLength;
    }

    currentLength = 0;
    while (currentLength < size.height) {
      canvas.drawLine(
        Offset(0, currentLength),
        Offset(0, currentLength + dashLength),
        paint,
      );
      currentLength += dashLength + gapLength;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}