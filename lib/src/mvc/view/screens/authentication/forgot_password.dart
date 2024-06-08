import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../tools.dart';
import '../../../controller/services.dart';
import '../../../model/enums.dart';
import '../../../model/models.dart';
import '../../model_widgets.dart';
import '../../screens.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({
    super.key,
    required this.userSession,
    required this.authRouteNotifier,
  });

  final UserSession userSession;
  final ValueNotifier<AuthRoute> authRouteNotifier;

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String? email;
  String? emailError;

  @override
  Widget build(BuildContext context) {
    return AuthenticationPage(
      hight: 100.h,
      widget: Image.asset(
        'assets/images/auth_images/forgot-password/pana.png',
        fit: BoxFit.contain,
        height: MediaQuery.of(context).size.height * 0.3,
      ),
      userSession: widget.userSession,
      onPressedLeadingAppBar: null,
      title: 'Forgot Password',
      subtitle: 'Enter email address associated with\n  your account',
      formKey: formKey,
      bodyChildren: [
        CustomTextFormField(
          hintText: 'Enter your email',
          errorText: emailError,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
          validator: Validators.validateEmail,
          onSaved: (value) => email = value,
          onEditingComplete: validateSaveAndCallNext,
        ),
      ],
      labelAuthButton: 'Forgot Password',
      onPressedAuthButton: next,
      normalTextSpan: 'You remember your password?',
      highlightedTextSpan: ' Sign In',
      recognizerTextSpan: context.pop,
    );
  }

  Future<void> validateSaveAndCallNext() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    await next();
  }

  Future<void> next() async {
    if (emailError.isNotNullOrEmpty) {
      setState(() {
        emailError = null;
      });
    }
    await Dialogs.of(context).runAsyncAction(
      future: () => AuthenticationService.sendPasswordResetEmail(email: email!),
      onCompleteMessage:
          'Un lien de réinitialisation de votre mot de passe a été envoyé par e-mail.',
      dialogType: DialogType.snackbar,
      onError: (e) {
        setState(() {
          emailError = Functions.of(context).translateException(e);
        });
      },
    );
  }
}
