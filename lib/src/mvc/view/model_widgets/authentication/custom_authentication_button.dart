import 'package:flutter/material.dart';

import '../../../../tools.dart';
import '../../model_widgets.dart';

class CustomAuthenticationButton extends StatelessWidget {
  const CustomAuthenticationButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomElevatedButton(
          label: label,
          onPressed: onPressed,
          padding: const EdgeInsets.symmetric(horizontal: 30),
        ),
        12.heightH,
      ],
    );
  }
}
