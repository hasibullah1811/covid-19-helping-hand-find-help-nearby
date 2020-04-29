import 'package:flutter/services.dart';
import 'package:helping_hand/config/FadeAnimation.dart';
import 'package:helping_hand/config/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helping_hand/screens/loginScreen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ForgotPassScreen extends StatefulWidget {
  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final TextEditingController _emailController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    //this little code down here turns off auto rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Password Reset",
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
                FadeAnimation(
                  1,
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
                ),

                FadeAnimation(
                  1.2,
                  InkWell(
                    onTap: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      if (_emailController.text.isNotEmpty) {
                        await resetPassword(_emailController.text);
                        Alert(
                          context: context,
                          type: AlertType.success,
                          title: "Verification Link Sent",
                          desc:
                              "An email with the verification link has been sent to ${_emailController.text}. Use that link to change reset your password.",
                          style: AlertStyle(
                            titleStyle: titleTextStyle,
                            descStyle: bodyTextStyle,
                          ),
                          buttons: [
                            DialogButton(
                              color: buttonBgColor,
                              width: 120,
                              child: Text(
                                "OK",
                                style: buttonTextStyle,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ).show();
                        setState(() {
                          showSpinner = false;
                        });
                      } else {
                        setState(() {
                          showSpinner = false;
                        });
                        Alert(
                          context: context,
                          type: AlertType.error,
                          title: "Invalid email",
                          desc:
                              "Please enter a email that was used to create your account",
                          style: AlertStyle(
                            titleStyle: titleTextStyle,
                            descStyle: bodyTextStyle,
                          ),
                          buttons: [
                            DialogButton(
                              color: buttonBgColor,
                              child: Text(
                                "OK",
                                style: buttonTextStyle,
                              ),
                              onPressed: () => Navigator.pop(context),
                              width: 120,
                            )
                          ],
                        ).show();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      width: MediaQuery.of(context).size.width,
                      margin:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      child: Center(
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                FadeAnimation(
                  1.4,
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: bodyTextStyle,
                        children: <TextSpan>[
                          TextSpan(text: "By tapping Submit, a "),
                          TextSpan(
                            text: "Password Reset Link ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                              text:
                                  "will be sent to your given mail, use that link to change your password")
                        ],
                      ),
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

  //Reset Password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
    setState(() {
      showSpinner = false;
    });
  }
}
