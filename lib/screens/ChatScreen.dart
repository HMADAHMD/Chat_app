import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chatScreen';
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  String? messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
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
          IconButton(
              onPressed: () {
                getMessageStream();
              },
              icon: Icon(Icons.search_rounded))
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: TextField(
                      decoration: messageFieldDecoration,
                      autocorrect: false,
                      onChanged: (value) {
                        messageText = value;
                      },
                    )),
                    TextButton(
                        onPressed: () {
                          sendMessage();
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

  sendMessage() async {
    _firestore.collection('messages').add({
      'text': messageText,
      'sender': loggedInUser!.email,
    });
  }

  void getMessages() async {
    final messages = await _firestore.collection('messages').get();
    for (var message in messages.docs) {
      print(message.data());
    }
  }

  void getMessageStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  logout() async {
    final loggedInUser = _auth.signOut();
    Navigator.pop(context);
    print("User is Logged out");
  }
}
