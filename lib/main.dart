import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helping_hand/screens/homeScreen.dart';
import 'package:helping_hand/screens/loginScreen.dart';
import 'config/config.dart';
import 'package:helping_hand/screens/userProfileScreen.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnBoardingPage(),
      theme: ThemeData(
        primaryColor: primaryColor,
        brightness: Brightness.light,
        primaryTextTheme: TextTheme(
          body1: bodyTextStyle,
          title: titleTextStyle,
          button: buttonTextStyle,
        ),
      ),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _auth.onAuthStateChanged,
        builder: (ctx, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            FirebaseUser user = snapshot.data;
            if (user != null) {
             return UserProfile();
            } else {
             return LoginScreen();
            }
          }
          return LoginScreen();
        },
        
      ),
    );
  }
}
