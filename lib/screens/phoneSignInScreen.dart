import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helping_hand/config/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneSignInScreen extends StatefulWidget {
  @override
  _PhoneSignInScreenState createState() => _PhoneSignInScreenState();
}

class _PhoneSignInScreenState extends State<PhoneSignInScreen> {
  PhoneNumber _phoneNumber;

  String _message;
  String _verificationId;
  bool _isSMSsent = false;
  bool _isFieldEmpty = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _smsController = TextEditingController();
  final Firestore _db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            margin: EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 98),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  child: Text(
                    "Enter your phone number",
                    style: primaryBodyTextStyle,
                  ),
                ),
                InternationalPhoneNumberInput(
                  onInputChanged: (phoneNumbertxt) {
                    setState(() {
                      _isFieldEmpty = false;
                    });
                    _phoneNumber = phoneNumbertxt;
                  },
                  hintText: "XXXXXXXXX",
                  inputBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  initialCountry2LetterCode: "BD",
                ),
                _isSMSsent
                    ? Container(
                        padding: EdgeInsets.only(top: 30),
                        margin: EdgeInsets.all(10.0),
                        child: TextField(
                          controller: _smsController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                            hintText: "OTP here",
                          ),
                          maxLength: 6,
                          keyboardType: TextInputType.number,
                        ),
                      )
                    : Container(),
                !_isSMSsent
                    ? Container(
                        child: InkWell(
                            child: _isFieldEmpty
                                ? InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFE6E8EB),
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 20),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 20),
                                      child: Center(
                                        child: Text(
                                          "Continue",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isSMSsent = true;
                                      });

                                      _verifyPhoneNumber();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: buttonBgColor,
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 20),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 20),
                                      child: Center(
                                        child: Text(
                                          "Continue",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  )),
                      )
                    : Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              _signInWithPhoneNumber();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: buttonBgColor,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 20),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 20),
                              child: Center(
                                  child: Text(
                                "Submit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                          FlatButton(
                            child: Text("Didn't get a code? Resend Code."),
                            onPressed: () {
                              setState(() {
                                _isSMSsent = true;
                              });

                              _verifyPhoneNumber();
                            },
                          ),
                        ],
                      ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: bodyTextStyle,
                      children: <TextSpan>[
                        TextSpan(text: "By tapping Continue, you agree to "),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _verifyPhoneNumber() async {
    setState(() {
      _message = '';
    });

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        _message = 'Received phone auth credential: $phoneAuthCredential';
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        _message =
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumber.phoneNumber,
        timeout: const Duration(seconds: 120),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  // Example code of how to sign in with phone.
  void _signInWithPhoneNumber() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _smsController.text,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        //Storing user data into the firestore database
        _db.collection("users").document(user.uid).setData({
          "phoneNumber": user.phoneNumber,
          "lastSeen": DateTime.now(),
          "signin_method": user.uid,
        });
        _message = 'Successfully signed in, uid: ' + user.uid;
        print(_message);
      } else {
        _message = 'Sign in failed';
      }
    });
    Navigator.pop(context);
  }
}
