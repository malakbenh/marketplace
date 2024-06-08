import 'package:flutter/material.dart';

class ChatScreenClient extends StatefulWidget {
  const ChatScreenClient({super.key});

  static String get pageRoute => '/homeClient';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreenClient> {
  final TextEditingController _textController = TextEditingController();
  final List<MessageBubbleClient> messages =
      []; // Replace with your list of messages

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      messages.insert(0, MessageBubbleClient(message: text, isMe: true));
    });
  }

  Widget _buildTextComposer() {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 15.0), // Adjust the value as needed
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Container(
                height: 50.0,
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Set the color to grey
                  borderRadius:
                      BorderRadius.circular(25.0), // Set the border radius
                ),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.photo_camera,
                          color: Color(0xFF35A072)),
                      onPressed: () {
                        // Handle photo upload
                      },
                    ),
                    Flexible(
                      child: TextField(
                        controller: _textController,
                        onSubmitted: _handleSubmitted,
                        decoration: const InputDecoration(
                          hintText: 'Send a message',
                          border: InputBorder.none, // Removes the underline
                          contentPadding:
                              EdgeInsets.all(10.0), // Adds padding to the text
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconButton(
                        icon: const Icon(Icons.send,
                            color: Color.fromARGB(
                                255, 85, 82, 82)), // Change the color to black
                        onPressed: () => _handleSubmitted(_textController.text),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(2.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://example.com/image.jpg'), // Replace with your image URL
              ),
              SizedBox(
                  width:
                      5), // Give some spacing between the avatar and the name
              Text('client name'), // Replace with your client's name
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const ImageIcon(
              AssetImage(
                  'assets/icons/Vector (1).png'), // Replace with your image path
              color: Colors.black,
              size: 30.0,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const ImageIcon(
              AssetImage(
                  'assets/icons/Vector (2).png'), // Replace with your image path
              color: Color.fromARGB(255, 10, 9, 9),
              size: 30.0,
            ),
            onPressed: () {
              // Handle call button press
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => messages[index],
              itemCount: messages.length,
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}

class MessageBubbleClient extends StatelessWidget {
  final String message;
  final bool isMe;

  const MessageBubbleClient({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: isMe ? const Color(0xFF35A072) : const Color(0xFF35A072),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
              bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
            ),
          ),
          width: 140,
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: Text(
            message,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
