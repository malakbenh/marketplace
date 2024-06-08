import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../controller/services.dart';
import '../list_models.dart';
import '../models.dart';

/// A class to manage messages for a user with [authorId] within a chat document
/// identified by [chatId], utilizing a hybrid approach for pagination:
///
/// - **Stream**: A stream subscription is used to listen to new changes in the
///   messages sub-collection in real-time.
///
/// - **Get**: The get query is responsible for retrieving data with pagination.
///
/// This class extends `ListFirestoreClasses` which includes all the logic for
/// get requests, pagination handling, and much more.
class ListMessages extends ListFirestoreClasses<Message> {
  final String authorId;
  final String chatId;

  /// Stream subscription created to listen to changes in the messages sub-collection in real-time.
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? streamSubscription;

  /// Returns true if the `streamSubscription` requires creation.
  bool get requireActivatingStream => streamSubscription == null;

  ListMessages({
    required this.authorId,
    required this.chatId,
    super.limit = 12,
  });

  /// Cancel and close the `streamSubscription`.
  void disableMessagesListener() {
    streamSubscription?.cancel().then(
          (_) => streamSubscription = null,
        );
  }

  /// Creates the `streamSubscription` and registers an event onData to handle
  /// changes in the messages sub-collection, and notify UI listeners to rebuild the chat/messages screen.
  ///
  /// Changes include:
  ///
  /// - `DocumentChangeType.added`: Indicates a new document was added to the
  ///   set of documents matching the query.
  /// - `DocumentChangeType.modified`: Indicates a document within the query was modified.
  /// - `DocumentChangeType.removed`: Indicates a document within the query was
  ///   removed (either deleted or no longer matches the query).
  void activateMessagesListener() {
    if (!requireActivatingStream) return;
    streamSubscription = MessagesService.listenToSubscription(
      chatId: chatId,
      onData: (event) {
        if (isNull) return;
        for (var docChange in event.docChanges) {
          if (docChange.type == DocumentChangeType.added ||
              docChange.type == DocumentChangeType.modified) {
            Message newMessage = Message.fromDocumentSnapshot(
              authorId: authorId,
              doc: docChange.doc,
            );
            int index =
                list.indexWhere((oldMessage) => oldMessage.id == newMessage.id);
            if (index == -1) {
              list.insert(0, newMessage);
            } else {
              list[index].updateFromMessage(newMessage);
            }
          } else {
            // Handle document deletion if necessary
          }
        }
        notifyListeners();
      },
    );
  }

  /// Get a list of messages for the chat with [chatId].
  ///
  /// - [get]: If set to `true`, the get request will be executed; otherwise, it won't.
  ///   This ensures that the get request is called only when the UI related
  ///   to the query is visible.
  ///
  /// - [refresh]: If set to `true`, refresh the data and replace existing chat
  ///   messages with new ones from the response.
  @override
  Future<void> get({
    bool get = true,
    bool refresh = false,
  }) async {
    if (super.isAwaiting(
        refresh: refresh, get: get, forceGet: false, isGetMore: false)) return;
    activateMessagesListener();
    isLoading = true;
    await MessagesService.list(
      list: this,
      authorId: authorId,
      chatId: chatId,
      limit: limit,
      refresh: refresh,
    );
  }

  /// Use to get more messages (pagination).
  @override
  Future<void> getMore({
    int? want,
  }) async {
    if (super.isAwaiting(
        refresh: false, get: true, forceGet: true, isGetMore: true)) return;
    isLoading = true;
    notifyListeners();
    await MessagesService.list(
      list: this,
      authorId: authorId,
      chatId: chatId,
      limit: want ?? limit,
      afterDocument: lastDoc,
      refresh: false,
    );
  }

  /// Update the list of messages with [resultList].
  @override
  void updateList(
    List<Message> resultList,
    bool resultHasMore,
    DocumentSnapshot? resultLastDoc,
    bool refresh,
  ) {
    if (refresh) {
      list.clear();
    }
    list.addAll(resultList);
    hasMore = resultHasMore;
    lastDoc = resultLastDoc;
    isNull = false;
    isLoading = false;
    notifyListeners();
  }

  /// Insert [element] into the list.
  @override
  void insert(Message element) {
    list.insert(0, element);
    notifyListeners();
  }

  /// Add [element] to the messages sub-collection and insert it into the list.
  @override
  Future<void> create(Message element) async {
    await element.create();
    insert(element);
  }

  /// Delete [element] from the messages sub-collection and remove it from the list.
  @override
  Future<void> delete(Message element) async {
    await element.delete();
    remove(element);
  }

  /// Reset this class to its initial state.
  @override
  void reset() {
    super.reset();
    disableMessagesListener();
  }

  @override
  Future<void> add(Message element) {
    throw UnimplementedError();
  }
}
