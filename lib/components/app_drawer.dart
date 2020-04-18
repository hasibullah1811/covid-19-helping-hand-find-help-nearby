import 'package:flutter/material.dart';
import 'package:helping_hand/config/config.dart';
import 'package:helping_hand/config/constant.dart';

class AppDrawer extends StatelessWidget {

  final Map<String, dynamic> info;

  const AppDrawer({Key key, this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(info['displayName']),
            accountEmail: Text(info['email']),
            currentAccountPicture: GestureDetector(
              child: CircleAvatar(
                backgroundImage: NetworkImage(info['photUrl']),
                backgroundColor: secondaryColor,
              ),
            ),
            decoration: BoxDecoration(
              color: kPrimaryColor,
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text(
                'Home',
                style: kTitleTextstyle,
              ),
              leading: Icon(Icons.home),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text(
                'My Account',
                style: kTitleTextstyle,
              ),
              leading: Icon(Icons.person),
            ),
          ),
          InkWell(
            onTap: () {
              
            },
            child: ListTile(
              title: Text(
                'Sign Out',
                style: kTitleTextstyle,
              ),
              leading: Icon(Icons.exit_to_app),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text(
                'Settings',
                style: kTitleTextstyle,
              ),
              leading: Icon(Icons.settings, color: secondaryColor,),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text(
                'About',
                style: kTitleTextstyle,
              ),
              leading: Icon(
                Icons.help,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
