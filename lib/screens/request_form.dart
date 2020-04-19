import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:helping_hand/screens/userProfileScreen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class request_form extends StatefulWidget {
  @override
  _request_formState createState() => _request_formState();
}

class _request_formState extends State<request_form> {
  final auth = FirebaseAuth.instance;
  String title;
  String desc;

  bool toggleID = false;

  toggleButton() {
    setState(() {
      toggleID = !toggleID;
    });
  }

  Future<void> submit_button_action() async {
    //get the user
    final auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    final userID = user.uid;
    Map<String, dynamic> user_info_map;
    final DocumentReference user_info_collection =
        Firestore.instance.document('users/' + userID);
    await for (var snapshot in user_info_collection.snapshots()) {
      setState(() {
        user_info_map = snapshot.data;
      });
      break;
    }

    //get the location
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    final CollectionReference user_posts =
        Firestore.instance.collection('helpRequests/' + userID + '/userPosts');
    DocumentReference post_id = await user_posts.add({
      'timestamp': DateTime.now(),
      'location': new GeoPoint(position.latitude, position.longitude),
      'title': title,
      'description': desc,
      'ownerID': userID
    });

    //regarding user's identity
    if (toggleID) {
      return await user_posts.document(post_id.documentID).setData({
        'name': 'N/A',
        'postID': post_id.documentID,
        'photUrl':
            'https://firebasestorage.googleapis.com/v0/b/helping-hand-76970.appspot.com/o/default-user-img.png?alt=media&token=d96df74f-5b3b-4f08-86f8-d1a913459e07'
      }, merge: true);
    } else if (!toggleID) {
      return await user_posts.document(post_id.documentID).setData({
        'name': user_info_map['displayName'],
        'postID': post_id.documentID,
        'photUrl': user_info_map['photUrl']
      }, merge: true);
    }
  }

  void cleanup_after_submit() {}

  @override
  Widget build(BuildContext context) {
    //this little code down here turns off auto rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Color(0xFF2F3676),
          Color(0xFF2F3676),
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                    Text("Request Help!",
                        style: TextStyle(color: Colors.white, fontSize: 30)),
                  ],
                )),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(40))),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            Text("Hide my ID",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: 140,
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              height: 40.0,
                              width: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: toggleID
                                      ? Colors.greenAccent[100]
                                      : Colors.redAccent[100].withOpacity(0.5)),
                              child: Stack(
                                children: <Widget>[
                                  AnimatedPositioned(
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    top: 3.0,
                                    left: toggleID ? 30.0 : 0.0,
                                    right: toggleID ? 0.0 : 30.0,
                                    child: InkWell(
                                      onTap: toggleButton,
                                      child: AnimatedSwitcher(
                                          duration: Duration(milliseconds: 200),
                                          transitionBuilder: (Widget child,
                                              Animation<double> animation) {
                                            return RotationTransition(
                                              child: child,
                                              turns: animation,
                                            );
                                          },
                                          child: toggleID
                                              ? Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                  size: 35.0,
                                                  key: UniqueKey(),
                                                )
                                              : Icon(
                                                  Icons.remove_circle_outline,
                                                  color: Colors.red,
                                                  size: 35.0,
                                                  key: UniqueKey(),
                                                )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(246, 38, 129, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                )
                              ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200]))),
                                child: TextField(
                                  onChanged: (value) {
                                    title = value;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Subject",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200]))),
                                child: TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 11,
                                  onChanged: (value) {
                                    desc = value;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Description",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0xFF2F3676)),
                          child: RaisedButton(
                            color: Color(0xFF2F3676),
                            onPressed: () async {
                              if (title != null &&
                                  title != "" &&
                                  desc != null &&
                                  desc != "") {
                                await submit_button_action();
                                Alert(
                                  context: context,
                                  type: AlertType.success,
                                  title: "Alright!",
                                  desc:
                                      "There are people who will help you out with this.",
                                  buttons: [
                                    DialogButton(
                                      width: 120,
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UserProfile(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ).show();
                              } else {
                                Alert(
                                  context: context,
                                  type: AlertType.error,
                                  title: "Uhm!",
                                  desc: "We need more details.please fill up.",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      width: 120,
                                    )
                                  ],
                                ).show();
                              }
                            },
                            child: Center(
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
