//import 'package:coach/home.dart';
//import 'package:coach/widget/coach_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vitafit/src/mvc/model/models/user_min.dart';
import 'package:vitafit/src/mvc/view/screens.dart';

import '../../../model_widgets/coach_widget.dart';

class ViewAll extends StatelessWidget {
  const ViewAll({Key? key}) : super(key: key);
  static const String pageRaute = 'viewAll';

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)?.settings.arguments as List<CoachInformations>;
    return Scaffold(
      appBar: AppBar(
        title: Text('top popular'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          var coachInfo = CoachInformations(
            firstName: args[index].firstName,
            rate: args[index].rate ?? '0',
            salary: args[index].salary ?? 'N/A',
            time: args[index].time ?? 'N/A',
            url: args[index].url ?? 'https://via.placeholder.com/150',
          );

          return CoachWidget(
            coachInfo: coachInfo,
            currentUser: UserMin(
              uid: 'uid',
              name: 'name',
              photoUrl: 'photoUrl',
              photo: const CachedNetworkImageProvider('photoUrl'),
              reference:
                  FirebaseFirestore.instance.collection('users').doc('id'),
              listChats: null,
            ),
          );
        },
        itemCount: args.length,
      ),
    );
  }
}
