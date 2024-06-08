import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vitafit/src/tools.dart';

import '../../../model/list_models.dart';
import '../../../model/models.dart';
import '../../model_widgets.dart';
import '../../tiles.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.chat,
  });

  final Chat chat;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20.sp,
              backgroundColor: context.primary.withOpacity(0.5),
              foregroundImage: widget.chat.destination.photo,
            ),
            SizedBox(width: 10.sp),
            Text(
              widget.chat.destination.name,
              style: context.h4b1.copyWith(color: Colors.white),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: ChangeNotifierProvider.value(
          value: widget.chat.listMessages,
          child: Consumer<ListMessages>(
            builder: (context, listMessages, _) {
              if (!widget.chat.init) {
                widget.chat.markAsSeen();
                widget.chat.listMessages.get();
              }
              return NotificationListener<ScrollNotification>(
                onNotification: listMessages.onMaxScrollExtent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (listMessages.isNull && !widget.chat.init)
                      const Expanded(
                        child: CustomLoadingIndicator(
                          isSliver: false,
                        ),
                      ),
                    if (widget.chat.init)
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                100.heightH,
                                Text(
                                  '👋',
                                  style: context.h1b1,
                                ),
                                20.heightH,
                                Text(
                                  AppLocalizations.of(context)!.connect_with(
                                    widget.chat.destination.name,
                                  ),
                                  textAlign: TextAlign.center,
                                  style: context.h4b1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (listMessages.isNotEmpty)
                      Expanded(
                        child: ListView.separated(
                          physics: const ClampingScrollPhysics(),
                          itemCount: listMessages.length +
                              (listMessages.hasMore ? 1 : 0),
                          itemBuilder: (context, index) => itembuilderMessage(
                            context,
                            index,
                            listMessages,
                          ),
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 10.sp),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.sp,
                            vertical: 16.sp,
                          ),
                          reverse: true,
                        ),
                      ),
                    CustomSendMessageWidget(chat: widget.chat),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget itembuilderMessage(
    BuildContext context,
    int index,
    ListMessages listMessages,
  ) {
    if (index < listMessages.length) {
      return MessageTile(
        message: listMessages.elementAt(index),
      );
    } else {
      return CustomTrailingTile(
        isNotNull: listMessages.isNotNull,
        isLoading: listMessages.isLoading,
        hasMore: listMessages.hasMore,
        quarterTurns: 2,
        isSliver: false,
        margin: EdgeInsets.symmetric(vertical: 10.sp),
      );
    }
  }
}
