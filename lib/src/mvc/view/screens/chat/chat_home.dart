import 'package:flutter/material.dart';

import '../../../model/models.dart';
import '../../model_widgets.dart';
import '../../tiles.dart';

class HomeChat extends StatefulWidget {
  const HomeChat({
    super.key,
    required this.userSession,
    required this.currentPage,
  });

  final UserSession userSession;
  final int currentPage;

  @override
  State<HomeChat> createState() => _HomeState();
}

class _HomeState extends State<HomeChat> {
  @override
  Widget build(BuildContext context) {
    widget.userSession.listChats.get(get: widget.currentPage == 2);
    return FirestoreSliverSetView<Chat>(
      list: widget.userSession.listChats,
      emptyTitle: 'empty chat title',
      emptySubtitle: 'emptySubtitle',
      builder: (context, index, chat, listChat) => ChatTile(chat: chat),
    );
  }
}
