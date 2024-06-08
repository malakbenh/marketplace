import 'package:flutter/material.dart';
import '../../model_widgets/authentication/custom_button.dart';


import '../../../model/enums.dart';
import '../../../model/models.dart';

class LoginOrSignUP extends StatelessWidget {
  const LoginOrSignUP({
    Key? key,
    required this.authRouteNotifier,
    required this.userSession,
  }) : super(key: key);

  final ValueNotifier<AuthRoute> authRouteNotifier;
  final UserSession userSession;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Image.asset(
            'assets/images/auth_images/Ellipse 3.png',
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
            ),
            child: Image.asset(
              'assets/images/auth_images/Ellipse 3-1.png',
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Image.asset(
                      'assets/images/auth_images/tablet-login/pana.png'),
                  const Text(
                    'Get the best service in our\n platforme!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CastomButtonWidget(
                    title: 'Sign Up',
                    backgroundColor: const Color(0xff35a072),
                    onPressed: () {
                      authRouteNotifier.value = AuthRoute.register;
                    },
                  ),
                  CastomButtonWidget(
                    title: 'Login',
                    backgroundColor: Colors.white,
                    onPressed: () {
                      authRouteNotifier.value = AuthRoute.signin;
                    },
                    textColor: Colors.black,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'By using this app, you agree to our ',
                          ),
                          TextSpan(
                            text: 'business or end user terms',
                            style: TextStyle(color: Colors.amber),
                          ),
                          TextSpan(
                            text: ' and ',
                          ),
                          TextSpan(
                            text: 'privacy policy',
                            style: TextStyle(color: Colors.amber),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
