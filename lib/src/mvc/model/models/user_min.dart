import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../extensions.dart';
import '../../controller/services.dart';
import '../enums/update_unread_chat_count.dart';
import '../list_models/list_chats.dart';
import '../list_models/list_users.dart';

class UserMin with ChangeNotifier {
  final String uid;
  final String name;
  final String? photoUrl;
  final ImageProvider<Object>? photo;
  final DocumentReference reference;
  ListChats? listChats;
  int unreadChats = 0;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? streamSubscription;

  UserMin({
    required this.uid,
    required this.name,
    required this.photoUrl,
    required this.photo,
    required this.reference,
    required this.listChats,
  });

  factory UserMin.init(String name, String photoUrl) {
    DocumentReference doc =
        FirebaseFirestore.instance.collection('users').doc();
    return UserMin(
      uid: doc.id,
      name: name,
      photoUrl: photoUrl,
      photo: CachedNetworkImageProvider(photoUrl),
      reference: doc,
      listChats: null,
    );
  }

  factory UserMin.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    UserMin userMin = UserMin(
      uid: json['uid'],
      name: json['name'],
      photoUrl: json['photoUrl'],
      photo: (json['photoUrl'] as String?).toImageProvider,
      reference: doc.reference,
      listChats: null,
    );
    userMin.listChats = ListChats(
      authorId: doc.id,
      onUpdateDate: ListUsers.update == UpdateUnreadChatCount.get
          ? userMin.updateUnreadChatsCount
          : null,
    );
    return userMin;
  }

  factory UserMin.fromMap(Map<String, dynamic> json) => UserMin(
        uid: json['uid'],
        name: json['name'],
        photoUrl: json['photoUrl'],
        photo: (json['photoUrl'] as String?).toImageProvider,
        reference:
            FirebaseFirestore.instance.collection('users').doc(json['id']),
        listChats: null,
      );

  Map<String, dynamic> get toMapInit => {
        'uid': uid,
        'name': name,
        'photoUrl': photoUrl,
      };

  Future<void> create() async {
    try {
      await UsersService.create(user: this);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> delete() async {
    try {
      await reference.delete();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> initListChats() async {
    try {
      await listChats?.get();
    } catch (e) {
      // Handle error
    }
  }

  bool get requireActivatingStream => streamSubscription == null;

  void disableMessagesListener() {
    if (ListUsers.update != UpdateUnreadChatCount.stream) return;
    streamSubscription?.cancel().then(
          (_) => streamSubscription = null,
        );
  }

  void activateMessagesListener() {
    if (ListUsers.update != UpdateUnreadChatCount.stream) return;
    if (!requireActivatingStream) return;
    streamSubscription = ChatsService.listenToUnreadChatsSubscription(
      uid: uid,
      onData: (event) {
        unreadChats = event.docs.length;
        notifyListeners();
      },
    );
  }

  void onActivateUser() {
    if (ListUsers.update == UpdateUnreadChatCount.stream) {
      activateMessagesListener();
    } else {
      updateUnreadChatsCount();
    }
    listChats?.activateMessagesListener();
  }

  void onDisbaleUser() {
    if (ListUsers.update == UpdateUnreadChatCount.stream) {
      disableMessagesListener();
    }
    listChats?.activateMessagesListener();
  }

  Future<void> updateUnreadChatsCount() async {
    if (ListUsers.update != UpdateUnreadChatCount.get) return;
    try {
      int count = await ChatsService.getUnreadChats(uid);
      unreadChats = count;
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }
}
