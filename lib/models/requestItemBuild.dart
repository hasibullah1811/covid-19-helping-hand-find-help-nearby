import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helping_hand/config/config.dart';
import 'package:helping_hand/screens/requestDetails.dart';

class buildRequestItem extends StatefulWidget {
  buildRequestItem(
      {@required this.title,
      @required this.desc,
      this.geoPoint,
      this.name,
      this.foodRelated, this.postID, this.ownerID});

  final String title;
  final String desc;
  final GeoPoint geoPoint;
  final String name;
  final bool foodRelated;
  final String postID;
  final String ownerID;

  @override
  buildRequestItemState createState() => buildRequestItemState();
}

class buildRequestItemState extends State<buildRequestItem> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: Card(
        elevation: 8.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [secondaryColor, primaryColor],
            ),
          ),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 1.0, color: Colors.white24))),
              child: widget.foodRelated
                  ? Image(
                      image: AssetImage(
                        'assets/images/grocery-bag.png',
                      ),
                      height: 30,
                      width: 30,
                    )
                  : Image(
                      image: AssetImage('assets/images/hand-icon.png'),
                      height: 30,
                      width: 30,
                    ),
            ),
            title: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: requestTitleTextStyle,
                text: widget.title,
              ),
            ), // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
            subtitle: Row(
              children: <Widget>[
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: requestdescTextStyle,
                      text: widget.desc,
                    ),
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.keyboard_arrow_right),
              color: Colors.white,
              iconSize: 30.0,
              onPressed: () {
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new RequestDetails(
                    desc: widget.desc,
                    geoPoint: widget.geoPoint,
                    title: widget.title,
                    name: widget.name,
                    ownerID: widget.ownerID,
                    postID: widget.postID,
                  ),
                );
                Navigator.of(context).push(route);
              },
            ),
          ),
        ),
      ),
    );
  }
}
