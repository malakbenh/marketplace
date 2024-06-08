import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/firebase_firestore_path.dart';
import '../../model/list_models.dart';
import '../../model/models.dart';
import '../../model/models/program_request.dart';
import '../services.dart';

class ProgramRequestService extends FirestoreService<ProgramRequest> {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  DocumentReference get docReference =>
      _firestore.collection(FirebaseFirestorePath.programRequests()).doc();

  @override
  Future<void> update(ProgramRequest element) async {
    await element.reference?.update(element.toMapUpdate);
  }

  @override
  Future<void> create(ProgramRequest element) async {
    await element.reference?.set(element.toMapCreate);
  }

  @override
  Future<void> delete(ProgramRequest element) async {
    await element.reference?.delete();
  }

  @override
  Future<void> getList({
    required ListFirestoreClasses<ProgramRequest> list,
    required int limit,
    required bool refresh,
  }) async {
    Query query = _firestore
        .collection(FirebaseFirestorePath.programRequests())
        .where('uid')
        .orderBy('createdAt', descending: true)
        .limit(limit);
    if (!refresh && list.lastDoc != null) {
      query = query.startAfterDocument(list.lastDoc!);
    }
    QuerySnapshot resultquery = await query.get();
    List<ProgramRequest> result = [];
    result.addAll(resultquery.docs
        .map(
          (doc) => ProgramRequest.fromDocumentSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>),
        )
        .toList());
    list.updateList(
      result,
      resultquery.docs.length == limit,
      resultquery.docs.isEmpty ? null : resultquery.docs.last,
      refresh,
    );
  }

  Future<void> saveUserInfo(ProgramRequest userInfo) async {
    await _firestore
        .collection(FirebaseFirestorePath.programRequests())
        .add(userInfo.toMap());
  }
}
