import 'package:flutter/material.dart';
import 'package:helping_hand/components/header.dart';
import 'package:helping_hand/config/config.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String username;
  final _formKey = GlobalKey<FormState>();


  submit(){
    _formKey.currentState.save();
    Navigator.pop(context, username);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Set up your profile"),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Center(
                    child: Text(
                      "Create a username",
                      style: primaryBodyTextStyle,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        onSaved: (val) => username = val,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(fontSize: 15.0),
                            labelText: "Username",
                            hintText: "Must be at least 3 characters"),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: submit,
                  child: Container(
                    decoration: BoxDecoration(
                      color: buttonBgColor,
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Text(
                      "Submit",
                      style: buttonTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
