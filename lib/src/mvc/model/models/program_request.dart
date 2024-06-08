import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../tools.dart';
import '../../controller/services.dart';
import '../../controller/services/program_request_service.dart';
import '../models.dart';

class ProgramRequest extends FirebaseModel {
  final String gender;
  final int age;
  final int height;
  final int weight;
  final String activityLevel;
  final String workoutGoal;
  final List<String> medicalHistory;
  final String uid;

  ProgramRequest({
    required super.id,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.activityLevel,
    required this.workoutGoal,
    required this.medicalHistory,
    required this.uid,
    required super.createdAt,
    required super.updatedAt,
    required super.reference,
  });

  factory ProgramRequest.init({
    required UserSession userSession,
    required String gender,
    required int age,
    required int height,
    required int weight,
    required String activityLevel,
    required String workoutGoal,
    required List<String> medicalHistory,
  }) {
    DocumentReference reference = ProgramRequestService().docReference;
    return ProgramRequest(
      id: reference.id,
      gender: gender,
      age: age,
      height: height,
      weight: weight,
      activityLevel: activityLevel,
      workoutGoal: workoutGoal,
      medicalHistory: medicalHistory,
      uid: userSession.uid,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      reference: reference,
    );
  }

  factory ProgramRequest.fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) =>
      ProgramRequest(
        id: doc.id,
        gender: doc.data()!['gender'],
        age: doc.data()!['age'],
        height: doc.data()!['height'],
        weight: doc.data()!['weight'],
        activityLevel: doc.data()!['activityLevel'],
        workoutGoal: doc.data()!['workoutGoal'],
        medicalHistory: List<String>.from(doc.data()!['medicalHistory']),
        uid: doc.data()!['uid'],
        createdAt:
            DateTimeUtils.getDateTimefromTimestamp(doc.data()!['createdAt'])!,
        updatedAt:
            DateTimeUtils.getDateTimefromTimestamp(doc.data()!['updatedAt'])!,
        reference: doc.reference,
      );

  @override
  Map<String, dynamic> get toMapCreate => {
        'id': id,
        'gender': gender,
        'age': age,
        'height': height,
        'weight': weight,
        'activityLevel': activityLevel,
        'workoutGoal': workoutGoal,
        'medicalHistory': medicalHistory,
        'uid': uid,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

  @override
  Map<String, dynamic> get toMapUpdate => {
        'gender': gender,
        'age': age,
        'height': height,
        'weight': weight,
        'activityLevel': activityLevel,
        'workoutGoal': workoutGoal,
        'medicalHistory': medicalHistory,
        'updatedAt': FieldValue.serverTimestamp(),
      };
  Map<String, dynamic> toMap() {
    return {
      'gender': gender,
      'age': age,
      'height': height,
      'weight': weight,
      'activityLevel': activityLevel,
      'workoutGoal': workoutGoal,
      'medicalHistory': medicalHistory,
      // Add other properties as needed
    };
  }

  @override
  Future<void> update() async {
    await ProgramRequestService().update(this);
    notifyListeners();
  }

  @override
  Future<void> create() async {
    await ProgramRequestService().create(this);
  }

  @override
  Future<void> delete() async {
    await ProgramRequestService().delete(this);
  }
}
