import '../../controller/services.dart';
import '../enums.dart';
import '../models.dart';
import 'list_firestore_classes.dart';

class ListUsers extends ListFirestoreClasses<UserMin> {
  static const UpdateUnreadChatCount update = UpdateUnreadChatCount.get;

  ListUsers({super.limit = 10});

  @override
  Future<void> get({
    bool get = true,
    bool refresh = false,
  }) async {
    if (super.isAwaiting(
        refresh: refresh, get: get, forceGet: false, isGetMore: false)) return;
    isLoading = true;
    await UsersService.list(
      list: this,
      limit: limit,
      refresh: refresh,
    );
  }

  @override
  Future<void> getMore({
    int? want,
  }) async {
    if (super.isAwaiting(
        refresh: false, get: true, forceGet: true, isGetMore: true)) return;
    isLoading = true;
    notifyListeners();
    await UsersService.list(
      list: this,
      limit: want ?? limit,
      afterDocument: lastDoc,
      refresh: false,
    );
  }

  @override
  Future<void> add(UserMin element) async {
    await element.create();
    insert(element);
  }

  @override
  Future<void> delete(UserMin element) async {
    await element.delete();
    remove(element);
  }

  @override
  Future<void> create(UserMin element) async {
    await element.create();
  }

  static List<UserMin> exampleListUsers = <UserMin>[
    UserMin.init(
      'Toto Wolf',
      'https://firebasestorage.googleapis.com/v0/b/optasoft-chat-app.appspot.com/o/users%2F1-intro-photo-final.jpg?alt=media&token=369da18e-1acb-458a-891b-dbe6a6cb43d2',
    ),
    UserMin.init(
      'Fernando Alonso',
      'https://firebasestorage.googleapis.com/v0/b/optasoft-chat-app.appspot.com/o/users%2F360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg?alt=media&token=8d8c4a2a-1f8a-4a49-9943-6a6dfb996afd',
    ),
    UserMin.init(
      'Alexa Apple',
      'https://firebasestorage.googleapis.com/v0/b/optasoft-chat-app.appspot.com/o/users%2FPerfocal_17-11-2019_TYWFAQ_100_standard-3.jpg?alt=media&token=807de4bc-73c8-4b38-a705-8361b4e13ea0',
    ),
    UserMin.init(
      'Thomas White',
      'https://firebasestorage.googleapis.com/v0/b/optasoft-chat-app.appspot.com/o/users%2Fportrait-white-man-isolated_53876-40306.jpg.avif?alt=media&token=2efb6a8e-1d93-43de-a890-228dbda75fe0',
    ),
    UserMin.init(
      'Alex Albon',
      'https://firebasestorage.googleapis.com/v0/b/optasoft-chat-app.appspot.com/o/users%2Fprofile-picture.jpeg?alt=media&token=2ab33b21-24f2-44d3-9770-c478e3e06ceb',
    ),
  ];

  static Future<void> populateUsersCollectionWithExamples() async {
    for (var user in exampleListUsers) {
      await user.create();
    }
  }
}
