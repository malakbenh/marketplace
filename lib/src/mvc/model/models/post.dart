import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String photoUrl;
  final DateTime createdAt;

  Post({
    required this.uid,
    required this.photoUrl,
    required this.createdAt,
  });

  factory Post.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return Post(
      uid: doc.id,
      photoUrl: doc.data()!['photoUrl'],
      createdAt: doc.data()!['createdAt'].toDate(),
    );
  }
}
