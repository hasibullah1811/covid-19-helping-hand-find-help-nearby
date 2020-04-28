import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helping_hand/config/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helping_hand/screens/createAccount.dart';
import 'package:helping_hand/screens/userProfileScreen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EmailPassSignupScreen extends StatefulWidget {
  @override
  _EmailPassSignupScreenState createState() => _EmailPassSignupScreenState();
}

class _EmailPassSignupScreenState extends State<EmailPassSignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();

  final usersRef = Firestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final DateTime timestamp = DateTime.now();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool showSpinner = false;
  bool passMatch = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Sign Up with Email",
          style: titleTextStyle.copyWith(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                //Email text Field
                Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(top: 30.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: primaryColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
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
                    controller: _passController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: primaryColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      labelText: "Password",
                      hintText: "Enter your password here",
                    ),
                    obscureText: true,
                  ),
                ),

                //Password Input Field
                Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(top: 10.0),
                  child: TextField(
                    controller: _confirmPassController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: primaryColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      labelText: "Confirm your password",
                      hintText: "Enter your password here again",
                      errorText: passMatch ? null : "Password doesn't match",
                    ),
                    obscureText: true,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      showSpinner = true;
                    });
                    FocusScope.of(context).requestFocus(FocusNode());
                    _signup();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: Center(
                      child: Text(
                        "Signup using email",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: bodyTextStyle,
                      children: <TextSpan>[
                        TextSpan(text: "By tapping Signup, you agree to "),
                        TextSpan(
                          text: "Terms & Conditions ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "and "),
                        TextSpan(
                          text: "Privacy Policy ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "of Helping Hand. ")
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signup() async {
    String email = _emailController.text.toString().trim();
    String password = _passController.text;
    String confirmPass = _confirmPassController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      if (password == confirmPass) {
        setState(() {
          passMatch = true;
        });
      } else {
        passMatch = false;
      }

      if (passMatch) {
        await _auth
            .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
            .then((user) async {
          if (user.user != null) {
            try {
              await user.user.sendEmailVerification();
              SnackBar snackbar = SnackBar(
                duration: Duration(seconds: 5),
                content: Text(
                    "A verification mail is sent to : $email, verify to protect your ID"),
              );
              _scaffoldKey.currentState.showSnackBar(snackbar);
            } catch (e) {
              SnackBar snackbar = SnackBar(
                duration: Duration(seconds: 5),
                content:
                    Text("Could not send the verification mail to : $email "),
              );
              _scaffoldKey.currentState.showSnackBar(snackbar);
            }
            final DocumentSnapshot doc =
                await usersRef.document(user.user.uid).get();
            if (!doc.exists) {
              final userDetails = await Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => CreateAccount()));

              print("User Details : " + userDetails.toString());
              _db.collection("users").document(user.user.uid).setData({
                "username": userDetails[0],
                "displayName": userDetails[1],
                "email": email,
                "photUrl": 'N/A',
                "gender": userDetails[2],
                "timestamp": timestamp,
                "signin_method": user.user.providerId,
                "location": userDetails[4],
                "uid": user.user.uid,
                "points": 0,
                "bio": userDetails[3],
              });
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UserProfile()),
            );
            setState(() {
              showSpinner = false;
            });
            //   //Storing data in Firestore Database
            //   _db.collection("users").document(user.user.uid).setData({
            //     "email": email,
            //     "lastseen": DateTime.now(),
            //     "signin_method": user.user.providerId,
            //   });
          }
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
                      child: Text("Okay"),
                      onPressed: () {
                        _emailController.text = "";
                        _passController.text = "";
                        _confirmPassController.text = "";
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                );
              });
          setState(() {
            showSpinner = false;
          });
        });
      }
      {
        setState(() {
          showSpinner = false;
        });
      }
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: Text("Error.."),
              content: Text(
                "Please provide Email & Password",
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    _emailController.text = "";
                    _passController.text = "";
                    _confirmPassController.text = "";
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            );
          });
      setState(() {
        showSpinner = false;
      });
    }
  }
}
