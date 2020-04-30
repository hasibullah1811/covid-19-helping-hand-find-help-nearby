import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gender_selector/gender_selector.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:helping_hand/components/progress.dart';
import 'package:helping_hand/config/FadeAnimation.dart';
import 'package:helping_hand/config/config.dart';
import 'package:helping_hand/screens/messageScreen.dart';
import 'package:helping_hand/screens/userProfileScreen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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

  final _formKeyFirst = GlobalKey<FormState>();
  final _formKeySecond = GlobalKey<FormState>();
  final _formKeyThird = GlobalKey<FormState>();

  String username;
  String fullName;
  String selectedGender;
  String bio;
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement initState
    super.dispose();
  }

  Future<void> setData() async {
    final auth = FirebaseAuth.instance;
    final FirebaseUser currentUser = await auth.currentUser();
    final currentUserUID = currentUser.uid;

    final DocumentReference user =
        Firestore.instance.document('users/' + currentUserUID);

    if (displayNameController.text != null &&
        displayNameController.text != "" &&
        displayNameController.text.trim().length > 3 &&
        displayNameController.text.length < 20 &&
        usernameController.text != null &&
        usernameController.text != "" &&
        usernameController.text.trim().length > 3 &&
        usernameController.text.trim().length < 20 &&
        selectedGender != null &&
        selectedGender != "" &&
        bioController.text != null &&
        bioController.text != "" &&
        bioController.text.trim().length > 3 &&
        bioController.text.trim().length < 70 &&
        locationController.text != null &&
        locationController.text != "") {
      final usernameValid = await usernameCheck(usernameController.text);
      if (usernameValid) {
        await user.setData({
          'displayName': displayNameController.text,
          'username': usernameController.text,
          'gender': selectedGender,
          'bio': bioController.text,
          'location': locationController.text,
          'email': currentUser.email,
          'uid': currentUserUID,
          'time': DateTime.now()
        }, merge: true);
        setState(() {
          showSpinner = false;
        });

        usernameController.clear();
        displayNameController.clear();
        bioController.clear();
        locationController.clear();

        var route = MaterialPageRoute(
          builder: (BuildContext context) => UserProfile(),
        );
        Navigator.of(context).push(route);
      } else {
        setState(() {
          showSpinner = false;
        });
        usernameController.clear();
        SnackBar snackbar = SnackBar(
          content: Text(
              "${usernameController.text} already exists, try with another one"),
        );
        _scaffoldKey.currentState.showSnackBar(snackbar);
      }
    }
  }

  Column buildDisplayNameField() {
    //this little code down here turns off auto rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
        FadeAnimation(
          1,
          Form(
            child: TextFormField(
              key: _formKeySecond,
              autovalidate: true,
              validator: (val) {
                if (val.trim().length < 3 || val.isEmpty) {
                  return "Display Name too short";
                } else if (val.trim().length > 20) {
                  return "Display too long";
                } else {
                  return null;
                }
              },
              onSaved: (val) => fullName = val,
              controller: displayNameController,
              decoration: InputDecoration(
                hintText: "Update Display Name",
                errorText: _displayNameValid ? null : "Display Name too short",
              ),
            ),
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
        FadeAnimation(
          1.2,
          Form(
            key: _formKeyFirst,
            autovalidate: true,
            child: TextFormField(
              validator: (val) {
                if (val.trim().length < 3 || val.isEmpty) {
                  return "Username too short";
                } else if (val.trim().length > 15) {
                  return "Username too long";
                } else if (val.contains(" ") || val.startsWith("@")) {
                  return "Don't use space or start with @";
                } else {
                  return null;
                }
              },
              controller: usernameController,
              decoration: InputDecoration(
                hintText: "Enter User Name",
                errorText: _displayNameValid ? null : "User Name too short",
              ),
            ),
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
        FadeAnimation(
          1.4,
          Form(
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
              controller: bioController,
              decoration: InputDecoration(
                hintText: "Update Bio",
                errorText: _bioValid ? null : "Bio is too long",
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(
            "Complete Profile",
            style: titleTextStyle.copyWith(color: Colors.white),
          ),
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
                              FadeAnimation(
                                1.5,
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
                              ),
                              FadeAnimation(
                                1.6,
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
                              ),
                            ],
                          ),
                        ),
                        FadeAnimation(
                          1.6,
                          Container(
                            child: Text(
                              "You Are: ",
                              style: titleTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        FadeAnimation(
                          1.6,
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
                              } else if (gender.toString() == "Gender.FEMALE") {
                                selectedGender = "Female";
                              }
                            },
                          ),
                        ),
                        FadeAnimation(
                          1.7,
                          InkWell(
                            onTap: () {
                              setState(() {
                                showSpinner = true;
                              });
                              setData();
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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

    String formattedAddress =
        "${placemark.subLocality} ${placemark.subThoroughfare}, ${placemark.thoroughfare}, ${placemark.locality}, ${placemark.country}";
    locationController.text = formattedAddress;
  }
}
