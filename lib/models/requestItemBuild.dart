import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helping_hand/config/config.dart';

class buildRequestItem extends StatefulWidget {
  buildRequestItem({@required this.title, @required this.desc});

  final String title;
  final String desc;

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
          decoration: BoxDecoration(color: primaryColor),
          child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(width: 1.0, color: Colors.white24))),
                child: Image(
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
              trailing: Icon(Icons.keyboard_arrow_right,
                  color: Colors.white, size: 30.0)),
        ),
      ),
    );
  }
}
