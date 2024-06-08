import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../extensions.dart';

class SourcePickerTile extends StatelessWidget {
  const SourcePickerTile({
    super.key,
    required this.label,
    required this.icon,
    required this.aspectRatio,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final double aspectRatio;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 2.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.sp),
            border: Border.all(
              color: Theme.of(context).textTheme.displayLarge!.color!,
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
                color: Theme.of(context).textTheme.displayLarge!.color!,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: context.h5b1,
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
