import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../tools.dart';
import '../../../controller/services.dart';
import '../../../model/enums.dart';
import '../../../model/models.dart';
import '../../model_widgets.dart';
import '../../screens.dart';

class Signin extends StatefulWidget {
  const Signin({
    super.key,
    required this.userSession,
    required this.authRouteNotifier,
    required this.userType,
  });

  final UserSession userSession;
  final ValueNotifier<AuthRoute> authRouteNotifier;
  final String userType;

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final GlobalKey<FormState> formKey = GlobalKey();
  bool obscureText = true;
  bool checkbox = false;
  String? email, password;
  String? emailError, passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: AuthenticationPage(
          hight: 200.h,
          widget: Image.asset(
            'assets/images/register.png',
            fit: BoxFit.contain,
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          userSession: widget.userSession,
          onPressedLeadingAppBar: null,
          title: 'Hello Again!',
          subtitle: 'Hi! Welcome back, you’ve been missed',
          formKey: formKey,
          bodyChildren: [
            CustomTextFormField(
              hintText: 'Enter your Email',
              errorText: emailError,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              textInputAction: TextInputAction.next,
              validator: Validators.validateEmail,
              onSaved: (value) => email = value,
            ),
            StatefulBuilder(
              builder: (context, setState) {
                return CustomTextFormField(
                  hintText: 'Enter your Password',
                  errorText: passwordError,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: AwesomeIconsLight.lock_keyhole,
                  validator: Validators.validateNotNull,
                  onSaved: (value) => password = value,
                  suffixIcon: obscureText
                      ? AwesomeIconsLight.eye_slash
                      : AwesomeIconsLight.eye,
                  obscureText: obscureText,
                  suffixOnTap: () => setState(() => obscureText = !obscureText),
                  onEditingComplete: validateSaveAndCallNext,
                );
              },
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: RichText(
                text: TextSpan(
                  style: context.h5b1.copyWith(height: 1.5),
                  children: [
                    TextSpan(
                      text: 'Forgot Password??',
                      style: context.h5b1.copyWith(
                        height: 1.5,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.push(
                              widget: ForgotPassword(
                                userSession: widget.userSession,
                                authRouteNotifier: widget.authRouteNotifier,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          labelAuthButton: 'Sign In',
          onPressedAuthButton: next,
          normalTextSpan: 'Don’t have an account?',
          highlightedTextSpan: ' Sign Up',
          recognizerTextSpan: () =>
              widget.authRouteNotifier.value = AuthRoute.register,
        ),
      ),
    );
  }

  Future<void> validateSaveAndCallNext() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    await next();
  }

  Future<void> next() async {
    if (emailError.isNotNullOrEmpty || passwordError.isNotNullOrEmpty) {
      setState(() {
        emailError = null;
        passwordError = null;
      });
    }
    await Dialogs.of(context).runAsyncAction(
      future: () => AuthenticationService.signInWithEmailAndPassword(
          userSession: widget.userSession,
          email: email!,
          password: password!,
          type: widget.userType),
      onComplete: (_) => context.popUntilFirst(),
      onError: (e) {
        try {
          throw e;
        } on FirebaseException catch (e) {
          switch (e.code) {
            case 'weak-password':
            case 'wrong-password':
              passwordError =
                  Functions.of(context).translateExceptionKey(e.code);
              break;
            default:
              emailError = Functions.of(context).translateExceptionKey(e.code);
          }
          setState(() {});
        } catch (e) {
          setState(() {
            emailError = AppLocalizations.of(context)!.unknown_error;
          });
        }
      },
    );
  }
}
