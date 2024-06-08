import 'package:flutter/material.dart';

import '../screens.dart';

class ItemsOnepage extends StatelessWidget {
  const ItemsOnepage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        GestureDetector(
          onTap: () {},
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: AssetImage(
                          AppImage.onBoardingImageMen,
                        ))),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Text(
                'man',
                style: AppStyles.textStyle16,
              ),
            ],
          ),
        ),
        Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fitHeight,
                      image: AssetImage(
                        AppImage.onBoardingImageWomen,
                      ))),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Text(
              'Woman',
              style: AppStyles.textStyle16,
            ),
          ],
        ),
      ],
    );
  }
}
