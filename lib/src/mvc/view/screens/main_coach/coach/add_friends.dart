import 'package:flutter/material.dart';

class AddFriend extends StatelessWidget {
  const AddFriend({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friends'),
      ),
      body: const Center(
        child: Text('Add Friends'),
      ),
    );
  }
}
