import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../tools.dart';
import '../../controller/services.dart';
import '../../view/screens.dart';
import '../list_models/list_messages.dart';
import '../models.dart';

class Chat with ChangeNotifier {
  /// Set to `true` when the is created locally on the smartphone, and set to
  /// `false` when it is pushed to the database
  bool init;

  /// Chat id
  final String id;

  /// Current user, who send messages.
  final UserMin author;

  /// Other user selected as a destination.
  final UserMin destination;

  /// Last sent/received message
  String lastMessage;

  /// Number of unread messages for each user.
  Map<String, dynamic> unread;

  /// Timestamp of when was the chat created.
  DateTime createdAt;

  /// Last update.
  DateTime updatedAt;

  /// Document reference
  final DocumentReference reference;

  /// List of messages inside the chat.
  final ListMessages listMessages;

  Chat({
    this.init = false,
    required this.id,
    required this.author,
    required this.destination,
    required this.lastMessage,
    required this.unread,
    required this.createdAt,
    required this.updatedAt,
    required this.reference,
    required this.listMessages,
  });

  factory Chat.init({
    required UserMin author,
    required UserMin destination,
  }) {
    assert(author.uid != destination.uid,
        'author.uid != destination.uid is not true.');
    List<String> listIds = [author.uid, destination.uid];
    listIds.sort();
    String uids = listIds.join('-');
    DocumentReference reference = ChatsService.getReference(uids);
    return Chat(
      init: true,
      id: reference.id,
      author: author,
      destination: destination,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      lastMessage: '',
      unread: {
        author.uid: 0,
        destination.uid: 0,
      },
      reference: reference,
      listMessages: ListMessages(
        authorId: author.uid,
        chatId: reference.id,
      ),
    );
  }

  factory Chat.fromDocumentSnapshot({
    required DocumentSnapshot doc,
    required String authorId,
  }) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    List<UserMin> members =
        List.from(json['members']).map((e) => UserMin.fromMap(e)).toList();
    return Chat(
      id: doc.id,
      author: members.where((element) => element.uid == authorId).first,
      destination: members.where((element) => element.uid != authorId).first,
      createdAt: DateTimeUtils.getDateTimefromTimestamp(json['createdAt'])!,
      updatedAt: DateTimeUtils.getDateTimefromTimestamp(json['updatedAt'])!,
      lastMessage: json['lastMessage'],
      unread: json['unread'],
      reference: doc.reference,
      listMessages: ListMessages(
        authorId: authorId,
        chatId: doc.id,
      ),
    );
  }

  void openChatScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: this,
          child: ChatScreen(chat: this),
        ),
      ),
    );
  }

  Future<void> markAsSeen() async {
    if (unread[author.uid] != 0) {
      await ChatsService.markAsSeen(
        authorId: author.uid,
        refrence: reference,
      );
    }
    for (var message
        in listMessages.list.where((message) => message.isNotSeen)) {
      message.markAsSeen();
    }
  }

  Future<void> create() async {
    await ChatsService.create(chat: this);
  }

  Future<void> delete() async {
    await reference.delete();
  }

  Map<String, dynamic> get toMapInit => {
        'members': [author, destination].map((e) => e.toMapInit).toList(),
        'members_id': [author, destination].map((e) => e.uid).toList(),
        'lastMessage': '',
        'unread': unread,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        // Use the updateKey in the cloud functions to query any chat document triggered by a specific event.
        // Example: When the user updates his name or profile picture, update it in all chat documents that has updateKey < updateTimeStamp.
        'updateKey': FieldValue.serverTimestamp(),
      };

  void updateWithChat(Chat chat) {
    updatedAt = chat.updatedAt;
    unread = chat.unread;
    lastMessage = chat.lastMessage;
  }

  Future<void> send(Message message) async {
    if (message.isText && message.message!.isEmpty) return;
    late bool insertIntoListMessage;
    if (init) {
      await create();
      init = false;
      insertIntoListMessage = false;
    } else {
      insertIntoListMessage = true;
    }
    Map<String, dynamic> chatMapUpdate = {
      'updatedAt': FieldValue.serverTimestamp(),
      'unread.${destination.uid}': FieldValue.increment(1),
      ...message.toMapChatUpdate,
    };
    message
        .create()
        .then(
          (_) => ChatsService.update(
            chat: this,
            data: chatMapUpdate,
          ),
        )
        .catchError((_) => message.updateHasError());
    if (insertIntoListMessage) {
      // insert the message in state sending, while the message is fully pushed
      //to the database and the UI is rebuilt with the stream.
      listMessages.insert(message);
    } else {
      listMessages.notifyListeners();
    }
    notifyListeners();
  }

  bool get seen => unread[author.uid] == 0 || unread[author.uid] == null;

  String get unreadMessages => (unread[author.uid] ?? 0).toString();
}
