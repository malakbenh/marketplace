import 'package:flutter/material.dart';

import '../../../../model/models.dart';
import '../../../screens.dart';

class NavBar extends StatefulWidget {
  const NavBar({
    super.key,
    required this.userSession,
  });

  final UserSession userSession;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with SingleTickerProviderStateMixin {
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
          unselectedLabelColor: const Color.fromARGB(255, 85, 84, 84),
          labelColor: const Color(0xFF35A072),
          tabs: const [
            Tab(
              icon: ImageIcon(
                AssetImage(
                    'assets/icons/Vector (3).png'), // Replace with your image path
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
                    'assets/icons/Vector (4).png'), // Replace with your image path

                size: 25.0,
              ),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: [
              const Home(),
              const Notifications(),
              HomeChat(
                userSession: widget.userSession,
                currentPage: controller.index,
              ),
              const AddFriend(),
            ],
          ),
        ),
      ],
    );
  }
}
