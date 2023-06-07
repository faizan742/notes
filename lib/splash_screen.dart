import 'dart:async';

import 'package:notes/home.dart';
import 'package:notes/login_screen.dart';
import 'package:notes/ults/error.dart';

import 'ults/New_Routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  final _auth = FirebaseAuth.instance;

  void Login_in() {
    var user = _auth.currentUser;
    print(user);

    if (user == null) {
      Timer(
        Duration(seconds: 3),
            () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        },
      );
    } else {
      Timer(
        Duration(seconds: 3),
            () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
          // errorMessage().loadError(user.email.toString());
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    //Login_in();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "ADD NOTES",
          style: TextStyle(fontSize: 20, color: Colors.amber),
        ),
      ),
    );
  }
}
