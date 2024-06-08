import 'package:flutter/material.dart';

import '../../../../../tools.dart';
import '../../../../model/enums/dialog_state.dart';
import '../../../../model/models.dart';
import '../../../model_widgets.dart';
import '../../../screens.dart';

class Settings_Screen extends StatefulWidget {
  final UserSession userSession;

  const Settings_Screen({
    Key? key,
    required this.userSession,
  }) : super(key: key);

  @override
  State<Settings_Screen> createState() => _Settings_ScreenState();
}

class _Settings_ScreenState extends State<Settings_Screen> {
  bool isNotificationActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 10),
                  Text(
                    'Account',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              color: const Color(0xffFCFCFC),
              child: Column(
                children: [
                  const ProfileWidget(
                    text: 'Edit Profile',
                    image: 'assets/icons/edit.png',
                  ),
                  ProfileWidget(
                    text: 'Change Password',
                    image: 'assets/icons/change.png',
                    onTap: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: CustomMenuListTile(
                      icon: AwesomeIconsRegular.eraser,
                      title: 'Delete Account',
                      color: Styles.black,
                      onTap: () => context.push(
                        widget: DeleteAccount(userSession: widget.userSession),
                      ),
                      autoPop: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: CustomMenuListTile(
                      icon: AwesomeIconsRegular.arrow_right_from_bracket,
                      title: 'Logout',
                      color: Styles.red,
                      onTap: () => Dialogs.of(context).showAlertDialog(
                        dialogState: DialogState.confirmation,
                        subtitle: 'Are you sure you want to disconnect?',
                        onContinue: () => Dialogs.of(context).runAsyncAction(
                          future: widget.userSession.signOut,
                        ),
                        continueLabel: 'Logout',
                      ),
                      autoPop: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.notifications),
                  SizedBox(width: 10),
                  Text(
                    'Notifications',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              color: const Color(0xffFCFCFC),
              child: Column(
                children: [
                  SettingWidget(
                    text: 'Active Notification',
                    ifActive: true,
                    image: 'assets/icons/edit.png',
                    onTap: () {},
                  ),
                  SettingWidget(
                    text: 'Language',
                    ifActive: false,
                    image: 'assets/icons/lan.png',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileWidget extends StatefulWidget {
  final String text;
  final Function? onTap;
  final String? image;
  final Color? color;
  final double? pad;
  final bool if_active;

  const ProfileWidget({
    super.key,
    this.text = '',
    this.onTap,
    this.image,
    this.color,
    this.pad,
    this.if_active = false,
  });

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap as void Function()?,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        padding: EdgeInsets.all(widget.pad ?? 8),
        width: double.infinity,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    padding: EdgeInsets.all(widget.pad ?? 8),
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Center(
                        child: widget.image != null
                            ? Image.asset(
                                widget.image!,
                                color: widget.color ?? Colors.black,
                              )
                            : Container())),
                const SizedBox(
                  width: 10,
                ),
                Text(widget.text)
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: widget.color ?? Colors.black,
            )
          ],
        ),
      ),
    );
  }
}

class SettingWidget extends StatefulWidget {
  final String text;
  final bool ifActive;
  final Function? onTap;
  final String? image;
  final Color? color;
  final double? pad;

  const SettingWidget({
    super.key,
    required this.text,
    this.ifActive = false,
    this.onTap,
    this.image,
    this.color,
    this.pad,
  });

  @override
  _SettingWidgetState createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  bool isNotificationActive = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap as void Function()?,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        padding: EdgeInsets.all(widget.pad ?? 8),
        width: double.infinity,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (!widget.ifActive)
                  Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Center(
                          child: widget.image != null
                              ? Image.asset(
                                  widget.image!,
                                  color: widget.color ?? Colors.black,
                                )
                              : Container())),
                if (widget.ifActive)
                  const SizedBox(
                    width: 10,
                  ),
                Text(widget.text)
              ],
            ),
            if (widget.ifActive)
              Switch(
                value: isNotificationActive,
                onChanged: (v) {
                  setState(() {
                    isNotificationActive = v;
                  });
                },
                activeColor: Colors.white,
                activeTrackColor: Colors.lightGreenAccent,
              ),
            if (!widget.ifActive)
              const Row(
                children: [
                  Text(
                    'English',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
