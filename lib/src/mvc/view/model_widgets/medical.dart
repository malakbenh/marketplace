import 'package:flutter/material.dart';
import '../screens.dart';
import 'custom_card.dart';

class MedicalList extends StatefulWidget {
  const MedicalList({super.key});

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<MedicalList> {
  int selectedCardIndex = -1;

  List<ActivityModel> cardTitles = [
    ActivityModel(text: 'Food allergies', image: AppImage.food),
    ActivityModel(text: 'Chronic illnesses', image: AppImage.hart),
    ActivityModel(
        text: 'Injury or surgery \n     history ', image: AppImage.injury),
    ActivityModel(text: 'Other', image: AppImage.other),
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
                // context.read<OrderBloc>().medicalHistory = cardTitles[index].text!;
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
