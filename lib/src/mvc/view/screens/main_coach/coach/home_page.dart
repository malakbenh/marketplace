import 'package:flutter/material.dart';
import 'package:vitafit/src/mvc/view/screens.dart';
import '../../../../model/models.dart';

class HomePage extends StatefulWidget {
  final UserSession userSession; // Add UserSession parameter

  const HomePage({super.key, required this.userSession}); // Update constructor

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 60.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Image(
              image: AssetImage('assets/coaches/VitaFit.png'),
              width: 90.0,
              height: 90.0,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          userSession:
                              widget.userSession, // Pass the userSession
                        ),
                      ),
                    );
                  },
                  child: const ImageIcon(
                    AssetImage(
                        'assets/coaches/Vector.png'), // Replace with your image path
                    color: Colors.black,
                    size: 40.0,
                  ),
                ),
                const SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile_Screen(
                          userSession:
                              widget.userSession, // Pass the userSession
                        ),
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/coaches/Ellipse 54.png'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: NavBar(
        userSession: widget.userSession,
      ), // Use the NavBar widget directly
    );
  }
}
