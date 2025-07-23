import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fourth_project/constants.dart';

final firestore = FirebaseFirestore.instance;
late User loggedinuser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();

  static const String id = "chat_screen";
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final auth = FirebaseAuth.instance;

  late String messagetext;

  @override
  void initState() {
    super.initState();
    getcurrentuser();
  }



  void getcurrentuser() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        setState(() {
          loggedinuser = user;
        });
      }
    } catch (e) {
      print('Error getting user: $e');
    }
  }

  void getmessages() async {
    final messages = await firestore.collection('messages').get();
    for (var message in messages.docs) {
      print(message.data());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {

              auth.signOut();
               Navigator.pop(context);
            },
          ),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Expanded StreamBuilder for displaying messages
            messageStream(),
            // Message input area
            Container(
              color: Colors.grey[400],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        onChanged: (value) {
                          setState(() {
                            messagetext = value;
                          });
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        messageController.clear();
                        firestore.collection('messages').add({
                          'text': messagetext,
                          'sender': loggedinuser.email,
                          'timestamp': FieldValue.serverTimestamp(), // Add timestamp field
                        });


                        setState(() {
                          messagetext = ''; // Clear the text field after sendin
                        });
                      },
                      child: const Text(
                        'Send',
                        style: kSendButtonTextStyle,
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
}

class messageBubble extends StatelessWidget {
  messageBubble({
    required this.text,
    required this.sender,
    required this.isMe,
  });

  final String text;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(fontSize: 12.0, color: Colors.black),
          ),
          Material(
            elevation: 5,
            borderRadius: isMe? const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),

            ) : const BorderRadius.only(
              topRight: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0)
            ),
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: Text(
                text,
                style:  TextStyle(
                  color: isMe ? Colors.white : Colors.black54 ,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class messageStream extends StatelessWidget {
  const messageStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('messages').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        List<messageBubble> messageWidgets = [];
        if (snapshot.hasData) {
          final messages = snapshot.data!.docs.reversed;
          for (var message in messages) {

            final messageText = message['text'];
            final messageSender = message['sender'];
            final currentUser = loggedinuser.email;

            final messageWidget = messageBubble(
              text: messageText,
              sender: messageSender,
              isMe: currentUser == messageSender,
            );
            messageWidgets.add(messageWidget);
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );

        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}
