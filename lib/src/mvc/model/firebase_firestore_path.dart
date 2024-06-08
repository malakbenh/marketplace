class FirebaseFirestorePath {
  static String usersPresences() => 'usersPresence/';
  static String usersPresence({required String uid}) => 'usersPresence/$uid/';

  static String userSessions() => 'userSession/';
  static String userSession({required String uid}) => 'userSession/$uid';

  static String coaches({required String uid}) => 'coaches/';
  static String coach({required String uid}) => 'coaches/$uid';

  static String patients() => 'patients/';
  static String patient({required String id}) => 'patients/$id';

  static String medecines() => 'medecines/';
  static String medecine({required String id}) => 'medecines/$id';

  static String prescriptions() => 'prescriptions/';
  static String prescription({required String id}) => 'prescriptions/$id';

  static String analyses() => 'analyses/';
  static String analyse({required String id}) => 'analyses/$id';

  static String deletedUserSessions() => 'deletedUserSession/';
  static String deletedUserSession({required String uid}) =>
      'deletedUserSession/$uid';

  static String notifications({required String uid}) =>
      'userSession/$uid/notifications/';
  static String notification({required String uid, required String id}) =>
      'userSession/$uid/notifications/$id';

  static String feedbacks() => 'feedback/';
  static String feedback({required String id}) => 'feedback/$id';

  // Add posts within coaches
  static String coachPosts({required String uid}) => 'coaches/$uid/posts/';
  static String coachPost({required String uid, required String postId}) =>
      'coaches/$uid/posts/$postId';

  // Add products collection
  static String products() => 'products/';
  static String product({required String id}) => 'products/$id';

  static String users() => 'users/';
  static String user({required String uid}) => 'users/$uid';

  static String chats() => 'chats/';
  static String chat({required String id}) => 'chats/$id';

  static String messages({required String chatId}) => 'chats/$chatId/messages/';
  static String message({required String chatId, required String messageId}) =>
      'chats/$chatId/messages/$messageId';
  static String programRequests() => 'programRequests/';
  static String programRequest({required String id}) => 'programRequests/$id';
}
