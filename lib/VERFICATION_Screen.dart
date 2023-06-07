import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes/home.dart';
import 'package:notes/ults/New_Routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/ults/error.dart';

class V_Screen extends StatefulWidget {
  const V_Screen({Key? key}) : super(key: key);

  @override
  State<V_Screen> createState() => _V_ScreenState();
}

class _V_ScreenState extends State<V_Screen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isEmailverfication = false;
  bool isResent=false;
  Timer?  _timer;

  Future sendVerficationEmail() async {
    try{
      await _auth.currentUser!.sendEmailVerification();
      setState(() {
        isResent=false;
      });
      await Future.delayed(Duration(seconds:5));
      setState(() {
        isResent=true;
      });
    }catch(e)
    {
      errorMessage().loadError(e.toString());
    }

  }

  Future checkemailVerfication() async {

    await _auth.currentUser!.reload().then( (value){
      setState(() {
        isEmailverfication=_auth.currentUser!.emailVerified;
        print("NAHI"+isEmailverfication.toString());
      });
      if(isEmailverfication) _timer?.cancel();

    }).onError((error, stackTrace)  {
      errorMessage().loadError(error.toString());
    });
  }

  @override
   void initState(){
    super.initState();
    isEmailverfication=_auth.currentUser!.emailVerified;
    if(!isEmailverfication){
      sendVerficationEmail();
      _timer = Timer.periodic(Duration(seconds: 3), (_)=>checkemailVerfication(), );
    }
    if(isEmailverfication)
      {
        Navigator.pushNamed(context, Routes.home);
      }
  }
   @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) => isEmailverfication==true ? HomeScreen() : Scaffold(
      appBar: AppBar(centerTitle: true,title:Text("Verification")),
      body: Column(
           mainAxisAlignment: MainAxisAlignment.center,
        children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: Text("Email Has been Seen For verification")),
                  ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(onPressed: isResent ? sendVerficationEmail(): nothing1(), label: const Text("Resend Email"),icon: const Icon(
              Icons.email,
              color: Colors.greenAccent,
              size: 24.0,
            ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(onPressed: signout, label: const Text("Cancel"),icon: const Icon(
              Icons.cancel,
              color: Colors.greenAccent,
              size: 24.0,
            ),
            ),
          ),
        ],
      ),

    );

  nothing1() {}
  void signout()
  {
    _auth.signOut().then((value) { Navigator.pushNamed(context, Routes.Login);}).onError((error, stackTrace) {
      errorMessage().loadError(error.toString());
    });
  }



}
