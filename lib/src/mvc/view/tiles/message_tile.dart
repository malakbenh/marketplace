import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../tools.dart';
import '../../model/models.dart';
import '../dialogs/slideshows.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return MessageContent(
      message: message,
      fontColor: message.primaryColor,
      children: [
        if (message.isText)
          Text(
            message.message!,
            style: context.h4b1.copyWith(
              color: message.primaryColor,
            ),
          ),
        if (message.isImage)
          InkResponse(
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (context) => SingleImageSlideshow(
                image: message.photo!,
              ),
              backgroundColor: Colors.black,
              enableDrag: true,
              isScrollControlled: true,
              isDismissible: true,
            ),
            child: AspectRatio(
              aspectRatio: message.aspectRatio!,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 200.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.sp),
                  image: DecorationImage(
                    image: message.photo!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class MessageContent extends StatelessWidget {
  const MessageContent({
    super.key,
    required this.message,
    required this.fontColor,
    required this.children,
  });

  final Message message;
  final Color fontColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: message,
      child: Consumer<Message>(
        builder: (context, message, _) {
          //used to align tile for owner and reciever
          return Row(
            mainAxisAlignment: message.isMine
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              badge.Badge(
                badgeStyle: const badge.BadgeStyle(
                  badgeColor: Colors.transparent,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                ),
                showBadge: !message.hasError && message.isSending,
                position: badge.BadgePosition.bottomEnd(
                  bottom: message.hasError ? -20 : -8,
                  end: -8,
                ),
                badgeContent: Container(
                  width: 10.sp,
                  height: 10.sp,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: context.primary,
                      width: 2.sp,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                //used to show tile content and error message if there is an error
                child: Column(
                  crossAxisAlignment: message.isMine
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    //message content
                    MessageCard(
                      message: message,
                      fontColor: fontColor,
                      children: children,
                    ),
                    4.heightH,
                    Row(
                      children: [
                        if (message.isSeen) ...[
                          Icon(
                            Icons.done_all,
                            size: 18.sp,
                            color: context.primary,
                          ),
                          4.widthSp,
                        ],
                        if (message.hasError) ...[
                          Text(
                            AppLocalizations.of(context)!.something_went_wrong,
                            style: context.h6b1.copyWith(
                              fontWeight: Styles.medium,
                              color: Styles.red,
                            ),
                          ),
                          3.widthSp,
                          Icon(
                            Icons.warning_amber,
                            color: Styles.red,
                            size: 12.sp,
                          ),
                          4.widthSp,
                        ],
                        Text(
                          DateTimeUtils.of(context).formatDateTime(
                            message.createdAt,
                          ),
                          style: context.h6b1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.message,
    required this.fontColor,
    required this.children,
  });

  final Message message;
  final Color fontColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor =
        message.isMine ? context.primaryColor : context.primaryColor.shade50;
    return Container(
      constraints: BoxConstraints(
        maxWidth: 0.75.sw,
        minWidth: 70.sp,
      ),
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadiusDirectional.only(
          topEnd: message.isMine ? Radius.zero : Radius.circular(6.sp),
          topStart: !message.isMine ? Radius.zero : Radius.circular(6.sp),
          bottomEnd: Radius.circular(6.sp),
          bottomStart: Radius.circular(6.sp),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
