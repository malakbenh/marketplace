import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../model/models/user_min.dart';
import '../../../../model_widgets/coach_widget.dart';
import '../../../../screens.dart';

class HomeClient extends StatelessWidget {
  const HomeClient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff35A072),
        centerTitle: true,
        title: const Column(
          children: [],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(SearchScreen.pageRoute);
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(context, 'Top Coaches'),
              const SizedBox(height: 12),
              _buildSection(context, 'Popular Coaches'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String sectionTitle) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              sectionTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                  ViewAll.pageRaute,
                  arguments: Argees(firstName: sectionTitle),
                );
              },
              child: const Text(
                'View All',
                style: TextStyle(
                  color: Color(0xff35A072),
                ),
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[350],
          ),
          height: 300,
          width: double.infinity,
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('coaches').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No coaches available.'));
              }
              var coachDocs = snapshot.data!.docs;
              return ListView.builder(
                itemCount: coachDocs.length,
                itemBuilder: (context, index) {
                  var coachData =
                      coachDocs[index].data() as Map<String, dynamic>;
                  var coachInfo = CoachInformations(
                    firstName: coachData['firstName'] ?? 'Unknown',
                    rate: coachData['rate'] ?? '0',
                    salary: coachData['salary'] ?? 'N/A',
                    time: coachData['time'] ?? 'N/A',
                    url: coachData['photoUrl'] ??
                        'https://via.placeholder.com/150',
                  );
                  return CoachWidget(
                    coachInfo: coachInfo,
                    currentUser: UserMin(
                      uid: 'uid',
                      name: 'name',
                      photoUrl: 'photoUrl',
                      photo: const CachedNetworkImageProvider('photoUrl'),
                      reference: FirebaseFirestore.instance
                          .collection('users')
                          .doc('id'),
                      listChats: null,
                    ),
                  ); // Add currentUser here
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class Argees {
  Argees({required this.firstName, this.coaches});
  String firstName;
  List<CoachInformations>? coaches;
}

class CoachInformations {
  CoachInformations({
    required this.firstName,
    required this.rate,
    required this.salary,
    required this.time,
    required this.url,
  });

  String firstName;
  String url;
  String salary;
  String time;
  String rate;
}
