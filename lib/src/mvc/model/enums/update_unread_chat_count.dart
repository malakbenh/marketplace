/// What to use to update the count of unread chats
enum UpdateUnreadChatCount {
  /// Use stream subscription firebase's snapshot.listen
  stream,

  ///Use simple one time query firebase's get. Perform a get request every time a change is detected in the chat subscription.
  get,
}
