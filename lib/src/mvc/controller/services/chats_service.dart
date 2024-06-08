import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/firebase_firestore_path.dart';
import '../../model/list_models/list_chats.dart';
import '../../model/models.dart';

class ChatsService {
  static DocumentReference get newReference => FirebaseFirestore.instance
      .collection(FirebaseFirestorePath.chats())
      .doc();

  static DocumentReference getReference(String id) => FirebaseFirestore.instance
      .collection(FirebaseFirestorePath.chats())
      .doc(id);

  static Future<bool> hasUnreadMessages(String uid) async {
    return await FirebaseFirestore.instance
        .collection(FirebaseFirestorePath.chats())
        .where('unread.$uid', isGreaterThan: 0)
        .limit(1)
        .get()
        .then((snapshot) => snapshot.docs.isNotEmpty);
  }

  static Future<int> countUnreadMessages(String uid) {
    return FirebaseFirestore.instance
        .collection(FirebaseFirestorePath.chats())
        .where('unread.$uid', isGreaterThan: 0)
        .count()
        .get()
        .then((snapshot) => snapshot.count ?? 0);
  }

  static Future<Chat> getChatByUsersId({
    required String authorId,
    required String destinationId,
  }) async {
    List<String> listIds = [authorId, destinationId];
    listIds.sort();
    String uids = listIds.join('-');
    return await getChatById(chatId: uids, authorId: authorId);
  }

  static Future<Chat> getChatById({
    required String chatId,
    required String authorId,
  }) async {
    return await FirebaseFirestore.instance
        .doc(FirebaseFirestorePath.chat(id: chatId))
        .get()
        .then(
      (doc) {
        if (doc.exists) {
          return Chat.fromDocumentSnapshot(
            doc: doc,
            authorId: authorId,
          );
        } else {
          throw FirebaseException(
            plugin: '',
            code: 'document-not-found',
          );
        }
      },
    );
  }

  ///Use this method to retrieve the list of chats for user with [authorId] is involved in.
  ///Get list [limit] chats included in collection /chats
  ///and add the results to [list].
  ///To implement pagination, set [afterDocument] to get a list of [limit] chats
  ///after the document and insert them into [list].
  static Future<void> list({
    required ListChats list,
    required String authorId,
    required int limit,
    required bool refresh,
    DocumentSnapshot? afterDocument,
  }) async {
    // throw Exception('Not implemented');
    Query query = FirebaseFirestore.instance
        .collection(FirebaseFirestorePath.chats())
        .where('members_id', arrayContains: authorId)
        .orderBy('updatedAt', descending: true)
        .limit(limit);
    if (afterDocument != null) query = query.startAfterDocument(afterDocument);
    QuerySnapshot resultquery = await query.get();
    List<Chat> result = [];
    result.addAll(resultquery.docs
        .map(
          (doc) => Chat.fromDocumentSnapshot(
            doc: doc,
            authorId: authorId,
          ),
        )
        .toList());
    list.updateList(
      result,
      resultquery.docs.length == limit,
      resultquery.docs.isEmpty ? null : resultquery.docs.last,
      refresh,
    );
  }

  static Future<void> create({required Chat chat}) async {
    await chat.reference.set(chat.toMapInit);
  }

  static Future<void> update({
    required Chat chat,
    required Map<String, dynamic> data,
  }) async {
    await chat.reference.update(data);
  }

  static StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      listenToChatSubscription({
    required String uid,
    required void Function(QuerySnapshot<Object?>)? onData,
  }) {
    return FirebaseFirestore.instance
        .collection(FirebaseFirestorePath.chats())
        .where('members_id', arrayContains: uid)
        .orderBy('updatedAt', descending: true)
        .limit(3)
        .snapshots()
        .listen(onData);
  }

  static StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      listenToUnreadChatsSubscription({
    required String uid,
    required void Function(QuerySnapshot<Object?>)? onData,
  }) {
    return FirebaseFirestore.instance
        .collection(FirebaseFirestorePath.chats())
        .where('unread.$uid', isGreaterThanOrEqualTo: 1)
        .snapshots()
        .listen(onData);
  }

  static Future<int> getUnreadChats(String uid) {
    return FirebaseFirestore.instance
        .collection(FirebaseFirestorePath.chats())
        .where('unread.$uid', isGreaterThanOrEqualTo: 1)
        .count()
        .get()
        .then((value) => value.count ?? 0);
  }

  static Future<void> markAsSeen({
    required String authorId,
    required DocumentReference refrence,
  }) async {
    await refrence.update({
      'unread.$authorId': 0,
    });
  }
}
