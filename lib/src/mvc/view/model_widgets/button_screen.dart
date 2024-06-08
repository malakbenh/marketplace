import 'package:flutter/material.dart';

import '../screens/main_client/buy_program/core/app_color.dart';

class ButtonInBording extends StatelessWidget {
  const ButtonInBording({
    super.key,
    required this.size,
    required this.onTap,
    required this.text,
  });

  final Size size;
  final Function()? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        width: size.width * 0.6,
        height: 50,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
