import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../controller/services.dart';
import '../list_models.dart';
import '../models.dart';

/// A class to manage chats for user with [authorId] with pagination using a hybrid approach:
///
/// - Stream: a stream subscription is used to listen to new changes in the chat in real-time.
///
/// - Get: The get query is responsable for retrieving data with pagination.
///
/// This class is extended from class `ListFirestoreClasses` which includes all the logic for the get requests and pagination handeling, and much more.
class ListChats extends ListFirestoreClasses<Chat> {
  final String authorId;
  final Future<void> Function()? onUpdateDate;

  /// Stream subscription created to listen to changes in the user chat in real-time.
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? streamSubscription;

  /// Returns true if the `streamSubscription` require creation.
  bool get requireActivatingStream => streamSubscription == null;

  factory ListChats.init() => ListChats(
        authorId: '',
        onUpdateDate: null,
      );

  ListChats({
    required this.authorId,
    required this.onUpdateDate,
    super.limit = 12,
  });

  /// Cancel and close the `streamSubscription`.
  void disableMessagesListener() {
    streamSubscription?.cancel().then(
          (_) => streamSubscription = null,
        );
  }

  /// Creates the `streamSubscription` and registers an event onData to handle
  /// changes in the chat collection, and notify UI listeners to rebuild the chat page.
  ///
  /// Changes include:
  ///
  /// - `DocumentChangeType.added`: Indicates a new document was added to the
  /// set of documents matching the query.
  /// - `DocumentChangeType.modified`: Indicates a document within the query was modified.
  /// - `DocumentChangeType.removed`: Indicates a document within the query was
  /// removed (either deleted or no longer matches the query.
  void activateMessagesListener() {
    if (!requireActivatingStream) return;
    streamSubscription = ChatsService.listenToChatSubscription(
      uid: authorId,
      onData: (event) {
        if (isNull) return;
        if (onUpdateDate != null) {
          onUpdateDate!();
        }
        for (var docChange in event.docChanges) {
          // log('docId:${docChange.doc.id} -> ${docChange.type.toString()}');
          if (docChange.type == DocumentChangeType.added ||
              docChange.type == DocumentChangeType.modified) {
            Chat newChat = Chat.fromDocumentSnapshot(
              authorId: authorId,
              doc: docChange.doc,
            );
            int index = list.indexWhere((oldChat) => oldChat.id == newChat.id);
            if (index >= 0) {
              list[index].updateWithChat(newChat);
              newChat = list.removeAt(index);
            }
            list.insert(0, newChat);
          } else {
            //if deleted
          }
        }
        notifyListeners();
      },
    );
  }

  /// Get list of chats for user with [authorId].
  ///
  /// - get: if set `true` the get request will be executed, else it won't. This
  /// is used to ensure that the get request is called only when the UI related
  /// to the query is visible, due to Flutter's mechanism and how it work,
  /// sometimes it might trigger the query to be called while the UI is not visible.
  ///
  /// - refresh: if set to `true` refresh the data and replace existing chat with new ones in the response,
  @override
  Future<void> get({
    bool get = true,
    bool refresh = false,
  }) async {
    if (super.isAwaiting(
        refresh: refresh, get: get, forceGet: false, isGetMore: false)) return;
    activateMessagesListener();
    isLoading = true;
    await ChatsService.list(
      list: this,
      authorId: authorId,
      limit: limit,
      refresh: refresh,
    );
  }

  /// Use to get more chats (Pagination).
  @override
  Future<void> getMore({
    int? want,
  }) async {
    if (super.isAwaiting(
        refresh: false, get: true, forceGet: true, isGetMore: true)) return;
    isLoading = true;
    notifyListeners();
    await ChatsService.list(
      list: this,
      authorId: authorId,
      limit: want ?? limit,
      afterDocument: lastDoc,
      refresh: false,
    );
  }

  /// Update list of chats with [resultList].
  @override
  void updateList(
    List<Chat> resultList,
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

  /// Insert [element] into `list`.
  @override
  void insert(Chat element) {
    list.insert(0, element);
    notifyListeners();
  }

  /// Add [element] to chat collection and insert it to `list`.
  Future<void> add(Chat element) async {
    await element.create();
    insert(element);
  }

  /// Delete [element] from chat collection and remove it from `list`.
  @override
  Future<void> delete(Chat element) async {
    await element.delete();
    remove(element);
  }

  @override
  Future<void> create(Chat element) async {
    await element.create();
    insert(element);
  }

  /// Reset this class to its initial state.
  @override
  void reset() {
    super.reset();
    for (var chat in list) {
      chat.listMessages.reset();
    }
    disableMessagesListener();
  }
}
