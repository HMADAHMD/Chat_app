import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/screens/LoginScreen.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const String id = 'registeration_id';
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String pwd = '';
  final _formKey = GlobalKey<FormState>();
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
                  height: 10,
                ),
                const Text("Register to see what they are chatting"),
                const SizedBox(
                  height: 10,
                ),
                Image.asset('assets/register.png'),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: textFieldDecoration.copyWith(
                      labelText: 'Email',
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Constants.primaryColor,
                      )),
                  autocorrect: false,
                  onChanged: (value) {
                    email = value;
                  },
                  validator: (value) {
                    return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value!)
                        ? null
                        : "Please enter your email wisely";
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: textFieldDecoration.copyWith(
                      labelText: 'Password',
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Constants.primaryColor,
                      )),
                  autocorrect: false,
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
                  height: 15,
                ),
                InkWell(
                  child: Container(
                    decoration: buttondecoration,
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Register",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    register();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text.rich(TextSpan(
                    text: "Already have an account? ",
                    children: <TextSpan>[
                      TextSpan(
                          text: "Login",
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              nextScreenReplace(context, LoginScreen());
                            })
                    ]))
              ],
            )),
      ),
    ));
  }

  register() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Successful')));
    }
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: pwd);
      if (newUser != null) {
        Navigator.pushNamed(context, LoginScreen.id);
      }
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
