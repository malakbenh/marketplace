import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vitafit/src/mvc/model/models.dart';

import '../../../tools.dart';
import '../../controller/services.dart';
import '../../view/screens.dart';
import '../enums.dart';
import '../list_models.dart';

class UserSession with ChangeNotifier {
  /// user authentication sate
  AuthState authState;
  Exception? error;

  /// user Id
  String uid;
  String userType;
  String? phoneNumber; // Declare phoneNumber field
  String? email;
  bool? emailVerified;
  String? firstName;
  String? lastName;
  String? photoUrl;
  CachedNetworkImageProvider? photo;
  bool? isReviewedApp;
  DateTime? updatedAt;
  DateTime? createdAt;
  String? token; // Add this line
  final UserMin currentUser;
  ListChats listChats;

  UserSession({
    required this.authState,
    required this.error,
    required this.uid,
    required this.token, // Add this line
    required this.phoneNumber, // Add this line
    required this.email,
    required this.emailVerified,
    required this.firstName,
    required this.lastName,
    required this.photo,
    required this.photoUrl,
    required this.isReviewedApp,
    required this.updatedAt,
    required this.createdAt,
    required this.userType,
    required this.currentUser,
    required this.listChats,
  });

  ///Use as build an inital instance of `UserSession` while waiting for response from
  ///stream `AuthenticationService.userStream`
  factory UserSession.init(AuthState authState) => UserSession(
        authState: authState,
        error: null,
        uid: '',
        userType: '',
        phoneNumber: null,
        email: null,
        emailVerified: null,
        firstName: null,
        lastName: null,
        photo: null,
        photoUrl: null,
        isReviewedApp: null,
        updatedAt: null,
        createdAt: null,
        token: null, // Add this line
        currentUser: UserMin.init('', ''),
        listChats: ListChats.init(),
      );

  ///Call and use to catch [error] when listening to stream `AuthenticationService.userStream`
  factory UserSession.error(dynamic error) => UserSession(
        authState: AuthState.awaiting,
        error: error,
        uid: '',
        phoneNumber: null,
        email: null,
        userType: '',
        emailVerified: null,
        firstName: null,
        lastName: null,
        photo: null,
        photoUrl: null,
        isReviewedApp: null,
        updatedAt: null,
        createdAt: null,
        token: null, // Add this line
        currentUser: UserMin.init('', ''),
        listChats: ListChats.init(),
      );

  ///Call after user signup to build a instance of user `profile`, that will be
  ///pushed later by calling `toInitMap` method.
  factory UserSession.fromUserCredential(
    UserCredential userCredential,
    String? token,
    String type,
  ) =>
      UserSession.fromUser(userCredential.user!, token, type);

  ///Use to build an instance of `UserSession` from [user] and also using [token].
  factory UserSession.fromUser(
    User user,
    String? token,
    String type,
  ) =>
      UserSession(
        authState: AuthState.authenticated,
        error: null,
        uid: user.uid,
        phoneNumber: user.phoneNumber,
        email: user.email,
        emailVerified: user.emailVerified,
        userType: type,
        firstName: user.displayName,
        lastName: null,
        photo: user.photoURL.toImageProvider,
        photoUrl: user.photoURL,
        isReviewedApp: null,
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
        token: token, // Add this line
        currentUser: UserMin.init(user.displayName ?? '', user.photoURL ?? ''),
        listChats: ListChats(authorId: user.uid, onUpdateDate: null),
      );

  ///Use to build an instance of `UserSession` from [user] and [doc]
  factory UserSession.fromFirebaseUserDoc({
    required User user,
    required DocumentSnapshot<Map<String, dynamic>> doc,
  }) {
    Map<String, dynamic> json = doc.data()!;
    return UserSession(
      authState: AuthState.authenticated,
      error: null,
      token: json['token'],
      userType: json['userType'] ?? '',
      uid: user.uid,
      email: user.email ?? json['email'],
      emailVerified: user.emailVerified,
      firstName: json['firstName'] ?? user.displayName,
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      photo: (json['photoUrl'] as String?).toImageProvider,
      photoUrl: json['photoUrl'],
      isReviewedApp: json['isReviewedApp'] ?? false,
      createdAt: DateTimeUtils.getDateTimefromTimestamp(json['createdAt']),
      updatedAt: DateTimeUtils.getDateTimefromTimestamp(json['updatedAt']),
      currentUser: UserMin.init(user.displayName ?? '', user.photoURL ?? ''),
      listChats: ListChats(authorId: user.uid, onUpdateDate: null),
    );
  }

