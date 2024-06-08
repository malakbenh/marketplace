import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomSmoothPageIndicator extends StatelessWidget {
  const CustomSmoothPageIndicator({
    super.key,
    required this.count,
    required this.controller,
  });

  final int count;
  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: count,
      effect: CustomizableEffect(
        dotDecoration: DotDecoration(
          color: const Color(0xffD9D9D9),
          borderRadius: BorderRadius.circular(5.sp),
          height: 10.sp,
          width: 10.sp,
        ),
        activeDotDecoration: DotDecoration(
          color: const Color(0xffEE7A53),
          borderRadius: BorderRadius.circular(5.sp),
          height: 10.sp,
          width: 20.sp,
        ),
        spacing: 6.sp,
      ),
    );
  }
}
