import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:helping_hand/components/progress.dart';
import 'package:helping_hand/config/config.dart';
import 'package:helping_hand/models/myRequestItemBuild.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final usersRef = Firestore.instance.collection('userRequests');
final auth = FirebaseAuth.instance;

bool showSpinner = false;

class MyRequestDisplay extends StatefulWidget {
  @override
  _MyRequestDisplayState createState() => _MyRequestDisplayState();
}

class _MyRequestDisplayState extends State<MyRequestDisplay> {
  String me;
  //bool get wantKeepAlive => true;

  Future<void> get_me() async {
    final auth = FirebaseAuth.instance;
    final FirebaseUser currentUser = await auth.currentUser();
    final currentUserUID = currentUser.uid;

    setState(() {
      me = currentUserUID;
    });
  }

  @override
  void initState() {
    get_me();
    super.initState();
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: primaryColor,
          title: Text(
            "My requests",
            style: requestTitleTextStyle,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            //on refresh action
            get_me();
          },
          child: Container(
            child: StreamBuilder(
                stream:
                    Firestore.instance.collection('helpRequests').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('loading...');
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot userID =
                              snapshot.data.documents[index];
                          return FutureBuilder(
                            future: Firestore.instance
                                .collection(
                                    'helpRequests/${userID['userID']}_${userID['postID']}/userPost')
                                .getDocuments(),
                            builder:
                                (BuildContext context, AsyncSnapshot snap) {
                              if (!snap.hasData) {
                                return circularProgress();
                              }
                              if (snapshot.hasData && snapshot.data != null) {
                                //setState(() {});
                                if (snap.data.documents
                                        .toList()[0]
                                        .data['ownerID'] ==
                                    me) {
                                  return buildMyRequestItem(
                                    title: snap.data.documents
                                        .toList()[0]
                                        .data['title']
                                        .toString(),
                                    desc: snap.data.documents
                                        .toList()[0]
                                        .data['description']
                                        .toString(),
                                    geoPoint: snap.data.documents
                                        .toList()[0]
                                        .data['location'],
                                    name: snap.data.documents
                                        .toList()[0]
                                        .data['name']
                                        .toString(),
                                    foodRelated: snap.data.documents
                                        .toList()[0]
                                        .data['foodRelated'],
                                    postID: snap.data.documents
                                        .toList()[0]
                                        .data['postID'],
                                    ownerID: snap.data.documents
                                        .toList()[0]
                                        .data['ownerID'],
                                  );
                                }
                              }
                              return Container();
                            },
                          );
                        });
                  }
                }),
          ),
        ),
      ),
    );
  }
}
