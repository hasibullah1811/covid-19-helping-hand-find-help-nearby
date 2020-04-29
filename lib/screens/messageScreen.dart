import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:helping_hand/config/FadeAnimation.dart';
import 'package:helping_hand/models/chat_head_model.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';

final usersRef = Firestore.instance.collection('userRequests');
final auth = FirebaseAuth.instance;

bool showSpinner = false;

class MessageScreen extends StatefulWidget {
  @override
  _itemPageState createState() => _itemPageState();
}

class _itemPageState extends State<MessageScreen> {
  String me;

  Future<void> get_me() async {
    final auth = FirebaseAuth.instance;
    final FirebaseUser sender = await auth.currentUser();
    final senderID = sender.uid;

    setState(() {
      me = senderID;
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
          title: Text(
            "Recent Messages",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0.0,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            //on refresh action
            get_me();
          },
          child: Container(
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection('messages') //BWxWdDEPcKPqHgzGxtBhvvw8vg93
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text('Loading...');
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data.documents[index]['helperID'] == me ||
                          snapshot.data.documents[index]['postOwnerID'] == me) {
                        return FadeAnimation(
                          1,
                          buildChatHeads(
                            postID: snapshot.data.documents[index]['postID'],
                            helperID: snapshot.data.documents[index]
                                ['helperID'],
                            postOwnerID: snapshot.data.documents[index]
                                ['postOwnerID'],
                            me: me,
                          ),
                        );
                      }
                      return Container(
                        height: 0.0,
                        width: 0.0,
                      );
                    },
                    //BuildFoodItem(imgPath:'assets/plate1.png', foodName: 'Spring bowl', price: '\$22.00',),
                  );
                }),
          ),
        ),
      ),
    );
  }

  bool get wantKeepAlive => true;
}
