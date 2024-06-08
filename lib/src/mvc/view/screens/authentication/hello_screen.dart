import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
//import 'package:vitafit/view/screens/auth/login_or_signup_screen.dart';
import 'login_or_signup_screen.dart';

import '../../../model/enums.dart';
import '../../../model/models.dart';

class HelloScreen extends StatefulWidget {
  final UserSession userSession;
  final ValueNotifier<AuthRoute> authRouteNotifier;

  const HelloScreen({
    Key? key,
    required this.userSession,
    required this.authRouteNotifier,
  }) : super(key: key);

  @override
  State<HelloScreen> createState() => _HelloScreenState();
}

class _HelloScreenState extends State<HelloScreen> {
  bool hide = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Timer(
        const Duration(seconds: 3),
        () {
          setState(() {
            hide = true;
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (hide) {
      LoginOrSignUP(
        userSession: widget.userSession,
        authRouteNotifier: widget.authRouteNotifier,
      );
    }
    return Scaffold(
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Image.asset(
            'assets/images/auth_images/Ellipse 3.png',
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20)),
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
          const Center(
            child: Text(
              'Hello\nDear\nClient',
              style: TextStyle(fontSize: 70, fontFamily: 'Satisfy'),
            ),
          ),
        ],
      ),
    );
  }
}
