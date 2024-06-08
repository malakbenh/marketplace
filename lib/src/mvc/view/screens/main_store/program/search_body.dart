// import 'package:flutter/material.dart';
// import 'package:news/amina/coach_widget.dart';

// class BuildSearchBodyList extends StatelessWidget {
//   final String q;
//   const BuildSearchBodyList({super.key, required this.q});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: OnlineDataSources.getCoachBySearch(q),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return buildMovieList(snapshot.data!);
//         } else {
//           return const Center(
//               child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image(
//                   image: AssetImage(
//                       "صوره من عندك ")),
//               SizedBox(
//                 height: 8,
//               ),
//               Text(
//                 "No coach found",
//                 style: TextStyle(color: Colors.grey, fontSize: 14),
//               ),
//             ],
//           ),
//           );
//         }
//       },
//     );
//   }

//   Widget buildMovieList(List<coach> resultSearch) {
//     return ListView.builder(
//       itemCount: resultSear.length,
//       itemBuilder: (context, index) {
//         return CoachWidget(
//           url: ,
//           name: ,
//           rate: ,
//           time: ,
//           Salary: ,
//         );
//       },
//     );
//   }
// }
