import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../tools.dart';
import '../../model/models.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.chat,
  });

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => chat.openChatScreen(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24.sp,
            backgroundColor: context.primary.withOpacity(0.5),
            backgroundImage: chat.destination.photo,
          ),
          18.widthSp,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.destination.name,
                  style: context.h4b1.copyWith(
                    fontWeight: Styles.semiBold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                4.heightSp,
                Text(
                  chat.lastMessage,
                  style: context.h5b1.copyWith(
                    fontWeight: chat.seen ? null : Styles.semiBold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          8.widthSp,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Opacity(
                opacity: chat.seen ? 0 : 1,
                child: Card(
                  margin: EdgeInsets.zero,
                  shape: const CircleBorder(),
                  elevation: 1,
                  child: Container(
                    height: 18.sp,
                    width: 18.sp,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      chat.unreadMessages,
                      style: Styles.poppins(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              4.heightSp,
              Text(
                DateTimeUtils.of(context).formatDateTime(
                  chat.updatedAt,
                ),
                style: context.h6b1.copyWith(
                  fontWeight: chat.seen ? null : Styles.semiBold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
