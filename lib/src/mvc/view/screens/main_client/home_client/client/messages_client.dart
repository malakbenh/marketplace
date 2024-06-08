import 'package:flutter/material.dart';

import 'chat_client.dart';
import '../../../main_coach/constants/followers.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Messages',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Icon(Icons.search),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  followersData.length, // Use the length of followersData
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChatScreenClient()),
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(followersData[index]
                          ['image']!), // Use the follower's image
                    ),
                    title: Text(followersData[index]
                        ['name']!), // Use the follower's name
                    subtitle: const Text('This is a sample message'),
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
