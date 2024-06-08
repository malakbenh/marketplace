// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:vitafit/src/mvc/model/enums.dart';
import 'package:vitafit/src/mvc/model/models.dart';
import 'package:vitafit/src/tools.dart';
import '../../../model_widgets.dart';
import '../../../model_widgets/custom_list_tile.dart';
import '../profile/setting.dart';

class ProfilePage extends StatelessWidget {
  final UserSession userSession;

  const ProfilePage({Key? key, required this.userSession}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double avatarRadius = 70;
    const double backgroundHeight = 200;

    ImageProvider<Object>? getUserPhoto() {
      if (userSession.photo is String && userSession.photo != null) {
        return NetworkImage(userSession.photo as String);
      } else if (userSession.photo is ImageProvider<Object>) {
        return userSession.photo as ImageProvider<Object>;
      } else {
        return AssetImage('assets/images/avatar.png');
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile'),
        backgroundColor: Colors.deepOrange[300],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            child: ClipPath(
              clipper: OvalBottomBorderClipper(),
              child: Container(
                color: Colors.deepOrange[300],
                height: backgroundHeight,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 150),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                        offset: Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      Text(
                        userSession.displayname ?? 'No name available',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userSession.email ?? 'No email available',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const Divider(),
                      CustomListTile(
                        onTap: () {
                          // Handle notifications tap
                          print('Notifications tapped');
                        },
                        icon: Icons.notifications,
                        title: 'Notifications',
                      ),
                      CustomListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Settings_Screen(
                                      userSession:
                                          userSession, // use userSession directly
                                    )),
                          );
                        },
                        icon: Icons.settings,
                        title: 'Settings',
                      ),
                      CustomListTile(
                        onTap: () {
                          // Handle about tap
                          print('About tapped');
                        },
                        icon: Icons.info,
                        title: 'About',
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: CustomMenuListTile(
                          icon: AwesomeIconsRegular.arrow_right_from_bracket,
                          title: 'Logout',
                          color: Styles.red,
                          onTap: () => _showLogoutDialog(context, userSession),
                          autoPop: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 80,
            left: MediaQuery.of(context).size.width / 2 - avatarRadius,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: avatarRadius,
              child: CircleAvatar(
                radius: avatarRadius - 1,
                backgroundColor: Color(0xff3C3B3A),
                foregroundImage: getUserPhoto(),
                child: userSession.photo == null
                    ? Icon(
                        Icons.person_outline_rounded,
                        color: Colors.white,
                        size: 60,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, UserSession userSession) {
    Dialogs.of(context).showAlertDialog(
      dialogState: DialogState.confirmation,
      title: 'Confirm Logout',
      subtitle: 'Are you sure you want to log out?',
      onContinue: () async {
        await userSession.signOut();
        while (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
      continueLabel: 'Logout',
    );
  }
}
