import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helping_hand/config/config.dart';
import 'package:helping_hand/screens/chat_screen.dart';
import 'package:helping_hand/models/user_model_for_messages.dart';



class buildChatHeads extends StatefulWidget {

  buildChatHeads({@required this.postID,@required this.helperID,@required this.postOwnerID, this.me});

  final String postID;
  final String helperID;
  final String postOwnerID;
  final String me;




  @override
  buildChatHeadsState createState() =>buildChatHeadsState();
}

class buildChatHeadsState extends State<buildChatHeads> {

  String otherPersonphotUrl = 'https://firebasestorage.googleapis.com/v0/b/helping-hand-76970.appspot.com/o/default-user-img.png?alt=media&token=d96df74f-5b3b-4f08-86f8-d1a913459e07';
  String otherPersonName = 'loading..';
  String lastMessage = 'loading..';
  String lastMessageSender = 'loading..';

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
           break;
         }
       }
       break;
    }

    final CollectionReference texts = Firestore.instance.collection('messages/${widget.helperID}_${widget.postID}/texts');

    await for(var snapshot in texts.orderBy('time', descending: false).snapshots()){
      for(var text in snapshot.documents){
        setState(() {
          lastMessage = text.data['text'];
          lastMessageSender = text.data['sender_name'];
        });
      }
      break;
    }

    print(otherPersonName);
    print(otherPersonphotUrl);
    print(lastMessage);
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
            onTap: () async{
              final CollectionReference get_post = Firestore.instance.collection('helpRequests/${widget.postOwnerID}_${widget.postID}/userPost');

              Map<String, dynamic> post_info;
              await for(var snapshot in get_post.snapshots()){
                for(var post in snapshot.documents){
                  setState(() {
                    post_info = post.data;
                  });
                }
                break;
              }

              var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new ChatScreen(theOtherPerson:User( id: post_info['ownerID'],imageUrl: post_info['photUrl'] ,name: post_info ['name']), messageField: 'messages/${widget.helperID}_${widget.postID}',)
              );
              Navigator.of(context).push(route);
            },
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
                                    text: lastMessageSender+' : '+lastMessage,
                                  ),
                                ),
                              ]
                          )
                        ]
                    )
                ),
                //SizedBox(width: 10.0),
              ],
            )
        ));
  }
}
