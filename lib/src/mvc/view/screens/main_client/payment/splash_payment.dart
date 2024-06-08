//import 'package:coach/payment/payment_method.dart';
import 'package:flutter/material.dart';

import '../../../screens.dart';

class SplashPayment extends StatelessWidget {
  const SplashPayment({Key? key}) : super(key: key);
  static const String pageRaute = 'splash payment';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Image.asset(
            'assets/images/splashpayment.png',
            width: double.infinity,
          ),
          const Text(
            'Your Profile Is Complete!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            '''
                  If you want to save your information,
                  you must first pay for your own
                  nutritionel program     
                            ''',
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(PaymentMethod.pageRaute);
            },
            child: Container(
              margin: const EdgeInsets.all(20),
              width: 156,
              height: 47,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xff35A072),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Pay',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
