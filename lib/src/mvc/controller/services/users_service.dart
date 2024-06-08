import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/firebase_firestore_path.dart';
import '../../model/list_models/list_users.dart';
import '../../model/models.dart';

class UsersService {
  static DocumentReference newReference(String chatId) =>
      FirebaseFirestore.instance
          .collection(FirebaseFirestorePath.users())
          .doc();

  static Future<void> create({
    required UserMin user,
  }) async {
    await user.reference.set(user.toMapInit);
  }

  ///Use this method to get all users.
  static Future<void> list({
    required ListUsers list,
    required int limit,
    required bool refresh,
    DocumentSnapshot? afterDocument,
  }) async {
    Query query = FirebaseFirestore.instance
        .collection(FirebaseFirestorePath.users())
        .orderBy('name')
        .limit(limit);
    if (afterDocument != null) query = query.startAfterDocument(afterDocument);
    QuerySnapshot resultquery = await query.get();
    List<UserMin> result = [];
    result.addAll(resultquery.docs.map(UserMin.fromDocumentSnapshot).toList());
    list.updateList(
      result,
      resultquery.docs.length == limit,
      resultquery.docs.isEmpty ? null : resultquery.docs.last,
      refresh,
    );
  }
}
