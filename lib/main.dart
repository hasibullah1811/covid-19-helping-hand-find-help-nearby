import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:helping_hand/screens/loginScreen.dart';
import 'package:helping_hand/screens/onBoardingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/config.dart';
import 'package:helping_hand/screens/userProfileScreen.dart';

int initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  print('initScreen ${initScreen}');
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: OnBoardingPage(),
      initialRoute: initScreen == 0 || initScreen == null ? "first" : "/",
      routes: {
        '/': (context) => OnBoardingPage(),
        "first": (context) => OnBoardingScreen(),
      },
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
