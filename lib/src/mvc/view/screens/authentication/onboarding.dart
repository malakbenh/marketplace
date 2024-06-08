import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../tools.dart';
import '../../../../settings/settings_controller.dart';
import '../../../model/models_ui.dart';
import '../../model_widgets.dart';
import '../../../../app.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  late PageController controller = PageController();
  int get currentPage =>
      controller.hasClients ? (controller.page ?? 0).round() : 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PageView(
              controller: controller,
              children: const [
                Page(
                  svgPath: 'assets/images/cuate.png',
                  titleLeading: 'You Have A',
                  titleTrailing: 'Personal Coach!',
                  subtitle:
                      'Welcome to our application! Start your journey to a healthier lifestyle with personalized coaching and diet plans tailored just for you.',
                ),
                Page(
                  titleTrailing: 'Coach!',
                  svgPath: 'assets/images/panel2.png',
                  titleLeading: 'Join As A ',
                  subtitle:
                      'Welcome to VitaFit! Create your profile to start connecting with clients, managing their diets, and guiding them towards their fitness goals.',
                ),
                Page(
                  titleTrailing: 'The Shop\'s Products',
                  svgPath: 'assets/images/pana.png',
                  titleLeading: 'Explore',
                  subtitle:
                      'Discover a wide range of high-quality nutritional and sports products to support your fitness journey.',
                ),
              ],
            ),
          ),
          Center(
            child: CustomSmoothPageIndicator(
              count: 3,
              controller: controller,
            ),
          ),
          20.heightH,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    return Opacity(
                      opacity: currentPage < 2 ? 1 : 0,
                      child: CustomTextButton(
                        button: ModelTextButton(
                          label: 'Skip',
                          onPressed: currentPage < 2
                              ? () => widget.settingsController
                                  .updateShowOnboarding(false)
                              : null,
                        ),
                      ),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    if (currentPage < 2) {
                      return FloatingActionButton(
                        onPressed: () {
                          controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        backgroundColor: secondary,
                        child: const Icon(Icons.arrow_forward_ios),
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(right: 100.w),
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            widget.settingsController
                                .updateShowOnboarding(false);
                          },
                          backgroundColor: secondary,
                          label: Text(
                            'Get started',
                            style: context.h4b1.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          (context.viewPadding.bottom + 40.h).height,
        ],
      ),
    );
  }
}

class Page extends StatelessWidget {
  const Page({
    Key? key,
    required this.svgPath,
    required this.titleLeading,
    required this.titleTrailing,
    required this.subtitle,
  }) : super(key: key);

  final String svgPath;
  final String titleLeading;
  final String titleTrailing;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.zero,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(100),
                bottomLeft: Radius.circular(100),
              ),
              color: Color(0xffF2F0F0),
            ),
            child: Column(
              children: [
                Image.asset(
                  svgPath,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                ),
                SizedBox(
                  height: 60.h,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                30.heightH,
                RichText(
                  text: TextSpan(
                    style: context.h2b1.copyWith(
                      fontFamily: 'Montserrat',
                      fontWeight: Styles.semiBold,
                      color: context.b3,
                    ),
                    children: [
                      TextSpan(text: '$titleLeading '),
                      TextSpan(
                        text: titleTrailing,
                        style: context.h2b1.copyWith(
                          fontFamily: 'Montserrat',
                          fontWeight: Styles.semiBold,
                          color: context.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                30.heightH,
                Text(
                  subtitle,
                  style: context.h5b2.copyWith(
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
