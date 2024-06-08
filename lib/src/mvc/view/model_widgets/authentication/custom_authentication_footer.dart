import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../tools.dart';
import '../../../controller/services.dart';
import '../../../model/models/user_session.dart';
import '../../model_widgets.dart';

class CustomAuthenticationFooter extends StatelessWidget {
  const CustomAuthenticationFooter({
    super.key,
    required this.userSession,
    required this.onAuthComplete,
    this.recognizerTextSpan,
    required this.normalTextSpan,
    required this.highlightedTextSpan,
  });

  final UserSession userSession;
  final void Function()? onAuthComplete;
  final void Function()? recognizerTextSpan;
  final String normalTextSpan;
  final String highlightedTextSpan;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            14.widthW,
            const Expanded(
              child: Divider(
                height: 1,
                color: Color(0xfffafadad),
              ),
            ),
            14.widthW,
            Text('Or sign in with',
                style: context.h6b2.copyWith(color: const Color(0xfffafadad))),
            14.widthW,
            Expanded(
              child: Divider(
                height: 1,
                color: context.b3,
              ),
            ),
            14.widthW,
          ],
        ),
        44.heightH,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomFloatingFlatActionButton(
              icon: AwesomeIconsBrands.google_1,
              onPressed: () => Dialogs.of(context).runAsyncAction<void>(
                future: () => GoogleSignInService.signIn(userSession),
                onComplete: (_) {
                  if (onAuthComplete != null) {
                    onAuthComplete!();
                  }
                  context.popUntilFirst();
                },
              ),
            ),
            20.widthW,
            CustomFloatingFlatActionButton(
              icon: AwesomeIconsBrands.apple_1,
              onPressed: () {},
            ),
          ],
        ),
        44.heightH,
        SizedBox(
          height: 44.sp,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: context.h5b1.copyWith(height: 1.5),
              children: [
                TextSpan(
                  text: normalTextSpan,
                  recognizer: TapGestureRecognizer()
                    ..onTap = recognizerTextSpan,
                ),
                //  if (highlightedTextSpan.isNotNullOrEmpty)
                TextSpan(
                  text: highlightedTextSpan,
                  style: context.h5b1.copyWith(
                    color: context.primary,
                    height: 1.5,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = recognizerTextSpan,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
