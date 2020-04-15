import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helping_hand/config/config.dart';
import 'package:helping_hand/screens/createAccount.dart';
import 'package:helping_hand/screens/emailPassSignup.dart';
import 'package:helping_hand/screens/otpScreen.dart';
import 'package:helping_hand/screens/phoneSignInScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final usersRef = Firestore.instance.collection('users');
  final DateTime timestamp = DateTime.now();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(bottom: 80.0),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 80),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor,
                      blurRadius: 30,
                      offset: Offset(10, 10),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Image(
                  image: AssetImage("assets/images/logo_round.png"),
                  width: 150,
                  height: 150,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              //Email text Field
              Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(top: 30.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    hintText: "Enter your email here",
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),

              //Password Input Field
              Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(top: 10.0),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    hintText: "Enter your password here",
                  ),
                  obscureText: true,
                ),
              ),

              InkWell(
                onTap: () {
                  _signin();
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        secondaryColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Center(
                      child: Text(
                    "Login with email",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
                ),
              ),

              FlatButton(
                child: Text("OTP Screen"),
                onPressed: () {},
              ),

              FlatButton(
                child: Text("Sign Up with email"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmailPassSignupScreen(),
                    ),
                  );
                },
              ),

              Container(
                margin: EdgeInsets.only(
                  top: 10.0,
                ),
                child: Wrap(
                  children: <Widget>[
                    FlatButton.icon(
                      onPressed: _signInUsingGoogle,
                      icon: Icon(
                        FontAwesomeIcons.google,
                      ),
                      label: Text(
                        "Sign-in using Gmail",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                    FlatButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PhoneSignInScreen(),
                          ),
                        );
                      },
                      icon: Icon(Icons.phone),
                      label: Text(
                        "Sign-in using Phone",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Reset Password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  void _signin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) {
        if (user != null) {
          //Storing user data into the firestore database
          _db.collection("users").document(user.user.uid).setData({
            "phoneNumber": email,
            "lastSeen": DateTime.now(),
            "signin_method": user.user.uid,
          });
        }

        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                title: Text("Logged In"),
                content: Text(
                  "Sign-in Success",
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      _emailController.text = "";
                      _passwordController.text = "";
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              );
            });
      }).catchError((e) {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                title: Text("Error"),
                content: Text(
                  "${e.message}",
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      _emailController.text = "";
                      _passwordController.text = "";
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              );
            });
      });
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: Text("Error"),
              content: Text(
                "Please provide email and password...",
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    _emailController.text = "";
                    _passwordController.text = "";
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            );
          });
    }
  }

  void _signInUsingGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAccount currentUser = _googleSignIn.currentUser;
      final DocumentSnapshot doc = await usersRef.document(currentUser.id).get();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      print("signed in " + user.displayName);

      //Storing the user data in the firestore database

      if (!doc.exists) {
        final username = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => CreateAccount()));
        _db.collection("users").document(currentUser.id).setData({
          "username" : username,
          "displayName": currentUser.displayName,
          "email": currentUser.email,
          "photUrl": currentUser.photoUrl,
          "timestamp": timestamp,
          "signin_method": user.providerId,
        });
      }


    } catch (e) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: Text("Error"),
              content: Text(
                "${e.message}",
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    _emailController.text = "";
                    _passwordController.text = "";
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            );
          });
    }
  }
}
