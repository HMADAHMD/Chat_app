import 'package:flutter/material.dart';
import 'package:chat_app/constants/constants.dart';

const textFieldDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w200),
  focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromARGB(255, 36, 166, 164), width: 2)),
  enabledBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromARGB(255, 36, 166, 164), width: 2)),
  errorBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromARGB(255, 36, 166, 164), width: 2)),
);

var buttondecoration = BoxDecoration(
  color: const Color.fromARGB(255, 36, 166, 164),
  borderRadius: BorderRadius.circular(20),
);

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}
