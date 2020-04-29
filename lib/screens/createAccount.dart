import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helping_hand/config/config.dart';

import 'package:geolocator/geolocator.dart';
import 'package:gender_selector/gender_selector.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  List<String> userDetails = [];
  String username;
  String fullName;
  String selectedGender;
  String bio;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKeyFirst = GlobalKey<FormState>();
  final _formKeySecond = GlobalKey<FormState>();
  final _formKeyThird = GlobalKey<FormState>();
  //final _formKeyThird = GlobalKey<FormState>();
  TextEditingController locationController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();

  submit() async {
    final formOne = _formKeyFirst.currentState;
    final formTwo = _formKeySecond.currentState;
    final formThree = _formKeyThird.currentState;

    if (formOne.validate() && formTwo.validate() & formThree.validate()) {
      formOne.save();
      formTwo.save();
      formThree.save();

      final usernameValid = await usernameCheck(username);

      if (usernameValid) {
        //adds the values to the list
        userDetails.add(username); //0
        userDetails.add(fullName); //1
        userDetails.add(selectedGender); //2
        userDetails.add(bio); //3
        userDetails.add(locationController.text); //4

        SnackBar snackbar = SnackBar(
          content: Text("Welcome $username!"),
        );
        _scaffoldKey.currentState.showSnackBar(snackbar);

        Timer(Duration(seconds: 2), () {
          Navigator.pop(context, userDetails);
        });
      } else {
        SnackBar snackbar = SnackBar(
          content: Text("$username already exists, try with another one"),
        );
        _scaffoldKey.currentState.showSnackBar(snackbar);
      }
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    //this little code down here turns off auto rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
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
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    child: Form(
                      key: _formKeyFirst,
                      autovalidate: true,
                      child: TextFormField(
                        validator: (val) {
                          if (val.trim().length < 3 || val.isEmpty) {
                            return "Username too short";
                          } else if (val.trim().length > 15) {
                            return "Username too long";
                          } else if (val.contains(" ") || val.contains("@")) {
                            return "Don't use space or '@'";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => username = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          labelText: "Username",
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "Must be at least 3 characters",
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    child: Form(
                      key: _formKeySecond,
                      autovalidate: true,
                      child: TextFormField(
                        validator: (val) {
                          if (val.trim().length < 3 || val.isEmpty) {
                            return "Display Name too short";
                          } else if (val.trim().length > 20) {
                            return "Username too long";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => fullName = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          labelText: "Display Name",
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "Must be at least 5 characters",
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    child: Form(
                      key: _formKeyThird,
                      autovalidate: true,
                      child: TextFormField(
                        validator: (val) {
                          if (val.trim().length < 10 || val.isEmpty) {
                            return "Bio is too short";
                          } else if (val.trim().length > 50) {
                            return "Bio is too long";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => bio = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          labelText: "Little bit about yourself ",
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "Must be at least 10 characters",
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.pin_drop,
                    color: secondaryColor,
                    size: 35.0,
                  ),
                  title: Container(
                    width: 250.0,
                    child: TextField(
                      //key: _formKeyThird,
                      controller: locationController,
                      decoration: InputDecoration(
                        hintText: "Enter you address",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 200.0,
                  height: 100.0,
                  alignment: Alignment.center,
                  child: RaisedButton.icon(
                    label: Text(
                      "Use Current Location",
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: primaryColor,
                    onPressed: getUserLocation,
                    icon: Icon(
                      Icons.my_location,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    "You Are: ",
                    style: titleTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                GenderSelector(
                    margin: EdgeInsets.only(
                      left: 10,
                      top: 30,
                      right: 10,
                      bottom: 10,
                    ),
                    selectedGender: Gender.FEMALE,
                    onChanged: (gender) {
                      if (gender.toString() == "Gender.MALE") {
                        selectedGender = "Male";
                        print(selectedGender);
                      } else if (gender.toString() == "Gender.FEMALE") {
                        selectedGender = "Female";
                        print(selectedGender);
                      }
                    }),
                InkWell(
                  onTap: submit,
                  child: Container(
                    decoration: BoxDecoration(
                      color: buttonBgColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Center(
                      child: Text(
                        "Continue",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  //Check if the username already exists or not
  Future<bool> usernameCheck(String username) async {
    final result = await Firestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .getDocuments();
    return result.documents.isEmpty;
  }

  getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    print(completeAddress);
    String formattedAddress =
        "${placemark.subLocality} ${placemark.subThoroughfare}, ${placemark.thoroughfare}, ${placemark.locality}, ${placemark.country}";
    locationController.text = formattedAddress;
  }
}
