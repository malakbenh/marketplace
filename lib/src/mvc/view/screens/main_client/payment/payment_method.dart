//import 'package:coach/payment/add_card.dart';
import 'package:flutter/material.dart';

import '../../../screens.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({Key? key}) : super(key: key);
  static const String pageRaute = 'Payment Method';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Method',
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Image.asset('assets/images/carte-bancaire 1.png'),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: 2,
                  height: 20,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text('Edhahabya Card '),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Image.asset('assets/images/ccp.png'),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: 2,
                  height: 20,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text('CCP'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Image.asset('assets/images/cib.png'),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: 2,
                  height: 20,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text('CIB'),
              ],
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(AddCard.pageRoute);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: 156,
              height: 47,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xff35A072),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Add Card',
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
