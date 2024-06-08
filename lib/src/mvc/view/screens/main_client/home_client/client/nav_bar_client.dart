// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
// import 'package:vitaf/pages/coach/notifications.dart';
// import 'package:vitaf/pages/coach/add_friends.dart';
// import 'package:vitaf/pages/coach/messages.dart';
// import 'package:vitaf/pages/coach/home.dart';

import '../../../../../model/models.dart';
import '../../../../screens.dart';

class NavBarClient extends StatefulWidget {
  const NavBarClient({
    super.key,
    required this.userSession,
  });
  final UserSession userSession;

  @override
  State<NavBarClient> createState() => _NavBarState();
}

class _NavBarState extends State<NavBarClient>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int currentScreen = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: controller,
          unselectedLabelColor: Color.fromARGB(255, 85, 84, 84),
          labelColor: Color(0xFF35A072),
          tabs: [
            Tab(
              icon: ImageIcon(
                AssetImage('assets/icons/Vector (3).png'),
                size: 25.0,
              ),
            ),
            Tab(
              icon: ImageIcon(
                AssetImage(
                    'assets/icons/Vector (4).png'), // Replace with your image path

                size: 25.0,
              ),
            ),
            Tab(
              icon: ImageIcon(
                AssetImage(
                    'assets/icons/Vector (5).png'), // Replace with your image path

                size: 25.0,
              ),
            ),
            Tab(
              icon: ImageIcon(
                AssetImage(
                    'assets/icons/tdesign_notification.png'), // Replace with your image path

                size: 25.0,
              ),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: [
              HomeClient(),
              NotificationsClient(),
              HomeChat(
                userSession: widget.userSession,
                currentPage: controller.index,
              ),
              AddFriendClient(),
            ],
          ),
        ),
      ],
    );
  }
}
