import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../tools.dart';
import '../../controller/services.dart';
import '../models.dart';

class Coach with ChangeNotifier {
  String uid;
  String? email;
  String? firstName;
  String? lastName;
  String? birthDate;
  String? photoUrl;
  CachedNetworkImageProvider? photo;
  DateTime? updatedAt;
  DateTime? createdAt;

  Coach({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.photo,
    required this.photoUrl,
    required this.updatedAt,
    required this.createdAt,
    String? token,
  });
  factory Coach.fromUserSession(UserSession userSession) => Coach(
        uid: userSession.uid,
        email: userSession.email,
        firstName: userSession.firstName,
        lastName: userSession.lastName,
        photo: userSession.photo,
        photoUrl: userSession.photoUrl,
        updatedAt: userSession.updatedAt,
        createdAt: userSession.createdAt,
      );

  factory Coach.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> json = doc.data()!;
    return Coach(
      uid: doc.id,
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      photo: (json['photoUrl'] as String?).toImageProvider,
      photoUrl: json['photoUrl'],
      createdAt: DateTimeUtils.getDateTimefromTimestamp(json['createdAt']),
      updatedAt: DateTimeUtils.getDateTimefromTimestamp(json['updatedAt']),
    );
  }

  ///Used only after user signup to create profile based on user credentials.
  ///`UserData.fromUserCredential` constructor is used to init UserData model
  ///after signup, then we use `toInitMap` to build a `document` in collection
  ///`userData` that needs to be pushed along side additional somedata
  Map<String, dynamic> get toMapCreate => {
        'uid': uid,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'birthDate': birthDate,
        'photoUrl': photoUrl,
        //initial params in userData document
        'updateKey': 0,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      };

  Map<String, dynamic> get toMapUpdate => {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'birthDate': birthDate,
        'photoUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      };

  bool get isProfileComplete =>
      firstName.isNotNullOrEmpty && lastName.isNotNullOrEmpty;

  bool get isProfileNotComplete =>
      firstName.isNullOrEmpty || lastName.isNullOrEmpty;

  String? get displayname =>
      lastName.isNullOrEmpty ? firstName : '${firstName ?? ''} ${lastName!}';

  Future<void> completeProfile({
    String? photoPath,
    String? firstName,
    String? lastName,
    String? birthDate,
    String? adeli,
    File? signitureFile,
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
    if (birthDate != null) {
      this.birthDate = birthDate;
    }
    await UserSessionService.update(
      uid,
      toMapUpdate,
    );
    notifyListeners();
  }
}
