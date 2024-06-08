import 'package:flutter/material.dart';
import 'package:vitafit/src/mvc/view/screens.dart';
import '../../../../../model/models.dart';

class HomePageClient extends StatefulWidget {
  final UserSession userSession;
  static String get pageRoute => '/homePageClient';

  const HomePageClient({super.key, required this.userSession});

  @override
  _HomePageClientState createState() => _HomePageClientState();
}

class _HomePageClientState extends State<HomePageClient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Move this line here
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
                IconButton(
                  icon: const ImageIcon(
                    AssetImage('assets/coaches/Vector.png'),
                    color: Colors.black,
                    size: 40.0,
                  ),
                  onPressed: () {},
                ),
                const SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile_Screen(
                          userSession: widget.userSession,
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
      body: NavBarClient(
        userSession: widget.userSession,
      ),
    );
  }
}
