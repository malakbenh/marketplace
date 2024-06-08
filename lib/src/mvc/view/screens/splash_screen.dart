import 'package:flutter/material.dart';


import '../../model/models.dart';

/// Splash screen, it shows when the app is opened and is still preparing data
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, required this.userSession});

  /// user session
  final UserSession userSession;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage('assets/images/logo_debug.png'),
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
