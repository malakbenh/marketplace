import 'package:flutter/material.dart';

class OverView extends StatelessWidget {
  const OverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 10,),
             Container(
               height: 20,
               width: 20,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(20),
                 color: const Color(0xff35A072),
               ),
               child: const Text(
                 '  i',
                 style: TextStyle(color: Colors.white,
                   fontWeight: FontWeight.bold,),),
             ),
              const SizedBox(width: 20,),
              const Text(
                'About',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,

              ),
              ),
            ],
          ),
          const Text('''
          Fitness personal trainer
          Fitness end building Zumba Aerobic
          Sports nutrition
          Experience: 10 Years 
      '''),
          Row(
            children: [
              const SizedBox(width: 10,),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color:  Colors.white,
                ),
                child: const Icon(Icons.watch_later,color: Color(0xff35A072),),
              ),
              const SizedBox(width: 20,),
              const Text(
                'Time',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,

                ),
              ),
            ],
          ),
          const Text(
            '''
            8:00 AM - 21:00 PM
            ''',
          ),
          Row(
            children: [
              const SizedBox(width: 10,),
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color:  const Color(0xff35A072),
                ),
                child: const Center(
                  child: Text(
                    '\$',
                    style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold,
                    fontSize: 18),),
                ),
              ),
              const SizedBox(width: 20,),
              const Text(
                'Price:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,

                ),
              ),
            ],
          ),
          const Text(
            '''
            3000 DA In month
            ''',
          ),







        ],
      ),
    );
  }
}
