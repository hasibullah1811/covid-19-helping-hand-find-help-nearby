import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helping_hand/models/chat_head_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' ;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helping_hand/models/chat_head_model.dart';
import 'package:helping_hand/models/chat_head_model_helper.dart';

class Messages extends StatefulWidget {


  @override
  _itemPageState createState() => _itemPageState();
}

class _itemPageState extends State<Messages> {

  String me;

  Future<void> get_me() async{
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

    return Scaffold(
        backgroundColor: Color(0xF21BFBD),
        appBar: AppBar(
          elevation: 0.0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                  Color(0xFF2F3676),
                  Color(0xFF2F3676),
                  Color(0xFF2F3676)
                ])),
          ),
          title: Text(
            'Messages',
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                Color(0xFF2F3676),
                Color(0xFF2F3676),
                Colors.pink[900]
              ])),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15.0, left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //IconButton(icon: Icon(Icons.menu),color: Colors.white, onPressed: (){}
                    //),
                    Container(
                        width: 125.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ////////////////////////////Something Belongs here/////////////////////////////////////
                          ],
                        ))
                  ],
                ),
              ),
              SizedBox(height: 75.0),
              Container(
                height: MediaQuery.of(context).size.height - 185.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.only(topLeft: Radius.circular(75.0)),
                ),
                child: ListView(
                  primary: false,
                  padding: EdgeInsets.only(left: 0.0, right: 0.0),
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 45.0),
                        child: Container(
                            height: MediaQuery.of(context).size.height - 300.0,
                            child: StreamBuilder(
                                stream: Firestore.instance
                                    .collection('messages')//BWxWdDEPcKPqHgzGxtBhvvw8vg93
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return const Text('Loading...');
                                  return ListView.builder(
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder: (context, index) {
                                         if(snapshot.data.documents[index]['helperID']==me || snapshot.data.documents[index]['postOwnerID']==me){
                                           return buildChatHeads(postID: snapshot.data.documents[index]['postID'],
                                                   helperID: snapshot.data.documents[index]['helperID'],
                                                   postOwnerID: snapshot.data.documents[index]['postOwnerID'],
                                                   me: me,);

                                         }
                                         return Container(height: 0.0, width: 0.0,);
                                    },
                                    //BuildFoodItem(imgPath:'assets/plate1.png', foodName: 'Spring bowl', price: '\$22.00',),
                                  );
                                }))),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

