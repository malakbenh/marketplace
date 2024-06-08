import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/add_program/add_proram_cubit.dart';
import '../screens.dart';

class ListWheelScrollViewExampleHighe extends StatefulWidget {
  const ListWheelScrollViewExampleHighe({Key? key}) : super(key: key);

  @override
  State<ListWheelScrollViewExampleHighe> createState() =>
      _ListWheelScrollViewExampleState();
}

class _ListWheelScrollViewExampleState
    extends State<ListWheelScrollViewExampleHighe> {
  final List<String> age =
      List.generate(200, (index) => (170 + index).toString());

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      itemExtent: 90,
      diameterRatio: 1.9,
      childDelegate: ListWheelChildLoopingListDelegate(
        children: List.generate(
          age.length,
          (index) => Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                  border: Border.symmetric(
                      horizontal: BorderSide(
                color: index == _selectedIndex
                    ? AppColors.primaryColor
                    : Colors.white,
              ))),
              child: Row(
                children: [
                  Text(
                    age[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: index == _selectedIndex
                          ? AppColors.primaryColor
                          : Colors.grey[400],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' cm',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          index == _selectedIndex ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onSelectedItemChanged: (index) {
        setState(() {
          _selectedIndex = index % age.length;
          context.read<OrderBloc>().height = int.parse(age[_selectedIndex]);
        });
      },
    );
  }
}
