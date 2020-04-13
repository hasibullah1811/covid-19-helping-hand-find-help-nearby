import 'package:flutter/material.dart';
import 'package:helping_hand/screens/onBoardingScreen.dart';
import 'config/config.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnBoardingScreen(),
      theme:
          ThemeData(primaryColor: primaryColor, brightness: Brightness.light),
      darkTheme:
          ThemeData(primaryColor: primaryColor, brightness: Brightness.dark),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardingScreen(),
    );
  }
}
