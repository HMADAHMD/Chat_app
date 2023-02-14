import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/screens/ChatScreen.dart';
import 'package:chat_app/screens/RegisterScreen.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = 'login_id';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String pwd = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Chatt..",
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Login to open Guftagu"),
                const SizedBox(
                  height: 20,
                ),
                Image.asset('assets/login.png'),
                TextFormField(
                  decoration: textFieldDecoration.copyWith(
                      labelText: 'Email',
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Constants.primaryColor,
                      )),
                  onChanged: (value) {
                    email = value;
                  },
                  validator: (value) {
                    return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value!)
                        ? null
                        : "Please enter a fucking email wisely";
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: textFieldDecoration.copyWith(
                      labelText: 'Password',
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Constants.primaryColor,
                      )),
                  obscureText: true,
                  validator: (value) {
                    return (value!.length <= 6)
                        ? "Password must be greater than 6 you 'Dumbo'"
                        : null;
                  },
                  onChanged: (value) {
                    pwd = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  child: Container(
                    decoration: buttondecoration,
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    login();
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Text.rich(TextSpan(
                    text: "Don't have an account? ",
                    children: <TextSpan>[
                      TextSpan(
                          text: "Register here",
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              nextScreen(context, RegisterScreen());
                            })
                    ]))
              ],
            )),
      ),
    ));
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Successful')));
    }
    try {
      final existUser =
          await _auth.signInWithEmailAndPassword(email: email, password: pwd);
      if (existUser != null) {
        Navigator.pushNamed(context, ChatScreen.id);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
