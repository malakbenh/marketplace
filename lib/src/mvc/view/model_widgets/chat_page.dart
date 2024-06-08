import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../tools.dart';
import '../../model/change_notifiers.dart';
import '../../model/list_models/list_chats.dart';
import '../../model/list_models/list_users.dart';
import '../../model/models.dart';
import '../model_widgets.dart';
import '../tiles/chat_tile.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({
    super.key,
    required this.user,
    required this.listUsers,
    required this.pageNotifier,
    // required this.openUserPicker,
  });

  final UserMin? user;
  final ListUsers listUsers;
  final NotifierPage pageNotifier;
  // final void Function() openUserPicker;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: user?.listChats,
      child: Consumer<ListChats?>(
        builder: (context, list, _) {
          if (list == null) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.sp),
                    child: Text(
                      AppLocalizations.of(context)!.home_no_user_subtitle,
                      textAlign: TextAlign.center,
                      style: context.h4b2.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  40.heightSp,
                  //   ElevatedButton.icon(
                  // //    onPressed: openUserPicker,
                  //     style: ElevatedButton.styleFrom(
                  //       padding: EdgeInsets.symmetric(
                  //         vertical: 8.sp,
                  //         horizontal: 22.sp,
                  //       ),
                  //       backgroundColor: pageNotifier.currentPage == 0
                  //           ? context.primary
                  //           : context.secondary,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(8.sp),
                  //         side: const BorderSide(
                  //           color: Colors.transparent,
                  //           width: 1.0,
                  //         ),
                  //       ),
                  //     ),
                  //     label: Text(
                  //       AppLocalizations.of(context)!.pick_a_user,
                  //       style: Styles.poppins(
                  //         fontSize: 14.sp,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //     icon: Icon(
                  //       Icons.person_rounded,
                  //       color: Colors.white,
                  //       size: 20.sp,
                  //     ),
                  //   ),
                ],
              ),
            );
          }
          return FirestoreSliverSetView<Chat>(
            list: list,
            emptyTitle: AppLocalizations.of(context)!.no_chats_title,
            emptySubtitle: AppLocalizations.of(context)!.no_chats_subtitle,
            seperator: 20.heightSp,
            builder: (
              context,
              index,
              chat,
              listChat,
            ) =>
                ChatTile(chat: chat),
          );
        },
      ),
    );
  }
}
