import 'package:helping_hand/config/config.dart';
import 'package:flutter/material.dart';
import 'package:helping_hand/screens/otpScreen.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class PhoneSignInScreen extends StatefulWidget {
  @override
  _PhoneSignInScreenState createState() => _PhoneSignInScreenState();
}

class _PhoneSignInScreenState extends State<PhoneSignInScreen> {
  PhoneNumber phoneNumber;
  bool _isSMSsent = false;
  bool _isFieldEmpty = true;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: InkWell(
            borderRadius: BorderRadius.circular(30.0),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black54,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
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
                      ignoreBlank: false,
                      onInputChanged: (phoneNumbertxt) {
                        setState(() {
                          _isFieldEmpty = false;
                        });
                        phoneNumber = phoneNumbertxt;
                      },
                      hintText: "XXXXXXXXX",
                      inputBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      initialCountry2LetterCode: "BD",
                    ),
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
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                          //_verifyPhoneNumber();
                                          //showSpinner = true;
                                        });
                                        setState(() {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Otp(
                                                      uPhoneNumber: phoneNumber,
                                                    )),
                                          );
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: buttonBgColor,
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                    ),
                            ),
                          )
                        : Container(),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: bodyTextStyle,
                          children: <TextSpan>[
                            TextSpan(
                                text: "By tapping Continue, you agree to "),
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
        ),
      ),
    );
  }
}
