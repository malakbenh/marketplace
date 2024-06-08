import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vitafit/src/mvc/model/enums.dart';
import 'package:vitafit/src/mvc/model/models.dart';
import 'package:vitafit/src/tools.dart';

import '../../../model_widgets.dart';
import 'settings.dart';

class Profile_Screen extends StatefulWidget {
  final UserSession userSession;

  const Profile_Screen({super.key, required this.userSession});

  @override
  _Profile_ScreenState createState() => _Profile_ScreenState();
}

class _Profile_ScreenState extends State<Profile_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 70.sp,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 55.sp,
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.1),
                foregroundImage: widget.userSession.photo != null
                    ? widget.userSession.photo as ImageProvider<Object>
                    : const AssetImage('assets/images/avatar.png'),
              ),
            ),
            SizedBox(height: 20.sp),
            Text(
              widget.userSession.displayname ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.userSession.email ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const SizedBox(
              width: 300,
              child: Divider(color: Color.fromARGB(255, 206, 200, 200)),
            ),
            ProfileWidget(
              text: 'Notifications',
              image: 'assets/icons/not.png',
              onTap: () {},
            ),
            ProfileWidget(
              text: 'Statistics',
              image: 'assets/icons/stat.png',
              onTap: () {},
            ),
            ProfileWidget(
              text: 'Settings',
              image: 'assets/icons/set.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Settings_Screen(
                      userSession: widget.userSession,
                    ),
                  ),
                );
              },
            ),
            ProfileWidget(
              text: 'About',
              image: 'assets/icons/i.png',
              pad: 15.0,
              onTap: () {},
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: CustomMenuListTile(
                icon: AwesomeIconsRegular.arrow_right_from_bracket,
                title: 'Logout',
                color: Styles.red,
                onTap: () => _showLogoutDialog(context),
                autoPop: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Dialogs.of(context).showAlertDialog(
      dialogState: DialogState.confirmation,
      title: 'Confirm Logout',
      subtitle: 'Are you sure you want to log out?',
      onContinue: () async {
        await widget.userSession.signOut();
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      continueLabel: 'Logout',
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final String image;
  final Color color;
  final double pad;

  const ProfileWidget({super.key, 
    required this.text,
    required this.onTap,
    required this.image,
    this.color = Colors.black,
    this.pad = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(pad),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Image.asset(image)),
                ),
                const SizedBox(width: 10),
                Text(text, style: TextStyle(color: color)),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
