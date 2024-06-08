import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitafit/src/mvc/controller/add_program/add_proram_state.dart';

import '../../model/models/program_request.dart';

class OrderBloc extends Cubit<ProramState> {
  OrderBloc() : super(LoadingState());

  var uid = FirebaseAuth.instance.currentUser?.uid;

  ProgramRequest? programRequest;
  List<ProgramRequest> listorders = [];
  CollectionReference order =
      FirebaseFirestore.instance.collection('programRequests');
  String gender = "";
  int? age;
  int? height;
  int? weigh;
  String? activityLevel;
  String? workoutGoal;
  List<String>? medicalHistory;

  void creatorderProgram() async {
    emit(LodingprogramLoding());
    ProgramRequest model = ProgramRequest(
      uid: uid!,
      age: age ?? 20,
      height: height ?? 170,
      weight: weigh ?? 70,
      medicalHistory: medicalHistory ?? [''],
      activityLevel: activityLevel ?? "",
      workoutGoal: workoutGoal ?? "",
      gender: gender,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      reference: order.doc(),
      id: order.doc().id,
    );

    try {
      DocumentReference docRef = await order.add(model.toMap());

      await docRef.update({'id': docRef.id});
    } catch (e) {
      emit(ErrorProgram());
    }
  }
}
