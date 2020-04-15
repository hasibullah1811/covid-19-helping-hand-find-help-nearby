import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


final GoogleSignIn googleSignIn = GoogleSignIn();
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text("Home Page"),
            ),
            RaisedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
            ),
            Container(
              child: Text("Google Logout"),
            ),
            RaisedButton(
              onPressed: () {
                googleSignIn.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
