import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class FirebaseModel with ChangeNotifier {
  String? id;
  DateTime? createdAt;
  final DateTime? updatedAt;
  final DocumentReference? reference;

  FirebaseModel({this.id,
  this.createdAt,
  this.updatedAt,
  this.reference,
  });

  Map<String, dynamic> get toMapCreate;

  Map<String, dynamic> get toMapUpdate;

  Future<void> create();

  Future<void> update();

  Future<void> delete();
}
