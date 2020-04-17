import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart' ;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class request_form extends StatefulWidget {
  @override
  _request_formState createState() => _request_formState();
}

class _request_formState extends State<request_form> {
  final auth = FirebaseAuth.instance;
  String email;
  String password;
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
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Color(0xFF2F3676),
                  Color(0xFF2F3676),
                ]
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30,),
            Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Request Help!", style: TextStyle(color: Colors.white, fontSize: 40)),
                  ],
                )
            ),
            SizedBox(height: 10,),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20,),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(
                              color: Color.fromRGBO(246, 38, 129, .3),
                              blurRadius: 20,
                              offset: Offset(0,10),
                            )]
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding : EdgeInsets.all(10),
                              decoration:  BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[200]))
                              ),
                              child: TextField(
                                onChanged: (value){
                                  email = value;
                                },
                                decoration: InputDecoration(
                                  hintText: "Subject",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              padding : EdgeInsets.all(10),
                              decoration:  BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[200]))
                              ),
                                child: TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 8,
                                  onChanged: (value) {
                                    password = value;
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
                      SizedBox(height: 40,),
                      Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color:  Color(0xFF2F3676)
                        ),
                        child: RaisedButton(
                          color:  Color(0xFF2F3676),
                          onPressed: ()async {

                          },
                          child: Center(
                            child: Text("Submit", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                          ),
                        ),

                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
        bottomNavigationBar: CurvedNavigationBar(
          color: Color(0xFF2F3676),
          backgroundColor: Color(0xFFFFFFFF),
          buttonBackgroundColor: Color(0xFFFFFFFF),
          height: 50,
          items: <Widget>[
            Icon(Icons.feedback, size: 25, color: Colors.black,),
            Icon(Icons.account_circle, size: 25, color: Colors.black,),
            Icon(Icons.face, size: 25, color: Colors.black,),
          ],
          index: 1,
          onTap: (index){

          },
        ));
  }
}

