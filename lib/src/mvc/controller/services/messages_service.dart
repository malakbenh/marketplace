import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../tools.dart';
import '../../model/firebase_firestore_path.dart';
import '../../model/list_models/list_messages.dart';
import '../../model/models.dart';

class MessagesService {
  static DocumentReference newReference(String chatId) =>
      FirebaseFirestore.instance
          .collection(FirebaseFirestorePath.messages(chatId: chatId))
          .doc();

  static Future<void> create({
    required Message message,
  }) async {
    if (message.isImage) {
      message.photoUrl = await ModernPicker.uploadImage(
        photoPath: message.photoUrl!,
        root: FirebaseStoragePath.chatImages,
        fileName: message.id,
        compress: true,
      );
    }
    await message.reference.set(message.toMapInit);
  }

  ///Use this method to get messages exchanged in a chat between two users.
  ///Get list [limit] messages included in subcollection /chats/[chatId]/messages,
  ///and add the results to [list].
  ///To implement pagination, set [afterDocument] to get a list of [limit] messages
  ///after the document and insert them into [list].
  static Future<void> list({
    required ListMessages list,
    required String authorId,
    required String chatId,
    required int limit,
    required bool refresh,
    DocumentSnapshot? afterDocument,
  }) async {
    Query query = FirebaseFirestore.instance
        .collection(FirebaseFirestorePath.messages(chatId: chatId))
        .orderBy('createdAt', descending: true)
        .limit(limit);
    if (afterDocument != null) query = query.startAfterDocument(afterDocument);
    QuerySnapshot resultquery = await query.get();
    List<Message> result = [];
    result.addAll(resultquery.docs
        .map(
          (doc) => Message.fromDocumentSnapshot(
            authorId: authorId,
            doc: doc,
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

  static Future<void> markAsSeen(DocumentReference reference) async {
    await reference.update({
      'isSeen': true,
    });
  }

  static StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      listenToSubscription({
    required String chatId,
    required void Function(QuerySnapshot<Object?>)? onData,
  }) {
    return FirebaseFirestore.instance
        .collection(FirebaseFirestorePath.messages(chatId: chatId))
        .orderBy('createdAt', descending: true)
        .limit(3)
        .snapshots()
        .listen(onData);
  }
}
