import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helping_hand/config/config.dart';
import 'package:helping_hand/screens/createAccount.dart';
import 'package:helping_hand/screens/emailPassSignup.dart';
import 'package:helping_hand/screens/forgotPasswordScreen.dart';
import 'package:helping_hand/screens/phoneSignInScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:helping_hand/screens/userProfileScreen.dart';
import 'package:helping_hand/services/push_notification_service.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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
  PushNotificationService _pushNotificationService = PushNotificationService();

  bool isAuth = false;
  bool showSpinner = false;
  //bool get wantKeepAlive => true;

  // navigateToPhoneSignInScreen() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => PhoneSignInScreen(),
  //     ),
  //   );
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(bottom: 80.0),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                // Container(
                //   margin: EdgeInsets.only(top: 80),
                //   decoration: BoxDecoration(
                //     boxShadow: [
                //       BoxShadow(
                //         color: primaryColor,
                //         blurRadius: 30,
                //         offset: Offset(10, 10),
                //         spreadRadius: 0,
                //       ),
                //     ],
                //   ),
                //   child: Image(
                //     image: AssetImage("assets/images/logo_round.png"),
                //     width: 150,
                //     height: 150,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      "Login",
                      style: titleTextStyle.copyWith(
                          color: primaryColor, fontSize: 35),
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
                      prefixIcon: Icon(
                        Icons.email,
                        color: primaryColor,
                      ),
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
                      prefixIcon: Icon(
                        Icons.lock,
                        color: primaryColor,
                      ),
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      hintText: "Enter your password here",
                    ),
                    obscureText: true,
                  ),
                ),

                InkWell(
                  onTap: () {
                    setState(() {
                      showSpinner = true;
                    });
                    _emailSignin();
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
                        "Login with email",
                        style: buttonTextStyle,
                      ),
                    ),
                  ),
                ),

                FlatButton(
                  child: Text(
                    "Forgot Password?",
                    style: titleTextStyle.copyWith(fontSize: 13),
                  ),
                  onPressed: () {
                    // action here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPassScreen()),
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
                        onPressed: () {
                          setState(() {
                            showSpinner = true;
                          });
                          _signInUsingGoogle();
                        },
                        icon: Icon(
                          FontAwesomeIcons.google,
                        ),
                        label: Text(
                          "Sign-in using Gmail",
                          style: titleTextStyle.copyWith(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmailPassSignupScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Don\'t have an Account? ',
                            style: titleTextStyle.copyWith(fontSize: 16),
                          ),
                          TextSpan(
                            text: 'Sign Up',
                            style: titleTextStyle.copyWith(
                                fontSize: 16, color: secondaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // configurPushNotification() async {
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //   final FirebaseUser user = await _auth.currentUser();
  //   if (Platform.isIOS) getiOSPermission();

  //   _firebaseMessaging.getToken().then((token) {
  //     print("Firebase Messaging Token : $token\n");
  //     usersRef
  //         .document(user.uid)
  //         .updateData({"androidNotificationToken:": token});
  //   });

  //   _firebaseMessaging.configure(
  //    onMessage: (Map<String, dynamic>, message) async{
  //      print("on message: $message\n");
  //      final String recipientId = message['data']['recipient'];
  //      final String body = message['notification']['body'];
  //      if
  //    }
  //   );
  // }

  void _emailSignin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) async {
        await _pushNotificationService.initialise();
        if (user != null) {
          final DocumentSnapshot doc =
              await usersRef.document(user.user.uid).get();
          if (!doc.exists) {
            final userDetails = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateAccount()));
            _db.collection("users").document(user.user.uid).setData({
              "username": userDetails[1],
              "displayName": userDetails[2],
              "email": email,
              "photUrl": userDetails[0],
              "gender": userDetails[3],
              "timestamp": timestamp,
              "signin_method": user.user.providerId,
              "location": userDetails[4],
              "uid": user.user.uid,
              "points": 0,
              "bio": userDetails[5],
            });
          }
        }
        setState(() {
          showSpinner = false;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserProfile()),
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
        setState(() {
          showSpinner = false;
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
      setState(() {
        showSpinner = false;
      });
    }
  }

  void _signInUsingGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAccount currentUser = _googleSignIn.currentUser;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      print("signed in " + user.displayName);

      await _pushNotificationService.initialise();

      final DocumentSnapshot doc = await usersRef.document(user.uid).get();
      //Storing the user data in the firestore database

      if (!doc.exists) {
        final userDetails = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => CreateAccount()));
        _db.collection("users").document(user.uid).setData({
          "username": userDetails[1],
          "displayName": userDetails[2],
          "email": currentUser.email,
          "photUrl": userDetails[0],
          "gender": userDetails[3],
          "timestamp": timestamp,
          "signin_method": user.providerId,
          "location": userDetails[4],
          "uid": user.uid,
          "points": 0,
          "bio": userDetails[5],
        });
      }
      setState(() {
        showSpinner = false;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserProfile()),
        );
      });
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
      setState(() {
        showSpinner = false;
      });
    }
  }
}
