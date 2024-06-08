import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../tools.dart';

class CustomTypePickerButton extends StatelessWidget {
  const CustomTypePickerButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    required this.aspectRatio,
  });

  final String label;
  final IconData icon;
  final void Function() onTap;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.sp),
            border: Border.all(
              color: Theme.of(context).textTheme.displaySmall!.color!,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 14.sp * 1.2,
              ),
              Icon(
                icon,
                size: 26.sp,
                color: Colors.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Styles.poppins(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
