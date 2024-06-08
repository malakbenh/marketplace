import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../../../model/models.dart';
import '../../screens.dart';

class NavBarStore extends StatefulWidget {
  final UserSession userSession; // Add userSession property

  const NavBarStore({required this.userSession, Key? key}) : super(key: key);

  @override
  State<NavBarStore> createState() => _NavBarState();
}

class _NavBarState extends State<NavBarStore> {
  late PageController controller;
  int curentScreen = 0;
  late List<Widget> screens;

  @override
  void initState() {
    controller = PageController(initialPage: curentScreen);
    screens = [
      const HomeStore(),
      HomeProgram(
          currentUser: widget.userSession.currentUser), // Pass currentUser here
      const Favorite(),
      const Orders(),
      ProfilePage(userSession: widget.userSession), // Pass userSession here
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: (index) {
          setState(() {
            curentScreen = index;
          });
        },
        controller: controller,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: Colors.white,
        selectedIndex: curentScreen,
        onDestinationSelected: (index) {
          setState(() {
            curentScreen = index;
          });
          controller.jumpToPage(curentScreen);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            selectedIcon: Icon(Icons.home),
          ),
          NavigationDestination(
            icon: Icon(Icons.notes_rounded),
            label: 'Program',
          ),
          NavigationDestination(
            icon: Icon(IconlyBold.heart),
            label: 'Favorite',
          ),
          NavigationDestination(
            icon: Icon(Icons.card_travel),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
