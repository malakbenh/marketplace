import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../settings/preferences.dart';
import '../../../../tools.dart';
import '../../../controller/services.dart';
import '../../../model/enums.dart';
import '../../../model/models.dart';
import '../../model_widgets.dart';
import '../../screens.dart';
import '../../../../app.dart';

class Register extends StatefulWidget {
  const Register({
    super.key,
    required this.userSession,
    required this.authRouteNotifier,
    required this.userType,
  });

  final UserSession userSession;
  final ValueNotifier<AuthRoute> authRouteNotifier;
  final String userType;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> formKey = GlobalKey();
  bool obscureText = true;
  bool checkbox = false;
  String? email, password, passwordRetype, name, phone;
  String? emailError, passwordError, passwordRetypeError, nameError, phoneError;

  @override
  Widget build(BuildContext context) {
    return AuthenticationPage(
      userSession: widget.userSession,
      onPressedLeadingAppBar: null,
      title: 'Create An Account',
      subtitle:
          'Fill your information below or register with your social account',
      formKey: formKey,
      bodyChildren: [
        CustomTextFormField(
          prefixColor: const Color(0xffCACACA),
          hintText: 'Full Name',
          errorText: nameError,
          keyboardType: TextInputType.name,
          prefixIcon: AwesomeIconsLight.user_large,
          textInputAction: TextInputAction.next,
          validator: (value) => Validators.of(context).validateNotNullMinLength(
            value: value,
            minLength: 10,
          ),
          onSaved: (value) => name = value,
        ),
        CustomTextFormField(
          prefixColor: const Color(0xffCACACA),
          hintText: 'phone number',
          errorText: phoneError,
          keyboardType: TextInputType.phone,
          prefixIcon: AwesomeIconsLight.phone,
          textInputAction: TextInputAction.next,
          validator: (value) => Validators.of(context).validateNotNullMinLength(
            value: value,
            minLength: 10,
          ),
          onSaved: (value) => phone = value,
        ),
        CustomTextFormField(
          fillColor: const Color(0xffF8F8F8),
          hintText: 'Enter a valid email',
          errorText: emailError,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
          textInputAction: TextInputAction.next,
          validator: Validators.validateEmail,
          onSaved: (value) => email = value,
          prefixColor: const Color(0xffCACACA),
        ),
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                CustomTextFormField(
                  prefixColor: const Color(0xffCACACA),
                  hintText: 'Enter password',
                  errorText: passwordError,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: AwesomeIconsLight.lock_keyhole,
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      Validators.of(context).validateNotNullMinLength(
                    value: value,
                    minLength: 6,
                  ),
                  onSaved: (value) => password = value,
                  suffixIcon: obscureText
                      ? AwesomeIconsLight.eye_slash
                      : AwesomeIconsLight.eye,
                  obscureText: obscureText,
                  suffixOnTap: () => setState(() => obscureText = !obscureText),
                ),
              ],
            );
          },
        ),
        StatefulBuilder(
          builder: (context, setState) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  activeColor: primary,
                  value: checkbox,
                  onChanged: (value) =>
                      setState(() => checkbox = value ?? false),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.sp),
                  ),
                ),
                8.widthW,
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: context.h5b1,
                      children: [
                        const TextSpan(
                          text: 'Agree with ',
                        ),
                        TextSpan(
                          text: 'Terms',
                          style: context.h5b1.copyWith(
                            color: primary,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => launchUrl(
                                  Uri.parse(Preferences.cguUrl),
                                ),
                        ),
                        TextSpan(
                          text: '  &  ',
                          style: context.h5b1.copyWith(
                            color: primary,
                          ),
                        ),
                        TextSpan(
                          text: 'condition',
                          style: context.h5b1.copyWith(
                            color: primary,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => launchUrl(
                                  Uri.parse(Preferences.policyUrl),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
      labelAuthButton: 'Sign Up',
      onPressedAuthButton: next,
      normalTextSpan: 'Already have an account? ',
      highlightedTextSpan: 'Sign In',
      recognizerTextSpan: () =>
          widget.authRouteNotifier.value = AuthRoute.signin,
    );
  }

  Future<void> validateSaveAndCallNext() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    await next();
  }

  Future next() async {
    if (email == null || email!.isEmpty) {
      return context.showSnackBar('Veuillez saisir votre email!');
    }
    if (password == null || password!.isEmpty) {
      return context.showSnackBar('Veuillez saisir votre mot de passe!');
    }
    // if (passwordRetype == null || passwordRetype!.isEmpty) {
    //   return context.showSnackBar('Veuillez confirmer votre mot de passe!');
    // }
    // if (password != passwordRetype) {
    //   setState(() {
    //     passwordRetypeError = 'Veuillez confirmer votre mot de passe!';
    //   });
    //   return;
    // }
    if (!checkbox) {
      return context.showSnackBar(
        'Veuillez lire et accepter les conditions d\'utilisation et la politique de confidentialité!',
      );
    }
    await Dialogs.of(context).runAsyncAction(
      future: () async {
        try {
          await AuthenticationService.createUserWithEmailAndPassword(
            userSession: widget.userSession,
            email: email!,
            password: password!,
            type: widget.userType,
          );
        } on FirebaseAuthException {
          rethrow;
        }
      },
      onComplete: (_) => context.popUntilFirst(),
      onError: (e) {
        if (e is FirebaseAuthException) {
          setState(() {
            emailError = Functions.of(context).translateException(e);
          });
        } else {
          throw e;
        }
      },
    );
  }
}
