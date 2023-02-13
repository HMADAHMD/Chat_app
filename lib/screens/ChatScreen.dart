import 'package:chat_app/screens/LoginScreen.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chatScreen';
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;

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
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Text('ChatScreen'),
      ),
    );
  }

  logout() async {
    final loggedInUser = _auth.signOut();
    Navigator.pop(context);
    print("User is Logged out");
  }
}
