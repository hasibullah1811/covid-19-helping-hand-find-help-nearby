import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gender_selector/gender_selector.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:helping_hand/components/progress.dart';
import 'package:helping_hand/config/config.dart';
import 'package:helping_hand/screens/loginScreen.dart';

final auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class CompleteProfileScreen extends StatefulWidget {
  CompleteProfileScreen({Key key}) : super(key: key);

  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  bool isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _displayNameValid = true;
  bool _bioValid = true;
  bool _usernameValid = true;
  String selectedGender;
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Display Name",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: "Update Display Name",
            errorText: _displayNameValid ? null : "Display Name too short",
          ),
        ),
      ],
    );
  }

  Column buildUserNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "User Name",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            hintText: "Enter User Name",
            errorText: _displayNameValid ? null : "User Name too short",
          ),
        ),
      ],
    );
  }

  Column buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Bio",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: "Update Bio",
            errorText: _bioValid ? null : "Bio is too long",
          ),
        ),
      ],
    );
  }

  completeProfileData() async {
    final FirebaseUser user = await auth.currentUser();
    final userID = user.uid;

    setState(() {
      //Checking the name constraints
      displayNameController.text.trim().length < 3 ||
              displayNameController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;

      //Checking the bio contstraints
      bioController.text.trim().length > 70
          ? _bioValid = false
          : _bioValid = true;

      //Checking the username constraints
      usernameController.text.trim().length < 3 ||
              usernameController.text.isEmpty
          ? _usernameValid = false
          : _usernameValid = true;
    });

    if (_displayNameValid && _bioValid && _usernameValid) {
      // Here write your code to update the profile and redirect
      // Users to the profile page

      // Firestore.instance.document('users/' + userID).updateData({
      //   "displayName": displayNameController.text,
      //   "bio": bioController.text,
      //   "username": usernameController.text,
      // });
      SnackBar snackBar = SnackBar(
        content: Text("Profile Updated"),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          "Complete Profile",
          style: titleTextStyle.copyWith(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green,
            ),
          ),
        ],
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            buildUserNameField(),
                            buildDisplayNameField(),
                            buildBioField(),
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
                          ],
                        ),
                      ),
                      RaisedButton(
                        color: primaryColor,
                        child: Text(
                          "Complete Profile",
                          style: buttonTextStyle,
                        ),
                        onPressed: completeProfileData,
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: FlatButton.icon(
                          onPressed: () => logout(),
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                          label: Text("Logout",
                              style:
                                  titleTextStyle.copyWith(color: Colors.red)),
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
                        },
                      ),
                      InkWell(
                        onTap: () {
                          // Your Function here
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: buttonBgColor,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
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
    print(completeAddress);
    String formattedAddress =
        "${placemark.subLocality} ${placemark.subThoroughfare}, ${placemark.thoroughfare}, ${placemark.locality}, ${placemark.country}";
    locationController.text = formattedAddress;
  }
}
