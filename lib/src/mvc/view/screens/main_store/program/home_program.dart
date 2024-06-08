import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../model/models/user_min.dart';
import '../../../model_widgets/coach_widget.dart';
import '../../../screens.dart';

class HomeProgram extends StatelessWidget {
  final UserMin currentUser;

  HomeProgram({Key? key, required this.currentUser}) : super(key: key);
  List<CoachInformations> coachsInfo = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff35A072),
        centerTitle: true,
        title: const Column(
          children: [
            Text(
              'Find your desired',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(
              'Coach Right Now!',
              style: TextStyle(color: Colors.white),
            ),
          ],
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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Top Coaches',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: Color(0xff35A072),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        ViewAll.pageRaute,
                        arguments: coachsInfo,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            sliver: _buildCoachList(context, 'Top Coaches'),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Popular Coaches',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            sliver: _buildCoachList(context, 'Popular Coaches'),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachList(BuildContext context, String sectionTitle) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('coaches').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(child: Text('No coaches available.')),
          );
        }
        var coachDocs = snapshot.data!.docs;
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              var coachData = coachDocs[index].data() as Map<String, dynamic>;
              var coachInfo = CoachInformations(
                firstName: coachData['firstName'] ?? 'Unknown',
                rate: coachData['rate'] ?? '0',
                salary: coachData['salary'] ?? 'N/A',
                time: coachData['time'] ?? 'N/A',
                url: coachData['photoUrl'] ?? 'https://via.placeholder.com/150',
              );
              coachsInfo.add(coachInfo);
              return CoachWidget(
                coachInfo: coachInfo,
                currentUser: currentUser,
              );
            },
            childCount: coachDocs.length,
          ),
        );
      },
    );
  }
}
