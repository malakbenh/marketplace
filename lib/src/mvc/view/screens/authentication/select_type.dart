import 'dart:ui';

import 'package:flutter/material.dart';
import '../../../model/models.dart';
import '../../model_widgets/authentication/custom_button.dart';
import '../../screens.dart';

class SelectType extends StatelessWidget {
  const SelectType({
    super.key,
    required this.userSession,
  });

  final UserSession userSession;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/auth_images/home.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/auth_images/logo.png',
                ),
                const SizedBox(
                  height: 300,
                ),
                CastomButtonWidget(
                  title: "I'm a coach",
                  backgroundColor: const Color(0xff35a072),
                  onPressed: () => pushWithType(context, 'coach'),
                ),
                CastomButtonWidget(
                  title: "I'm a client",
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  onPressed: () => pushWithType(context, 'client'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void pushWithType(BuildContext context, String userType) {
    userSession.userType = userType;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AuthenticationRouter(
          userSession: userSession,
          userType: userType,
        ),
      ),
    );
  }
}
