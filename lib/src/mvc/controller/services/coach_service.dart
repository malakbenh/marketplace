import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/models.dart';
import '../../model/firebase_firestore_path.dart';
import '../../view/screens.dart';

class CoachService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> update(String uid, Map<String, dynamic> data) async {
    await _firestore.doc(FirebaseFirestorePath.coaches(uid: uid)).update(data);
  }

  static Future<void> create(Coach coach) async {
    await _firestore.doc(FirebaseFirestorePath.coach(uid: coach.uid)).set(
          coach.toMapCreate,
        );
  }

  static Future<Coach> get(String uid) async {
    final doc =
        await _firestore.doc(FirebaseFirestorePath.coach(uid: uid)).get();
    return Coach.fromDocument(doc);
  }

  static Future<List<CoachInformations>> getCoachesBySearch(
      String query) async {
    final QuerySnapshot<Map<String, dynamic>> result = await _firestore
        .collection('coaches')
        .where('firstName', isEqualTo: query)
        .get();

    return result.docs
        .map((doc) => CoachInformations(
              firstName: doc['firstName'],
              rate: doc['rate'],
              salary: doc['salary'],
              time: doc['time'],
              url: doc['url'],
            ))
        .toList();
  }
}
