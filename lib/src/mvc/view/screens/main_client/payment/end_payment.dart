import 'package:flutter/material.dart';
import '../../../../model/models.dart';
import '../../../screens.dart';

class EndPayment extends StatelessWidget {
  const EndPayment({Key? key, required this.userSession}) : super(key: key);
  static const String pageRaute = 'end payment';
  final UserSession userSession;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Image.asset(
            'assets/images/endpayment.PNG',
            width: double.infinity,
          ),
          const Text(
            'Payment Done!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            '''
          Check your email for booking confirmation.
                    We ‘ll see you soon     
                            ''',
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomePageClient(userSession: userSession)),
              );
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
                'Ok',
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
