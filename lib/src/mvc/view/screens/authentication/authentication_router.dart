import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../model/enums.dart';
import '../../../model/models.dart';
import '../../screens.dart';

class AuthenticationRouter extends StatefulWidget {
  const AuthenticationRouter({
    super.key,
    required this.userSession,
    required this.userType,
  });

  final UserSession userSession;
  final String userType;

  @override
  State<AuthenticationRouter> createState() => _AuthenticationRouterState();
}

class _AuthenticationRouterState extends State<AuthenticationRouter> {
  late ValueNotifier<AuthRoute> authRouteNotifier;
  bool showSplashScreen = true;

  @override
  void initState() {
    super.initState();
    // if (widget.userSession.isAuthenticated) {
    //   authRouteNotifier = ValueNotifier<AuthRoute>(AuthRoute.activation);
    // } else {
    //   authRouteNotifier = ValueNotifier<AuthRoute>(AuthRoute.register);
    // }
    authRouteNotifier =
        ValueNotifier<AuthRoute>(AuthRoute.login_or_signup_screen);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Timer(
        const Duration(seconds: 3),
        () {
          setState(() {
            showSplashScreen = false;
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSplashScreen) {
      return Scaffold(
        body: Stack(
          alignment: Alignment.topLeft,
          children: [
            Image.asset(
              'assets/images/auth_images/Ellipse 3.png',
            ),
            ClipRRect(
              borderRadius:
                  const BorderRadius.only(topLeft: Radius.circular(20)),
              child: Image.asset(
                'assets/images/auth_images/Ellipse 3-1.png',
              ),
            ),
            Positioned(
              bottom: 0,
              left: 250,
              child: Transform.rotate(
                angle: -pi / 1,
                child: Image.asset(
                  'assets/images/auth_images/Ellipse 3.png',
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 335,
              child: Transform.rotate(
                angle: pi / -1.1,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.only(topLeft: Radius.circular(30)),
                  child: Image.asset(
                    'assets/images/auth_images/Ellipse 3-1.png',
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                widget.userType == 'client'
                    ? 'Hello\nDear\nClient'
                    : 'Hello\nDear\nCoach',
                style: const TextStyle(fontSize: 70, fontFamily: 'Satisfy'),
              ),
            ),
          ],
        ),
      );
    }
    return ValueListenableBuilder(
      valueListenable: authRouteNotifier,
      builder: (context, authRoute, _) {
        switch (authRoute) {
          case AuthRoute.register:
            return Register(
              userSession: widget.userSession,
              authRouteNotifier: authRouteNotifier,
              userType: widget.userType,
            );
          case AuthRoute.signin:
            return Signin(
              userSession: widget.userSession,
              authRouteNotifier: authRouteNotifier,
              userType: widget.userType,
            );
          case AuthRoute.activation:
            return AccountActivation(
              userSession: widget.userSession,
              authRouteNotifier: authRouteNotifier,
            );
          case AuthRoute.login_or_signup_screen:
            return LoginOrSignUP(
              userSession: widget.userSession,
              authRouteNotifier: authRouteNotifier,
            );
          default:
            throw UnimplementedError('AuthRoute switch case not handled.');
        }
      },
    );
  }
}
