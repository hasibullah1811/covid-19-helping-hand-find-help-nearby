import 'package:flutter/material.dart';
import 'package:helping_hand/config/FadeAnimation.dart';
import 'package:helping_hand/config/config.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About',
          style: titleTextStyle.copyWith(color: Colors.white),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 30, bottom: 20),
          margin: EdgeInsets.only(top: 30),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 16.0,
                  bottom: 8.0,
                ),
                child: FadeAnimation(
                  1,
                  ClipRRect(
                    child: Image.asset(
                      'assets/images/app-icon.png',
                      height: 110,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              FadeAnimation(
                1.2,
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Helping Hand",
                    style: titleTextStyle,
                  ),
                ),
              ),
              FadeAnimation(
                1.7,
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: bodyTextStyle,
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                "We understand the current time is tough and people need each other's help more than ever.\n "),
                        TextSpan(text: "\nOur goal at "),
                        TextSpan(
                          text: "Helping Hand ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                            text:
                                "is to provide a platform where people can easily ask for help and volunteers can easily help them with their problems.\n "),
                        TextSpan(
                          text:
                              "\n'Help people even when you know they can't help you back'\n ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                            text:
                                "\n All rights reserved. © Helping Hand. 2020 "),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
