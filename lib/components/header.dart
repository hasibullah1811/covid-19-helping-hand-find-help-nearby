
import 'package:flutter/material.dart';

AppBar header(context, {bool isAppTitle = false, String titleText, removeBackButton = false}) {
  return AppBar(
    automaticallyImplyLeading: removeBackButton ? false : true,
    title: Text(
      isAppTitle ? 'Helping Hand' : titleText,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitle ? 'Nunito' : '',
        fontSize: isAppTitle ? 50.0 : 20.0,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).primaryColor,
  );
}
