import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notes/add_post_Screen.dart';
import 'package:notes/signup.dart';
import 'splash_screen.dart';
import 'home.dart';
import 'login_screen.dart';
import 'ults/New_Routes.dart';
import 'VERFICATION_Screen.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

      runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode:ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: Typography.whiteCupertino,
        primaryColor: Colors.white,
      ),
      routes:{
        "/":(context)=>Screen(),
        Routes.home:(context)=>HomeScreen(),
        Routes.Sign:(context)=>sign_up(),
        Routes.Login:(context)=>Login(),
        Routes.Post:(context)=>Post(),
        Routes.Ver:(context)=>V_Screen(),
      }
    );
  }
}