  ///Used only after user signup to create profile based on user credentials.
  ///`UserData.fromUserCredential` constructor is used to init UserData model
  ///after signup, then we use `toInitMap` to build a `document` in collection
  ///`userData` that needs to be pushed along side additional somedata
  Map<String, dynamic> get toMapCreate => {
        'uid': uid,
        'email': email,
        'phoneNumber': phoneNumber,
        'firstName': firstName,
        'userType': userType,
        'lastName': lastName,
        'photoUrl': photoUrl,
        'isReviewedApp': isReviewedApp,
        //initial params in userData document
        'updateKey': 0,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      };

  Map<String, dynamic> get toMapCreateUserMin => {
        'uid': uid,
        'email': email,
        'firstName': firstName,
        'userType': userType,
        'lastName': lastName,
        'photoUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      };

  Map<String, dynamic> get toMapUpdate => {
        'email': email,
        'phoneNumber': phoneNumber,
        'firstName': firstName,
        'userType': userType,
        'lastName': lastName,
        'photoUrl': photoUrl,
        'isReviewedApp': isReviewedApp,
        'updatedAt': FieldValue.serverTimestamp(),
      };

  Map<String, dynamic> get toMapDelete => {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'userType': userType,
        'photoUrl': photoUrl,
        'isReviewedApp': isReviewedApp,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': Timestamp.fromDate(createdAt!),
      };

  bool get isReady => authState != AuthState.awaiting;
  bool get isAwaiting => authState == AuthState.awaiting;
  bool get isAuthenticated => authState == AuthState.authenticated;
  bool get isUnauthenticated => authState == AuthState.unauthenticated;

  bool get isProfileComplete =>
      firstName.isNotNullOrEmpty && lastName.isNotNullOrEmpty;

  bool get isProfileNotComplete =>
      firstName.isNullOrEmpty || lastName.isNullOrEmpty;

  String? get displayname =>
      lastName.isNullOrEmpty ? firstName : '${firstName ?? ''} ${lastName!}';

  void updateException(Exception? exception) {
    error = exception;
    notifyListeners();
  }

  void copyFromUserSession(UserSession update) {
    authState = update.authState;
    error = update.error;
    uid = update.uid;
    phoneNumber = update.phoneNumber;
    email = update.email;
    emailVerified = update.emailVerified;
    firstName = update.firstName;
    lastName = update.lastName;
    userType = update.userType;
    photo = update.photo;
    photoUrl = update.photoUrl;
    isReviewedApp = update.isReviewedApp;
    updatedAt = update.updatedAt;
    createdAt = update.createdAt;
    listChats.reset();
    listChats = update.listChats;
    notifyListeners();
  }

  Future<void> listenAuthStateChanges() async {
    FirebaseAuth.instance.authStateChanges().listen(
      (user) async {
        if (user == null) {
          // user is not connected
          copyFromUserSession(
            UserSession.init(AuthState.unauthenticated),
          );
        } else {
          // user is connected
          try {
            UserSession userdata =
                await AuthenticationService.userFromFirebaseUser(user);
            copyFromUserSession(userdata);
          } on Exception catch (e) {
            updateException(e);
          }
        }
      },
    );
  }

  Future<void> signOut() async {
    await AuthenticationService.signOut(this);
  }

  Future<void> refreshisEmailVerified() async {
    if (FirebaseAuth.instance.currentUser == null) return;
    await FirebaseAuth.instance.currentUser!.reload();
    emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (emailVerified == true) {
      notifyListeners();
    }
  }

  Future<void> updateIsReviewed() async {
    isReviewedApp = true;
    await UserSessionService.update(
      uid,
      toMapUpdate,
    );
  }

  Future<void> completeProfile({
    String? photoPath,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? userType,
  }) async {
    if (photoPath.isNotNullOrEmpty) {
      photoUrl = await ModernPicker.uploadImageFile(
        photoPath: photoPath!,
        root: FirebaseStoragePath.profileImages,
        fileName: uid,
      );
      photo = CachedNetworkImageProvider(photoUrl!);
    }

    if (firstName != null) {
      this.firstName = firstName;
    }
    if (lastName != null) {
      this.lastName = lastName;
    }
    if (phoneNumber != null) {
      this.phoneNumber = phoneNumber;
    }

    await UserSessionService.update(
      uid,
      toMapUpdate,
    );
    notifyListeners();
  }

  // void openProfileComplete(BuildContext context) => context.push(
  //       widget: ProfileComplete(userSession: this),
  //     );

  void openProfileInformation(BuildContext context) => context.push(
        widget: ProfileInformation(userSession: this),
      );

  void openProfileSignature(BuildContext context) => context.push(
        widget: ProfileSignature(userSession: this),
      );

  void openProfile(BuildContext context) {}

  Coach get toCoach => Coach(
        uid: uid,
        token: token,
        email: email,
        firstName: firstName,
        lastName: lastName,
        photo: photo,
        photoUrl: photoUrl,
        updatedAt: updatedAt,
        createdAt: createdAt,
      );

  void fetchUserData() {}
}
