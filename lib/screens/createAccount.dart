import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helping_hand/components/header.dart';
import 'package:helping_hand/config/config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gender_selector/gender_selector.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Im;
import 'dart:io';

final usersRef = Firestore.instance.collection('users');
final StorageReference storageRef = FirebaseStorage.instance.ref();
final auth = FirebaseAuth.instance;
String photoURL;

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
  String bio;
  String photoURL;

  final _formKeyFirst = GlobalKey<FormState>();
  final _formKeySecond = GlobalKey<FormState>();
  final _formKeyThird = GlobalKey<FormState>();
  final _formKeyFourth = GlobalKey<FormState>();
  TextEditingController locationController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();

  bool showSpinner = false;
  bool isUploaded = false;
  File file;
  bool isUploading = false;
  String postId = Uuid().v4();

  updateUserDetails(String mediaUrl) {
    print("This is from updateUserDetails : $mediaUrl");
    userDetails.add(mediaUrl);//0
    setState(() {
      g.update('photUrl', (v) => mediaUrl);
    });
  }

  submit() {
    setState(() {
      showSpinner = false;
    });
    _formKeyFirst.currentState.save();
    _formKeySecond.currentState.save();
    _formKeyThird.currentState.save();
    //_formKeyFourth.currentState.save();
    

    userDetails.add(username.toString()); //1
    userDetails.add(fullName.toString()); //2
    userDetails.add(selectedGender.toString());//3
    userDetails.add(locationController.text);//4
    userDetails.add(bio.toString());//5
    Navigator.pop(context, userDetails);
  }

  //bool showSpinner = false;
  Map<String, dynamic> g = {
    'displayName': 'N/A',
    'photUrl':
    'https://firebasestorage.googleapis.com/v0/b/helping-hand-76970.appspot.com/o/default-user-img.png?alt=media&token=d96df74f-5b3b-4f08-86f8-d1a913459e07',
    'points': 0,
    'username': 'N/A',
    'bio': 'N/A',
    'peopleHelped': 0,
    'email': 'N/A'
  };

  //Handle Submit
  handleSubmit() async {
    await compressImage();
    String mediaUrl = await uploadImage(file);
    updateUserDetails(mediaUrl);
    print("This from handleSubmit " + mediaUrl);
    setState(() {
      file = null;
      isUploading = false;
      postId = Uuid().v4();
    });
  }

  Future<void> get_user_info() async {
    final FirebaseUser user = await auth.currentUser();
    final userID = user.uid;
    final DocumentReference users =
        Firestore.instance.document('users/' + userID);
    await for (var snapshot in users.snapshots()) {
      setState(() {
        var combinedMap = {...?g, ...?snapshot.data};
        g = combinedMap;
        if (g['photUrl'] == null || g['photUrl'] == "") {
          g.update('photUrl', (v) => v = photoURL);
        }
        print(g);
      });
    }
  }

  @override
  void initState() {
    get_user_info();
    super.initState();
  }

  buildUploadForm() {
    return Scaffold(
      appBar: header(context, titleText: "Set up your profile"),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: ListView(
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
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Positioned(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              g['photUrl'],
                              height: 120,
                              width: 110,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          key: _formKeyFourth,
                          bottom: 1.0,
                          right: 1.0,
                          child: InkWell(
                            onTap: () {
                              selectImage(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white54,
                                  borderRadius: BorderRadius.circular(20)),
                              height: 40,
                              width: 40,
                              child: Icon(
                                Icons.add_a_photo,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      child: Form(
                        key: _formKeyThird,
                        child: TextFormField(
                          onSaved: (userBio) => bio = userBio,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              labelStyle: TextStyle(fontSize: 15.0),
                              labelText: "Bio",
                              hintText: "Tell us a bit about yourself"),
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
                    onTap: () {
                      showSpinner = true;
                      submit();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: buttonBgColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      width: MediaQuery.of(context).size.width,
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildUploadForm();
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

  //functions required for handling images

  //Take photo with camera
  handleTakePhoto() async {
    Navigator.pop(context);
    File file = (await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    ));
    setState(() {
      this.file = file;
    });
    handleSubmit();
    setState(() {
      isUploaded = true;
    });
  }

  //Use the photo from gallery

  handleChooseFromGallery() async {
    Navigator.pop(context);
    File file = (await ImagePicker.pickImage(source: ImageSource.gallery));
    setState(() {
      this.file = file;
    });
    handleSubmit();
    setState(() {
      isUploaded = true;
    });
  }

  // Selecting the image to upload
  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Upload your picture",
              style: titleTextStyle,
            ),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  "Photo with Camera",
                  style: bodyTextStyle.apply(color: Colors.black),
                ),
                onPressed: handleTakePhoto,
              ),
              SimpleDialogOption(
                child: Text(
                  "Image from Gallery",
                  style: bodyTextStyle.apply(color: Colors.black),
                ),
                onPressed: handleChooseFromGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: bodyTextStyle.apply(color: Colors.black),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  //Compresses the size of the image
  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  //Uploads an image
  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask =
        storageRef.child("post_$postId.jpg").putFile(imageFile);

    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  bool get wantKeepAlive => true;
}
