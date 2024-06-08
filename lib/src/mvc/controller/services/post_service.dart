import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/models.dart';

class PostsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to create or update a post with coach's UID as document ID
  Future<void> createOrUpdatePost(Post post) async {
    try {
      await _firestore.collection('posts').doc(post.uid).set({
        'photoUrl': post.photoUrl,
        'createdAt': post.createdAt,
        'coachId': post.uid,
      });
    } catch (error) {
      print('Error creating or updating post: $error');
    }
  }

  // Method to fetch posts by coach's UID
  Future<List<Post>> getPostsByCoach(String uid) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('posts')
          .where('coachId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => Post.fromDocumentSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (error) {
      print('Error fetching posts: $error');
      return [];
    }
  }
}
