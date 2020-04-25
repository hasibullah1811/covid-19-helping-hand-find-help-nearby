import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helping_hand/components/progress.dart';
import 'package:helping_hand/config/config.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';
import 'chat_screen.dart';
import 'package:helping_hand/models/user_model_for_messages.dart';

class RequestDetails extends StatefulWidget {
  final String title;
  final String desc;
  final GeoPoint geoPoint;
  final String name;
  final String postID;
  final String ownerID;

  RequestDetails(
      {this.title,
      this.desc,
      this.geoPoint,
      this.name,
      this.postID,
      this.ownerID});
  @override
  _RequestDetailsState createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {
  GoogleMapController mapController;

  GoogleMapController myMapController;
  final Set<Marker> _markers = new Set();
  bool showSpinner = false;
  // static const LatLng _mainLocation = const LatLng(23.861102, 90.366024);
  bool allDataPassed = false;

  Future<void> startChat() async {
    final auth = FirebaseAuth.instance;
    final FirebaseUser helper = await auth.currentUser();
    final helperID = helper.uid;

    final CollectionReference messages =
        Firestore.instance.collection('messages');

    await messages.document('${helperID}_${widget.postID}').setData({
      'postID': widget.postID,
      'postOwnerID': widget.ownerID,
      'helperID': helperID,
      'postName' : widget.title
    }, merge: true);

    final CollectionReference perticipents = Firestore.instance
        .collection('messages/${helperID}_${widget.postID}/perticipents');

    Map<String, dynamic> helper_info;
    Map<String, dynamic> post_info;

    final DocumentReference get_helper =
        Firestore.instance.document('users/${helperID}');
    final CollectionReference get_post = Firestore.instance
        .collection('helpRequests/${widget.ownerID}_${widget.postID}/userPost');

    await for (var snapshot in get_helper.snapshots()) {
      setState(() {
        helper_info = snapshot.data;
      });
      break;
    }

    await for (var snapshot in get_post.snapshots()) {
      for (var post in snapshot.documents) {
        setState(() {
          post_info = post.data;
        });
      }
      break;
    }

    await perticipents.document(helperID).setData({
      'id': helperID,
      'name': helper_info['displayName'],
      'photUrl': helper_info['photUrl'],
      'position': 'helper',
      'typing': false
    }, merge: true);

    await perticipents.document(widget.ownerID).setData({
      'id': widget.ownerID,
      'name': post_info['name'],
      'photUrl': post_info['photUrl'],
      'position': 'postOwner',
      'typing': false
    }, merge: true);

    setState(() {
      showSpinner = false;
    });
    var route = new MaterialPageRoute(
        builder: (BuildContext context) => new ChatScreen(
              theOtherPerson: User(
                  id: post_info['ownerID'],
                  imageUrl: post_info['photUrl'],
                  name: post_info['name']),
              messageField: 'messages/${helperID}_${widget.postID}',
            ));
    Navigator.of(context).push(route);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Maintain proper preventive measures while helping',
                      style: requestTitleTextStyle.apply(
                          color: Colors.black, fontSizeFactor: 1.2),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Center(
                  child: Image.asset(
                    "assets/images/preventive-caution.png",
                    height: 200,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 26,
                ),
                Text(
                  widget.title,
                  style: titleTextStyle.apply(fontSizeFactor: 0.9),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  widget.desc,
                  style: bodyTextStyle.apply(color: Colors.black),
                ),
                SizedBox(
                  height: 24,
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withAlpha(60),
                        blurRadius: 5.0, // soften the shadow
                        spreadRadius: 3.0, //extend the shadow
                        offset: Offset(
                          5.0, // Move to right 10  horizontally
                          5.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                  ),
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    trafficEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          widget.geoPoint.latitude, widget.geoPoint.longitude),
                      zoom: 14.0,
                    ),
                    markers: this.myMarker(),
                    mapType: MapType.normal,
                    onMapCreated: (controller) {
                      setState(() {
                        myMapController = controller;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "If the request appears to be very ",
                          style: bodyTextStyle,
                        ),
                        TextSpan(
                          text: "critical ",
                          style: bodyTextStyle.copyWith(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "you can call ",
                          style: bodyTextStyle,
                        ),
                        TextSpan(
                          text: "999 ",
                          style: bodyTextStyle.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              "to send help to the requested person's location ",
                          style: bodyTextStyle,
                        ),
                        TextSpan(
                          text:
                              "\nGet the coordinates by tapping on the Marker",
                          style: bodyTextStyle.apply(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 22,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 40.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      showSpinner = true;
                                    });
                                    startChat();
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            130,
                                    child: Text(
                                      "Contact Now",
                                      style: buttonTextStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    launch("tel:999");
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            130,
                                    child: Text(
                                      "Call 999",
                                      style: buttonTextStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Set<Marker> myMarker() {
    LatLng markerIdPosition =
        LatLng(widget.geoPoint.latitude, widget.geoPoint.longitude);
    double lattitude = widget.geoPoint.latitude;
    double longitude = widget.geoPoint.longitude;
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(widget.geoPoint.toString()),
        position: markerIdPosition,
        infoWindow: InfoWindow(
          title: 'Send help here ($lattitude, $longitude)',
          snippet: 'Requested from this location ',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });

    return _markers;
  }
}
