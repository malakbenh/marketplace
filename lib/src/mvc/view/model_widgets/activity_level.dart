import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitafit/src/mvc/controller/add_program/add_proram_cubit.dart';


import '../screens/main_client/buy_program/core/assets.dart';
import '../screens/main_client/buy_program/data/model/activity_model.dart';
import 'custom_card.dart';

class CardListActivty extends StatefulWidget {
  const CardListActivty({super.key});

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardListActivty> {
  int selectedCardIndex = -1;

  List<ActivityModel> cardTitles = [
    ActivityModel(text: 'Not very active', image: AppImage.notActivity),
    ActivityModel(text: 'Moderately active', image: AppImage.modactivity),
    ActivityModel(text: 'Very active', image: AppImage.veryactivity),
    ActivityModel(text: 'Active', image: AppImage.activity),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: cardTitles.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedCardIndex = index;
                });
                context.read<OrderBloc>().activityLevel =
                    cardTitles[index].text!;
              },
              child: CustomCard(
                title: cardTitles[index].text!,
                image: cardTitles[index].image!,
                isSelected: selectedCardIndex == index,
              ),
            ),
          );
        },
      ),
    );
  }
}
