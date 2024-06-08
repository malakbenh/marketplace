import 'package:flutter/material.dart';

class LineInscreen extends StatelessWidget {
  const LineInscreen({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff000000),
      ),
      width: size.width * 0.6,
      height: 3,
    );
  }
}
