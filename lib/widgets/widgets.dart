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

var messageFieldDecoration = const InputDecoration(
    hintText: 'send message',
    filled: true,
    fillColor: Color.fromARGB(255, 246, 255, 255),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        borderSide:
            BorderSide(color: Color.fromARGB(255, 36, 166, 164), width: 1)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        borderSide:
            BorderSide(color: Color.fromARGB(255, 36, 166, 164), width: 1)));

var bubbleDecoration = const BoxDecoration(
  borderRadius: BorderRadius.only(
      topLeft: Radius.circular(100),
      topRight: Radius.circular(10),
      bottomLeft: Radius.circular(100),
      bottomRight: Radius.circular(100)),
);

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}
