import 'package:flutter/services.dart';
import 'package:helping_hand/components/progress.dart';
import 'package:helping_hand/config/FadeAnimation.dart';
import 'package:helping_hand/config/config.dart';
import 'package:helping_hand/config/constant.dart';
import 'package:flutter/material.dart';

import 'package:helping_hand/components/myHeader.dart';

import 'package:helping_hand/screens/userProfileScreen.dart';

class NewsUpdateScreen extends StatefulWidget {
  @override
  _NewsUpdateScreenState createState() => _NewsUpdateScreenState();
}

class _NewsUpdateScreenState extends State<NewsUpdateScreen>
    with AutomaticKeepAliveClientMixin {
  bool showSpinner;
  bool get wantKeepAlive => true;

  Map reportData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //this little code down here turns off auto rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FadeAnimation(
                0.5,
                MyHeader(
                  image: "assets/images/2.png",
                  textTop: "",
                  textBottom: "",
                ),
              ),
              FadeAnimation(
                1.1,
                Container(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    "Do your part, #StayHome",
                    style: titleTextStyle.copyWith(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeAnimation(
                1.4,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Request For Help\n",
                              style: kTitleTextstyle,
                            ),
                            TextSpan(
                              text: "Or help the one in need",
                              style: TextStyle(
                                color: kTextLightColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              RequestSendAssist(),
            ],
          ),
        ),
      ),
    );
  }
}
