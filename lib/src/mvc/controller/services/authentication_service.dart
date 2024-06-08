import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../model/enums.dart';
import '../../model/firebase_firestore_path.dart';
import '../../model/models.dart';
import '../services.dart';

class AuthenticationService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  ///build a UserFirebaseSession object for current [user]
  static Future<UserSession> userFromFirebaseUser(
    User user, [
    int retry = 5,
  ]) async {
    try {
      late UserSession userdata;
      if (retry <= 0) {
        throw FirebaseAuthException(
          code: 'time-out',
          message:
              'Connection time out! Your user document is still being written',
        );
      }
      userdata = await _firestore
          .doc(FirebaseFirestorePath.userSession(uid: user.uid))
          .get(const GetOptions(source: Source.server))
          .then((doc) async {
        if (doc.data() == null || !doc.exists) {
          throw FirebaseAuthException(
            code: 'time-out-being-created',
            message:
                'Connection time out! Your user document is still being created',
          );
        }
        if (doc.data()!['uid'] != user.uid) {
          throw FirebaseAuthException(code: 'user-not-match');
        }
        if (doc.metadata.hasPendingWrites) {
          throw FirebaseAuthException(
            code: 'time-out-has-pending-writes',
            message:
                'Connection time out! Your user document is still being written',
          );
        }
        if (!doc.exists || doc.data() == null) {
          throw FirebaseAuthException(
            code: 'time-out-being-created',
            message:
                'Connection time out! Your user document is still being created',
          );
        }
        if (doc.data()!['uid'] != user.uid) {
          throw FirebaseAuthException(code: 'user-not-match');
        }
        return UserSession.fromFirebaseUserDoc(
          user: user,
          doc: doc,
        );
      });
      return userdata;
    } on FirebaseAuthException catch (e) {
      if (retry > 0 &&
          ['time-out-being-created', 'time-out-has-pending-writes']
              .contains(e.code)) {
        log('error:${e.code}');
        await Future.delayed(const Duration(milliseconds: 500));
        return userFromFirebaseUser(user, retry - 1);
      } else {
        rethrow;
      }
    } catch (e) {
      if (retry == 0) {
        rethrow;
      } else {
        await Future.delayed(const Duration(milliseconds: 500));
        return userFromFirebaseUser(user, retry - 1);
      }
    }
  }

  /// Update user email.
  static Future<void> updateUserEmail(String email) async {
    var firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return;
    await firebaseUser.verifyBeforeUpdateEmail(email);
  }

  /// Update user displayName.
  static Future<void> updateDisplayName(String displayName) async {
    var firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return;
    await firebaseUser.updateDisplayName(displayName);
  }

  static Future<void> changePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    var authCredentials = EmailAuthProvider.credential(
      email: email,
      password: oldPassword,
    );
    await FirebaseAuth.instance.currentUser
        ?.reauthenticateWithCredential(authCredentials);
    await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
  }

  /// On user signs in with credential, first update AuthState to `awaiting` to
  /// show the splash screen while user document is being created/updated, and
  /// retrieved from Firestore database.
  static Future<void> onSignInWithCredential({
    required UserCredential userCredential,
    required UserSession userSession,
    required String type,
  }) async {
    if (userCredential.user == null) throw Exception('User is not signed in');
    await onSignInUser(
      user: userCredential.user!,
      userSession: userSession,
      type: type,
    );

    if (!userCredential.user!.emailVerified) {
      userCredential.user!.sendEmailVerification();
    }
  }

  /// On user signs in, first update AuthState to `awaiting` to
  /// show the splash screen while user document is being created/updated, and
  /// retrieved from Firestore database.
  static Future<void> onSignInUser({
    required User user,
    required UserSession userSession,
    required String type,
  }) async {
    userSession.copyFromUserSession(UserSession.init(AuthState.awaiting));
    String? token = await _messaging.getToken();
    try {
      // on sign in
      await UserSessionService.updateToken(
        user.uid,
        token,
      );
    } catch (e) {
      // on register/account created
      UserSession userSession = UserSession.fromUser(
        user,
        token,
        type,
      );
      await UserSessionService.create(
        userSession,
      );
      // if userType == 'coach'
      // create coach doc in collection coaches
      if (type == 'coach') {
        await CoachService.create(
          // userSession.toCoach,
          Coach.fromUserSession(userSession),
        );
      }
    }
  }

  /// Send a verification email.
  static Future<void> sendEmailVerification() async {
    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
  }

  /// Tries to create a new user account with the given [email] address and [password].
  static Future<void> createUserWithEmailAndPassword({
    required UserSession userSession,
    required String email,
    required String password,
    required String type,
  }) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredential.user != null) {
      AuthenticationService.onSignInWithCredential(
        userCredential: userCredential,
        userSession: userSession,
        type: userSession.userType,
      );
    }
  }

  /// Attempts to sign in a user with the given [email] address and [password].
  static Future<void> signInWithEmailAndPassword({
    required UserSession userSession,
    required String email,
    required String password,
    required String type,
  }) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredential.user != null) {
      AuthenticationService.onSignInWithCredential(
        userCredential: userCredential,
        userSession: userSession,
        type: userSession.userType,
      );
    }
  }

  /// Sends a password reset email to the given [email] address.
  static Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  ///Signs out the current user.
  static Future<void> signOut(UserSession user) async {
    await FirebaseFirestore.instance.terminate();
    await FirebaseFirestore.instance.clearPersistence();
    await _auth.signOut();
  }

  static Future<void> deleteAccount({
    required UserSession userSession,
    required String oldPassword,
    required String why,
  }) async {
    AuthCredential authCredentials = EmailAuthProvider.credential(
      email: userSession.email!,
      password: oldPassword,
    );
    await FirebaseAuth.instance.currentUser
        ?.reauthenticateWithCredential(authCredentials);
    await FirebaseFirestore.instance
        .doc(FirebaseFirestorePath.deletedUserSession(uid: userSession.uid))
        .set(
      {
        ...userSession.toMapDelete,
        'why': why,
      },
    );
    await FirebaseAuth.instance.currentUser?.delete();
  }
}
