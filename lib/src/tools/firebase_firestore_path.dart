class FirebaseFirestorePath {
  static String users() => 'users/';
  static String user({required String uid}) => 'users/$uid';

  static String chats() => 'chats/';
  static String chat({required String id}) => 'chats/$id';

  static String messages({required String chatId}) => 'chats/$chatId/messages/';
  static String message({required String chatId, required String messageId}) =>
      'chats/$chatId/messages/$messageId';
}
