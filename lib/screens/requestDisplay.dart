import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' ;
import 'package:helping_hand/models/requestItemBuild.dart';

class requestDisplay extends StatefulWidget {
  @override
  _itemPageState createState() => _itemPageState();
}


class _itemPageState extends State<requestDisplay> {
  
  var request_list = new List();
  
  Future<void> gather_requests() async{
    final CollectionReference requests = Firestore.instance.collection('helpRequests');

    await for(var snapshot in requests.snapshots()){
      for(var user in snapshot.documents){
        final CollectionReference userPosts = Firestore.instance.collection('helpRequests/'+user.documentID+'/userPosts');
        await for(var snapshot in userPosts.snapshots()){
            for(var userpost in snapshot.documents){
                setState(() {
                  request_list.add(userpost.data);
                });
            }
           break;
        }
      }
      break;
    }

    print(request_list[0]['photUrl']);
  }
  
  @override
  void initState() {
    gather_requests();
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
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                Colors.pink[900],
                Colors.pink[900],
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
              SizedBox(height: 25.0),
              Padding(
                padding: EdgeInsets.only(left: 40.0),
                child: Column(
                  children: <Widget>[
                    Text('Add or Remove Item',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0)),
                    SizedBox(width: 10.0),
                    Text('from your Daily Needs',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontSize: 20.0))
                  ],
                ),
              ),
              SizedBox(height: 40.0),
              Container(
                height: MediaQuery.of(context).size.height-200,
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
                            height: MediaQuery.of(context).size.height,
                            child: ListView.builder(
                                  itemCount: request_list.length,
                              itemBuilder: (context, index){
                                  return buildRequestItem(imgPath: request_list[index]['photUrl'],name: request_list[index]['name'],sub: request_list[index]['title']);
                              },
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

