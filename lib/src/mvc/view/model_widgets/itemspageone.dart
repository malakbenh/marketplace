import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/add_program/add_proram_cubit.dart';
import '../screens.dart';

class ItemsPageone extends StatefulWidget {
  const ItemsPageone({super.key});

  @override
  _ContainerListState createState() => _ContainerListState();
}

class _ContainerListState extends State<ItemsPageone> {
  bool _isFirstExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: _isFirstExpanded ? 2 : 1,
          child: GestureDetector(
            onTap: () {
              context.read<OrderBloc>().gender = 'Man';
              setState(() {
                _isFirstExpanded = true;
              });
            },
            child: Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.06,
                  left: 15,
                  child: CircleAvatar(
                    backgroundColor: _isFirstExpanded
                        ? AppColors.primaryColor
                        : Colors.white,
                    radius: 80,
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: _isFirstExpanded
                          ? MediaQuery.of(context).size.height * 0.45
                          : MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: AssetImage(
                                AppImage.man,
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
              ],
            ),
          ),
        ),
        Expanded(
          flex: _isFirstExpanded ? 1 : 2,
          child: GestureDetector(
            onTap: () {
              context.read<OrderBloc>().gender = 'Woman';
              setState(() {
                _isFirstExpanded = false;
              });
            },
            child: Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.06,
                  left: 15,
                  child: CircleAvatar(
                    backgroundColor: _isFirstExpanded
                        ? Colors.white
                        : AppColors.primaryColor,
                    radius: 80,
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
                                AppImage.woman,
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
            ),
          ),
        ),
      ],
    );
  }
}
