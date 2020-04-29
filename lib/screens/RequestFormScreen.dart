import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:helping_hand/components/myHeader.dart';
import 'package:helping_hand/config/FadeAnimation.dart';
import 'package:helping_hand/config/config.dart';
import 'package:helping_hand/screens/userProfileScreen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RequestFormScreen extends StatefulWidget {
  @override
  _RequestFormScreenState createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  bool showSpinner = false;
  final auth = FirebaseAuth.instance;
  String title;
  String desc;

  bool toggleID = false;
  bool foodRelated = false;

  toggleButton_for_ID() {
    setState(() {
      toggleID = !toggleID;
    });
  }

  toggleButton_for_food() {
    setState(() {
      foodRelated = !foodRelated;
      print(foodRelated);
    });
  }

  @override
  Widget build(BuildContext context) {
    //this little code down here turns off auto rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  MyHeader(
                    image: 'assets/images/request-now.png',
                    textTop: 'Need Help',
                    textBottom: 'With Something?',
                  ),
                  FadeAnimation(
                    1,
                    Positioned(
                      top: 40,
                      left: 15,
                      child: Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              FadeAnimation(
                1.1,
                Container(
                  padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Ruquest Assist Stating your need',
                        style: titleTextStyle.copyWith(fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "We'll use your current location so that your nearby people can help you",
                          style: bodyTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              FadeAnimation(
                1.2,
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 16),
                        child: Text(
                          'Hide my name',
                          style: titleTextStyle.copyWith(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, right: 16),
                        child: AnimatedContainer(
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
                                  onTap: toggleButton_for_ID,
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
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FadeAnimation(
                1.3,
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 8),
                        child: Text(
                          'Food Related',
                          style: titleTextStyle.copyWith(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0, top: 8),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          height: 40.0,
                          width: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: foodRelated
                                  ? Colors.greenAccent[100]
                                  : Colors.redAccent[100].withOpacity(0.5)),
                          child: Stack(
                            children: <Widget>[
                              AnimatedPositioned(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeIn,
                                top: 3.0,
                                left: foodRelated ? 30.0 : 0.0,
                                right: foodRelated ? 0.0 : 30.0,
                                child: InkWell(
                                  onTap: toggleButton_for_food,
                                  child: AnimatedSwitcher(
                                      duration: Duration(milliseconds: 200),
                                      transitionBuilder: (Widget child,
                                          Animation<double> animation) {
                                        return RotationTransition(
                                          child: child,
                                          turns: animation,
                                        );
                                      },
                                      child: foodRelated
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
                      ),
                    ],
                  ),
                ),
              ),
              FadeAnimation(
                1.4,
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[200]))),
                          child: TextField(
                            maxLength: 40,
                            onChanged: (value) {
                              title = value;
                            },
                            decoration: InputDecoration(
                              hintText: "What do you need help with?",
                              hintStyle: bodyTextStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[200]))),
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLength: 350,
                            maxLines: 11,
                            onChanged: (value) {
                              desc = value;
                            },
                            decoration: InputDecoration(
                              hintText: "Describe your problem...",
                              hintStyle: bodyTextStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              FadeAnimation(
                1.5,
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        showSpinner = true;
                      });
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
                    child: FadeAnimation(
                      1.6,
                      Container(
                        decoration: BoxDecoration(
                          color: buttonBgColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        width: MediaQuery.of(context).size.width,
                        margin:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                        child: Center(
                          child: Text("Submit", style: buttonTextStyle),
                        ),
                      ),
                    ),
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
                        TextSpan(text: "By tapping submit, you agree to "),
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
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
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

    final CollectionReference helpRequests =
        Firestore.instance.collection('helpRequests');

    var rnd = new Random();
    var next = rnd.nextDouble() * 1000000;
    while (next < 100000000) {
      next *= 10;
    }

    await helpRequests
        .document(userID + '_' + next.toInt().toString())
        .setData({'userID': userID, 'postID': next.toInt()});

    final CollectionReference user_posts = Firestore.instance.collection(
        'helpRequests/' + userID + '_' + next.toInt().toString() + '/userPost');
    DocumentReference post_id = await user_posts.add({
      'timestamp': DateTime.now(),
      'location': new GeoPoint(position.latitude, position.longitude),
      'title': title,
      'description': desc,
      'ownerID': userID
    });

    //regarding user's identity
    if (toggleID) {
      await user_posts.document(post_id.documentID).setData({
        'name': 'N/A',
        'postID': next.toInt().toString(),
        'photUrl':
            'https://firebasestorage.googleapis.com/v0/b/helping-hand-76970.appspot.com/o/default-user-img.png?alt=media&token=d96df74f-5b3b-4f08-86f8-d1a913459e07'
      }, merge: true);
    } else if (!toggleID) {
      await user_posts.document(post_id.documentID).setData({
        'name': user_info_map['displayName'],
        'postID': next.toInt().toString(),
        'photUrl': user_info_map['photUrl']
      }, merge: true);
    }

    //regarding food
    if (foodRelated) {
      await user_posts
          .document(post_id.documentID)
          .setData({'foodRelated': true}, merge: true);
    } else if (!foodRelated) {
      await user_posts
          .document(post_id.documentID)
          .setData({'foodRelated': false}, merge: true);
    }
  }
}
