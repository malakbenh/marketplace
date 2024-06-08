import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../model/models/chat.dart';
import '../../../../model/models/user_min.dart';
import '../../../screens.dart'; // Import the UserMin class here

class Profile extends StatefulWidget {
  static const pageRoute = '/profile';

  final String firstName;
  final String photoUrl;
  final UserMin currentUser;

  const Profile({
    super.key,
    required this.firstName,
    required this.photoUrl,
    required this.currentUser,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_outlined,
                size: 34,
                color: Colors.white,
              ),
            ),
          ],
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .84,
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      Text(
                        widget.firstName,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Text(
                        'Algeria, Batna',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const HomeBuyProgram()),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              width: 156,
                              height: 47,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xff35A072),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Buy Program',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Chat chat = Chat.init(
                                author: widget.currentUser,
                                destination: UserMin(
                                  uid:
                                      'destinationUserId', // Replace with the actual destination user id
                                  name: widget.firstName,
                                  photoUrl: widget.photoUrl,
                                  photo: CachedNetworkImageProvider(
                                      widget.photoUrl),
                                  reference: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(
                                          'destinationUserId'), // Adjust accordingly
                                  listChats: null,
                                ),
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(chat: chat),
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 156,
                              height: 47,
                              decoration: BoxDecoration(
                                color: const Color(0xff35A072),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Message',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Column(
                            children: [
                              Text(
                                '2',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text('Posts'),
                            ],
                          ),
                          Container(
                            height: 40,
                            width: 2,
                            color: Colors.grey,
                          ),
                          const Column(
                            children: [
                              Text(
                                '2',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text('Following'),
                            ],
                          ),
                          Container(
                            height: 40,
                            width: 2,
                            color: Colors.grey,
                          ),
                          const Column(
                            children: [
                              Text(
                                '100',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text('Followers'),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.all(20),
                        width: double.infinity,
                        child: DefaultTabController(
                          length: 2,
                          child: TabBar(
                            onTap: (newIndex) {
                              selectedIndex = newIndex;
                              setState(() {});
                            },
                            isScrollable: false,
                            indicatorColor: const Color(0xff35A072),
                            dividerColor: Colors.grey,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            tabs: const [
                              Text(
                                'Posts',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                'Overview',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: selectedIndex == 0
                            ? const PostBody(
                                coachId: '',
                              )
                            : const OverView(),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -80,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 80,
                    child: CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.black,
                      backgroundImage:
                          CachedNetworkImageProvider(widget.photoUrl),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
