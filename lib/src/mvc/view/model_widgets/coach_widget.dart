import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vitafit/src/mvc/view/screens.dart';

import '../../model/models/user_min.dart';

class CoachWidget extends StatelessWidget {
  final CoachInformations coachInfo;
  final UserMin currentUser;

  const CoachWidget({
    Key? key,
    required this.coachInfo,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: ClipOval(
          child: CachedNetworkImage(
            imageUrl: coachInfo.url,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        title: Text(
          coachInfo.firstName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rate: ${coachInfo.rate}', style: const TextStyle(fontSize: 16)),
            Text('Salary: ${coachInfo.salary}', style: const TextStyle(fontSize: 16)),
            Text('Time: ${coachInfo.time}', style: const TextStyle(fontSize: 16)),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Profile(
              firstName: coachInfo.firstName,
              photoUrl: coachInfo.url,
              currentUser: currentUser,
            ),
          ));
        },
      ),
    );
  }
}
