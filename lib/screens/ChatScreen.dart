import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

User? loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chatScreen';
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    //created after registeration of user to check which user is logged in...
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser?.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat App"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 1,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                logout();
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    CircularProgressIndicator();
                  }
                  final messages = snapshot.data!.docs.reversed;
                  List<MessageBubble> messageWidgets = [];
                  for (var message in messages) {
                    final dynamic messageData = message.data();
                    final messageText = messageData['text'];
                    final messageSender = messageData['sender'];
                    final currentUser = loggedInUser!.email;

                    if (currentUser == messageSender) {
                      //check if the current user is me or not
                    }

                    final messageWidget = MessageBubble(
                      sender: messageSender,
                      text: messageText,
                      isMe: currentUser == messageSender,
                    );
                    messageWidgets.add(messageWidget);
                  }
                  if (messageWidgets.isEmpty) {
                    return Text('No messages found');
                  }
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        reverse: true,
                        children: messageWidgets,
                      ),
                    ),
                  );
                }),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: TextField(
                      controller: _messageController,
                      decoration: messageFieldDecoration,
                      autocorrect: false,
                      onChanged: (value) {
                        messageText = value;
                      },
                    )),
                    TextButton(
                        onPressed: () {
                          sendMessage();
                          _messageController.clear();
                        },
                        child: const Text(
                          "send",
                          style: TextStyle(
                              color: Constants.primaryColor, fontSize: 17),
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  var _messageController = TextEditingController();

  sendMessage() async {
    // this method is used to send messages in the database and to the user after that.
    _firestore.collection('messages').add({
      'text': messageText,
      'sender': loggedInUser!.email,
    });
  }

  // this is the message to get the messages using futures
  void getMessages() async {
    final messages = await _firestore.collection('messages').get();
    for (var message in messages.docs) {
      print(message.data());
    }
  }

  void getMessageStream() async {
    // this is the message to get the messages using streams so don't have to press the button every time
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  logout() async {
    //function to logout the user from the chat screen
    final loggedInUser = _auth.signOut();
    Navigator.pop(context);
    print("User is Logged out");
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({required this.sender, required this.text, required this.isMe});
  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              '$sender',
              style: TextStyle(fontSize: 10),
            ),
            Container(
              decoration: isMe
                  ? BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(100),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100)),
                      color: Constants.primaryColor)
                  : BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(100),
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100)),
                      color: Color.fromARGB(255, 71, 80, 80)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
                child: Text(
                  '$text',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
