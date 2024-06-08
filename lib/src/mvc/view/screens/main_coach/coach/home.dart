import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants/followers.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> imageUrls = [];

  Future<String?> getCurrentCoachUid() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      print('Picked image path: ${image.path}');
      String? coachUid = await getCurrentCoachUid();
      if (coachUid != null) {
        String downloadUrl = await uploadImageToFirebase(image, coachUid);
        setState(() {
          imageUrls.add(downloadUrl);
        });
      } else {
        print('No coach UID found.');
      }
    } else {
      print('No image selected.');
    }
  }

  Future<String> uploadImageToFirebase(XFile image, String uid) async {
    File file = File(image.path);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('images/$uid/$fileName');
    UploadTask uploadTask = ref.putFile(file);

    await uploadTask.whenComplete(() => null);
    String downloadUrl = await ref.getDownloadURL();

    // Save the image URL to Firestore with the coach's UID as the document ID
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(uid)
        .collection('posts')
        .add({
      'url': downloadUrl,
      'name': fileName,
      'createdAt': Timestamp.now(),
      'coachId': uid,
    });

    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: FutureBuilder<String?>(
              future: getCurrentCoachUid(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                String? coachUid = snapshot.data;
                if (coachUid == null) {
                  // Handle case when coach UID is not available
                  return const Text('Coach UID not found');
                }
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(coachUid)
                      .collection('posts')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return SizedBox(
                            width: 150,
                            child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/coaches/Rectangle 120.png',
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    height: 110,
                                  ),
                                  GestureDetector(
                                    onTap: pickImage,
                                    child: const CircleAvatar(
                                      backgroundColor: Color(0xFF35A072),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const Text('Add post')
                                ],
                              ),
                            ),
                          );
                        } else {
                          var doc = snapshot.data!.docs[index - 1];
                          return Card(
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: Image.network(
                                doc['url'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Clients',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('clients').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(doc['image']),
                          ),
                          const SizedBox(height: 8),
                          Text(doc['name']),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Followers',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: followersData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            AssetImage(followersData[index]['image']!),
                      ),
                      const SizedBox(height: 8),
                      Text(followersData[index]['name']!),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
