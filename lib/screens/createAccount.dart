import 'package:flutter/material.dart';
import 'package:helping_hand/components/header.dart';
import 'package:helping_hand/config/config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gender_selector/gender_selector.dart';

class CreateAccount extends StatefulWidget {
  // final String userName;
  // final String fullName;
  // final String address;
  // CreateAccount({this.userName, this.fullName, this.address});
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  List<String> userDetails = [];
  String username;
  String fullName;
  String selectedGender;
  final _formKeyFirst = GlobalKey<FormState>();
  final _formKeySecond = GlobalKey<FormState>();
  //final _formKeyThird = GlobalKey<FormState>();
  TextEditingController locationController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();

  submit() {
    _formKeyFirst.currentState.save();
    _formKeySecond.currentState.save();
    userDetails.add(username);
    userDetails.add(fullName);
    userDetails.add(selectedGender);
    userDetails.add(locationController.text);
    Navigator.pop(context, userDetails);
    
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
                      "Create your account",
                      style: primaryBodyTextStyle,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    child: Form(
                      key: _formKeyFirst,
                      child: TextFormField(
                        onSaved: (val) => username = val,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            labelStyle: TextStyle(fontSize: 15.0),
                            labelText: "Username",
                            hintText: "Must be at least 3 characters"),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    child: Form(
                      key: _formKeySecond,
                      child: TextFormField(
                        onSaved: (fullname) => fullName = fullname,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            labelStyle: TextStyle(fontSize: 15.0),
                            labelText: "Full Name",
                            hintText: "Your Display Name"),
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
          ),
        ],
      ),
    );
  }

  getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    //print(completeAddress);
    String formattedAddress =
        "${placemark.subLocality} ${placemark.subThoroughfare}, ${placemark.thoroughfare}, ${placemark.locality}, ${placemark.country}";
    locationController.text = formattedAddress;
  }
}