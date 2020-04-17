import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'request_form.dart';
import 'loginScreen.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Map<String, dynamic> g = {
    'displayName' : 'N/A',
    'photUrl' : 'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg',
    'points' : 0,
    'username' : 'N/A',
  };

  Future<void> get_user_info() async {
    final auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    final userID = user.uid;
    final DocumentReference users = Firestore.instance.document('users/'+userID);
    await for (var snapshot in users.snapshots()) {
      setState(() {
        g = snapshot.data;
      });
    }
  }

  Future<void> signout() async {
    final auth = FirebaseAuth.instance;
    auth.signOut();
    var route = new MaterialPageRoute(
      builder: (BuildContext context) =>
      new LoginScreen(),
    );
    Navigator.of(context).push(route);
  }


  @override
  void initState() {
    get_user_info();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //this little code down here turns off auto rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return new Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                Color(0xFF2F3676),
                Color(0xFF2F3676),
              ])),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.message),
            iconSize: 30.0,
            onPressed: () {
              setState(() {
                //action
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            iconSize: 30.0,
            onPressed: () {
              setState(() {
                //action
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.info),
            iconSize: 30.0,
            onPressed: () {
              setState(() {
                //action
                signout();
              });
            },
          )
        ],
      ),
      body: new Stack(
        children: <Widget>[
          ClipPath(
            child: Container(color: Color(0xFF2F3676)),
            clipper: getClipper(),
          ),
          Positioned(
              width: 350.0,
              top: MediaQuery.of(context).size.height / 10,
              child: Column(
                children: <Widget>[
                  Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          image: DecorationImage(
                              image: NetworkImage(
                                  g['photUrl']),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(75.0)),
                          boxShadow: [
                            BoxShadow(blurRadius: 7.0, color: Colors.black)
                          ])),
                  SizedBox(height: 30.0),
                  Text(
                    g['displayName'],
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                  Text(
                    g['username'],
                    style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Montserrat'),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    'POINTS: '+g['points'].toString(),
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                  SizedBox(height: 50.0),
                  Container(
                      height: 50.0,
                      width: 150.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(30.0),
                        shadowColor: Colors.redAccent,
                        color: Colors.red,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {
                            var route = new MaterialPageRoute(
                              builder: (BuildContext context) =>
                              new request_form(),
                            );
                            Navigator.of(context).push(route);
                          },
                          child: Center(
                            child: Text(
                              'I need help!',
                              style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ))
                ],
              ))
        ],
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
          print(g['username']);
        },
      ),);
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9-50);
    path.lineTo(size.width + 125, -50);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}