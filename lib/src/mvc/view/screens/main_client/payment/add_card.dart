//import 'package:coach/payment/end_payment.dart';
//import 'package:coach/widget/custom_textfiled.dart';
import 'package:flutter/material.dart';

import '../../../model_widgets/custom_textfiled.dart';
import '../../../screens.dart';

class AddCard extends StatelessWidget {
  const AddCard({Key? key}) : super(key: key);
  static String pageRoute = 'add card';

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Add Card'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomTextFiled(
                hint: 'Full Name'
            ),
        
            CustomTextFiled(
                hint: 'Card Number'
            ),
            Row(
              children: [
                Expanded(
                  child:CustomTextFiled(
                    hint: 'Expiration date'
                ),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child:CustomTextFiled(
                    hint: 'CVC2/CVV2'
                ),
                ),
              ],
            ),
            const SizedBox(height: 30,),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Grand Total :'),
                Text('4000.00 DA')
              ],
            ),
            const Spacer(),
            InkWell(
              onTap: (){
                Navigator.of(context).pushNamed(EndPayment.pageRaute);
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
                  'Pay Now',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      
    );
  }
}
