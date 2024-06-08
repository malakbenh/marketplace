import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../extensions.dart';
import '../../model/list_models/list_users.dart';
import '../../model/models.dart';

class UserAppBarTitle extends StatelessWidget {
  const UserAppBarTitle({
    super.key,
    required this.user,
    required this.listUsers,
    required this.onTap,
  });

  final UserMin? user;
  final ListUsers listUsers;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Text(
        AppLocalizations.of(context)!.home_appbar_title,
      );
    }
    return InkResponse(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: context.primary.withOpacity(0.5),
            backgroundImage: user?.photo,
          ),
          8.widthSp,
          Expanded(child: Text(user!.name)),
        ],
      ),
    );
  }
}
