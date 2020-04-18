import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:helping_hand/components/app_drawer.dart';
import 'package:helping_hand/components/counter.dart';
import 'package:helping_hand/config/config.dart';
import 'package:helping_hand/config/constant.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: Container(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            CustomTitleBar(),
            NameAndUsername(),
            Statusbar(),
            HotList(),
            RequestSendAssist(),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: primaryColor,
        backgroundColor: secondaryColor,
        buttonBackgroundColor: Colors.white70,
        height: 50,
        items: <Widget>[
          Icon(
            Icons.feedback,
            size: 25,
            color: Colors.white,
          ),
          Icon(
            Icons.account_circle,
            size: 25,
            color: Colors.white,
          ),
          Icon(
            Icons.face,
            size: 25,
            color: Colors.white,
          ),
        ],
        index: 1,
        onTap: (index) {
          // print(g['username']);
        },
      ),
    );
  }
}

class CustomTitleBar extends StatelessWidget {
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
                'assets/images/me.jpg',
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

class NameAndUsername extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30, left: 30, right: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Hasibullah Hasib",
              style: titleTextStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "hasib_ullah",
              style: primaryBodyTextStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Bio: Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print,",
              style: bodyTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class Statusbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 16, right: 16),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Helping Hand Reputation\n",
                              style: kTitleTextstyle,
                            ),
                            TextSpan(
                              text: "Newest updated april 18",
                              style: TextStyle(
                                color: kTextLightColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 30,
                          color: kShadowColor,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Counter(
                          color: secondaryColor,
                          number: 1046,
                          title: "Total Points",
                        ),
                        Counter(
                          color: kRecovercolor,
                          number: 87,
                          title: "People helped",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HotList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0, bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "What are you upto today?",
            style: kTitleTextstyle,
          ),
        ],
      ),
    );
  }
}

class RequestSendAssist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              //Route to request form page
            },
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
                  style: titleTextStyle.apply(
                      color: Colors.white, fontSizeDelta: 0.2),
                ),
                subtitle: Text(
                  "Let your neighbours help",
                  style: bodyTextStyle,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // Route to people that needs help page
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              color: primaryColor,
              elevation: 0,
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/help-others.png',
                    width: 50,
                    fit: BoxFit.contain,
                  ),
                ),
                title: Text(
                  'Help Others',
                  style: titleTextStyle.apply(
                      color: Colors.white, fontSizeDelta: 0.2),
                ),
                subtitle: Text(
                  "See who needs your help",
                  style: bodyTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
