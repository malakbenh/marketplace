import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculate the position of the avatar to be placed in the middle
    // of the red background and draggable sheet
    const double avatarRadius = 50;
    // final double draggableSheetPeekSize =
    //     MediaQuery.of(context).size.height * .6;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff868686),
        elevation: 0,
        centerTitle: true,
        title:
            const Text('Edit Profile', style: TextStyle(color: Colors.black)),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff868686), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: .8,
            minChildSize: .6,
            maxChildSize: .8,
            builder: (BuildContext context, myscrollController) {
              return Container(
                padding: const EdgeInsets.only(top: 60), // Space for the avatar
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const TextField(
                          decoration: InputDecoration(labelText: 'Full Name'),
                        ),
                        const TextField(
                          decoration: InputDecoration(labelText: 'E-mail'),
                        ),
                        const TextField(
                          decoration:
                              InputDecoration(labelText: 'Phone Number'),
                        ),
                        const SizedBox(height: 100),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffEAEAEA)),
                                onPressed: () {},
                                child: const Text(
                                  'cancel',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                )),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32),
                                    backgroundColor: const Color(0xff35A072)),
                                onPressed: () {},
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const Positioned(
            top: 70,
            left: 0,
            right: 0,
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundColor: Color(0xff3C3B3A),
              child: Icon(Icons.person_outline_rounded,
                  size: 50, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
