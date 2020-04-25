import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helping_hand/config/config.dart';




class buildChatHeadsForHelper extends StatefulWidget {

  buildChatHeadsForHelper({@required this.postID,@required this.helperID,@required this.postOwnerID, this.me});

  final String postID;
  final String helperID;
  final String postOwnerID;
  final String me;




  @override
  buildChatHeadsForHelperState createState() =>buildChatHeadsForHelperState();
}

class buildChatHeadsForHelperState extends State<buildChatHeadsForHelper> {

  String otherPersonphotUrl;
  String otherPersonName;
  String lastMessage;

  Future<void> setDatas() async{
    final CollectionReference perticipents = Firestore.instance.collection('messages/${widget.helperID}_${widget.postID}/perticipents');

    await for(var snapshot in perticipents.snapshots()){
      for(var otherPerson in snapshot.documents){
        if(otherPerson.data['id']!=widget.me){
          setState(() {
            otherPersonName = otherPerson.data['name'];
            if(otherPerson.data['photUrl']!="" && otherPerson.data['photUrl']!=null){
              otherPersonphotUrl = otherPerson.data['photUrl'];
            }else{
              otherPersonphotUrl = 'https://firebasestorage.googleapis.com/v0/b/helping-hand-76970.appspot.com/o/default-user-img.png?alt=media&token=d96df74f-5b3b-4f08-86f8-d1a913459e07';
            }
          });
          print(otherPersonName);
          print(otherPersonphotUrl);
          break;
        }
      }
      break;
    }


  }

  @override
  void initState() {
    setDatas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: InkWell(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: Row(
                        children: [
                          Hero(
                              tag: widget.postID,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  otherPersonphotUrl,
                                  height: 90,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                              )
                          ),
                          SizedBox(width: 10.0),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                Text(
                                    otherPersonName,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold
                                    )
                                ),
                                RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    style: TextStyle(
                                        fontSize: 10.00,
                                        color: Colors.black
                                    ),
                                    text: 'widget.helperID',
                                  ),
                                ),
                              ]
                          )
                        ]
                    )
                ),
                //SizedBox(width: 10.0),
                RaisedButton(
                  color: Colors.pink[900],
                  padding: EdgeInsets.all(0.00),
                  onPressed: () {
                    setDatas();
                  },
                  child: Center(
                    child: Text(
                      'Thanks',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )
        ));
  }
}
