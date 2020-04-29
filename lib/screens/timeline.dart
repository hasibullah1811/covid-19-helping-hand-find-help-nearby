import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helping_hand/config/config.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class TimelineScreen extends StatefulWidget {
  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    //this little code down here turns off auto rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            SafeArea(
              child: CustomTitleBar(
                img: 'assets/images/me.jpg',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30, left: 5, right: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text(
                      "Find who needs your help",
                      style: titleTextStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text(
                      "Real time updates of people that requests for help",
                      style: primaryBodyTextStyle,
                    ),
                  ),
                  Divider(),
                  RequestListTile(),
                  RequestListTile(),
                  RequestListTile(),
                  RequestListTile(),
                  RequestListTile(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RequestListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        color: secondaryColor,
        elevation: 0,
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/help.png',
              width: 50,
              fit: BoxFit.contain,
            ),
          ),
          title: Text(
            'Request Assist',
            style:
                titleTextStyle.apply(color: Colors.white, fontSizeDelta: 0.2),
          ),
          subtitle: Text(
            "Let your neighbours help",
            style: bodyTextStyle,
          ),
        ),
      ),
    );
  }
}

class CustomTitleBar extends StatelessWidget {
  final String img;

  const CustomTitleBar({Key key, this.img}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              iconSize: 35.0,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                img,
                height: 60,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
