import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../tools.dart';
import '../../controller/services.dart';
import '../models.dart';

class Message with ChangeNotifier {
  /// Message id
  final String id;

  /// Author id
  final String authorId;

  /// Text message
  final String? message;

  /// Photo url for image message
  String? photoUrl;

  /// Photo
  final ImageProvider<Object>? photo;

  /// Aspect ratio of the image
  final double? aspectRatio;

  /// `true` if the message was sent by current user, user with `authorId`.
  final bool isMine;

  /// if the message was seen by the destination user.
  bool _isSeen;

  /// if the message is being sent.
  bool isSending;

  /// if there was an error sending the message.
  bool hasError;

  /// Timestamp of creation.
  final DateTime createdAt;

  /// Timestamp of update.
  final DateTime updatedAt;

  /// Message document reference to Firestore database.
  final DocumentReference reference;

  /// primary color of chat buble.
  final Color primaryColor;

  Message({
    required this.id,
    required this.authorId,
    required this.message,
    required this.photo,
    required this.photoUrl,
    required this.aspectRatio,
    required this.isMine,
    bool isSeen = false,
    this.isSending = false,
    this.hasError = false,
    required this.createdAt,
    required this.updatedAt,
    required this.reference,
    required this.primaryColor,
  }) : _isSeen = isSeen;

  factory Message.fromDocumentSnapshot({
    required String authorId,
    required DocumentSnapshot doc,
  }) {
    final json = doc.data()! as Map<String, dynamic>;
    var isMine = json['authorId'] == authorId;
    return Message(
      id: doc.id,
      authorId: json['authorId'],
      message: json['message'],
      photo: (json['photoUrl'] as String?).toImageProvider,
      photoUrl: json['photoUrl'],
      aspectRatio: json['aspectRatio'],
      isSeen: json['isSeen'] ?? true,
      isMine: isMine,
      updatedAt: DateTimeUtils.getDateTimefromTimestamp(json['updatedAt'])!,
      createdAt: DateTimeUtils.getDateTimefromTimestamp(json['createdAt'])!,
      reference: doc.reference,
      primaryColor: isMine ? Colors.white : Colors.black,
    );
  }

  factory Message.toTextMessage({
    required Chat chat,
    required String message,
  }) {
    DocumentReference reference = MessagesService.newReference(chat.id);
    return Message(
      id: reference.id,
      authorId: chat.author.uid,
      message: message,
      photo: null,
      photoUrl: null,
      aspectRatio: null,
      isMine: true,
      isSending: true,
      isSeen: false,
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
      reference: reference,
      primaryColor: Colors.white,
    );
  }

  factory Message.toImageMessage({
    required Chat chat,
    required String photoPath,
    required double imageAspectRatio,
  }) {
    DocumentReference reference = MessagesService.newReference(chat.id);
    return Message(
      id: reference.id,
      authorId: chat.author.uid,
      message: null,
      photo: Image.file(File(photoPath)).image,
      photoUrl: photoPath,
      aspectRatio: imageAspectRatio,
      isMine: true,
      isSeen: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      reference: reference,
      primaryColor: Colors.white,
    );
  }

  bool get isText => message != null;

  bool get isImage => message == null && photo != null;

  Map<String, dynamic> get toMapInit => {
        'authorId': authorId,
        'isSeen': false,
        if (isText) 'message': message,
        if (isImage) ...{
          'photoUrl': photoUrl,
          'aspectRatio': aspectRatio,
        },
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'updateKey': 0,
      };

  Map<String, dynamic> get toMapChatUpdate {
    Map<String, dynamic> data = {
      'authorId': authorId,
      'lastMessage': null,
      'isImage': false,
    };
    if (isText) {
      data.update('lastMessage', (value) => message);
      return data;
    }
    if (isImage) {
      data.update('lastMessage', (value) => 'Sent you an image');
      data.update('isImage', (value) => true);
      return data;
    }
    throw Exception('isText || isImage is not true.');
  }

  Future<void> create() async {
    await MessagesService.create(message: this);
  }

  Future<void> delete() async {
    await reference.delete();
  }

  Future<void> markAsSeen() async {
    _isSeen = true;
    notifyListeners();
    await MessagesService.markAsSeen(reference);
  }

  void updateFromMessage(Message message) {
    isSending = message.isSending;
    _isSeen = message.isSeen;
    notifyListeners();
  }

  void updateHasError() {
    hasError = true;
    notifyListeners();
  }

  bool get isSeen => isMine && _isSeen;

  bool get isNotSeen => !isMine && !_isSeen;
}
