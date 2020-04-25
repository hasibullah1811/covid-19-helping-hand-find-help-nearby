import 'package:flutter/material.dart';
import 'package:helping_hand/models/message_model.dart';
import 'package:helping_hand/models/user_model_for_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helping_hand/screens/requestDisplay.dart';

class ChatScreen extends StatefulWidget {
  final User theOtherPerson;
  final String messageField;

  ChatScreen({this.theOtherPerson, this.messageField});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  String text;
  String me;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    get_me();
    super.initState();
  }


  Future<void> get_me() async{
    final auth = FirebaseAuth.instance;
    final FirebaseUser sender = await auth.currentUser();
    final senderID = sender.uid;

    setState(() {
      me = senderID;
    });
  }

  _buildMessage(Message message, bool isMe) {
    final Container msg = Container(
      margin: isMe
          ? EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
        left: 80.0,
      )
          : EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
      ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMe ? Theme.of(context).accentColor : Color(0xFFFFEFEE),
        borderRadius: isMe
            ? BorderRadius.only(
          topLeft: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
        )
            : BorderRadius.only(
          topRight: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
           '${ message.time.toDate().day}/${ message.time.toDate().month}/${ message.time.toDate().year}',
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 10.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            message.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
        IconButton(
          icon: message.isLiked
              ? Icon(Icons.favorite)
              : Icon(Icons.favorite_border),
          iconSize: 30.0,
          color: message.isLiked
              ? Theme.of(context).primaryColor
              : Colors.blueGrey,
          onPressed: () async{
            final CollectionReference messageFieldCollection =  Firestore.instance.collection(widget.messageField+'/texts');

            await messageFieldCollection.document(message.textID).setData({
              'isLiked': true
            }, merge: true);
          },
        )
      ],
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.subdirectory_arrow_right),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                text = value;
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              final auth = FirebaseAuth.instance;
              final FirebaseUser sender = await auth.currentUser();
              final senderID = sender.uid;

              final CollectionReference messageFieldCollection =  Firestore.instance.collection(widget.messageField+'/texts');

              final DocumentReference senderData =  Firestore.instance.document(widget.messageField+'/perticipents/'+senderID);


              Map<String, dynamic> sender_info;

              await for(var snapshot in senderData.snapshots()){
                setState(() {
                  sender_info = snapshot.data;
                });
                break;
              }

                await messageFieldCollection.document().setData({
                  'sender_id' : senderID,
                  'sender_photUrl' : sender_info['photUrl'],
                  'sender_name' : sender_info['name'],
                  'time' : DateTime.now(),
                  'text' : text,
                  'isLiked': false,
                  'unread' : true,
                }, merge: true);

              _scrollController.animateTo(
                0.0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          widget.theOtherPerson.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: StreamBuilder(
                    stream: Firestore.instance.collection(widget.messageField+'/texts').orderBy('time',descending: true).snapshots(),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                            shrinkWrap: true,
                          padding: EdgeInsets.only(top: 15.0),
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Message message = new Message(
                                sender: User(id: snapshot.data.documents[index]['sender_id'],
                                  imageUrl: snapshot.data.documents[index]['sender_photUrl'],
                                  name: snapshot.data.documents[index]['sender_name'],
                                ),
                                time: snapshot.data.documents[index]['time'],
                                text: snapshot.data.documents[index]['text'],
                                isLiked: snapshot.data.documents[index]['isLiked'],
                                unread: snapshot.data.documents[index]['unread'],
                                textID: snapshot.data.documents[index].documentID);

                            final bool isMe = snapshot.data.documents[index]['sender_id']==me;
                            return _buildMessage(message, isMe);
                          },
                        );
                      }
                      return Container(height: 0.0, width: 0.0,);
                    },
                  ),
                ),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}