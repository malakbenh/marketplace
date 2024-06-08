import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/add_program/add_proram_cubit.dart';
import '../screens.dart';
import 'custom_card.dart';

class WorkOutList extends StatefulWidget {
  const WorkOutList({super.key});

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<WorkOutList> {
  int selectedCardIndex = -1;

  List<ActivityModel> cardTitles = [
    ActivityModel(text: 'Lose weight', image: AppImage.low),
    ActivityModel(text: 'Stay fit', image: AppImage.modactivity),
    ActivityModel(text: 'Over Weight ', image: AppImage.over),
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
                context.read<OrderBloc>().workoutGoal = cardTitles[index].text!;
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
