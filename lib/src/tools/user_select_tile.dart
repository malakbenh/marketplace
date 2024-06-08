import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vitafit/src/extensions.dart';
import '../mvc/model/models/user_min.dart';
import 'styles.dart';

class UserSelectTile extends StatelessWidget {
  const UserSelectTile({
    super.key,
    required this.user,
    required this.currentUser,
    required this.onPickUser,
    required this.label1,
    required this.otherUser,
    required this.label2,
  });

  final UserMin user;
  final UserMin? currentUser;
  final String label1;
  final UserMin? otherUser;
  final String label2;
  final void Function(UserMin) onPickUser;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        if (user.uid == otherUser?.uid) {
          context.showSnackBar(AppLocalizations.of(context)!.pick_another_user);
          return;
        }
        onPickUser(user);
        context.pop();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28.sp,
            backgroundColor: context.primary.withOpacity(0.5),
            backgroundImage: user.photo,
          ),
          14.widthSp,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        user.name,
                        style: context.h4b1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Text(
                  user.uid,
                  style: context.h6b2,
                ),
              ],
            ),
          ),
          14.widthSp,
          if (user.uid == currentUser?.uid)
            Chip(
              label: Text(
                label1,
                style: Styles.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              backgroundColor: context.primary,
            ),
          if (user.uid == otherUser?.uid)
            Chip(
              label: Text(
                label2,
                style: Styles.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              backgroundColor: context.secondary,
            ),
        ],
      ),
    );
  }
}
