import 'dart:convert';

import 'package:helping_hand/components/progress.dart';
import 'package:helping_hand/config/config.dart';
import 'package:helping_hand/config/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helping_hand/components/myHeader.dart';
import 'package:helping_hand/components/counter.dart';
import 'package:helping_hand/screens/faqScreen.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NewsUpdateScreen extends StatefulWidget {
  @override
  _NewsUpdateScreenState createState() => _NewsUpdateScreenState();
}

class _NewsUpdateScreenState extends State<NewsUpdateScreen> {
  Map bangladeshData;
  bool showSpinner;



  // Covid - 19 Data Fetch
  String newValue = 'Bangladesh';
  Map reportData;
  //World Data
  fetchWorldWideData() async {
    http.Response response = await http.get('https://corona.lmao.ninja/v2/all');

    setState(() {
      reportData = json.decode(response.body);
    });
  }
  //Bangladesh Data
  fetchBangladeshData() async {
    http.Response response =
        await http.get('https://corona.lmao.ninja/v2/countries/bangladesh');
    setState(() {
      reportData = json.decode(response.body);
    });
  }

   //India Data
  fetchIndiaData() async {
    http.Response response =
        await http.get('https://corona.lmao.ninja/v2/countries/india');
    setState(() {
      reportData = json.decode(response.body);
    });
  }
   //USA Data
  fetchUsaData() async {
    http.Response response =
        await http.get('https://corona.lmao.ninja/v2/countries/usa');
    setState(() {
      reportData = json.decode(response.body);
    });
  }
   //China Data
  fetchChinaData() async {
    http.Response response =
        await http.get('https://corona.lmao.ninja/v2/countries/china');
    setState(() {
      reportData = json.decode(response.body);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchBangladeshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return reportData != null
        ? Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  fetchBangladeshData();
                });
              },
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    MyHeader(
                      image: "assets/images/news-update-banner.png",
                      textTop: "Do your part",
                      textBottom: "stay at home.",
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Color(0xFFE5E5E5),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                          SizedBox(width: 20),
                          Expanded(
                            child: DropdownButton(
                              isExpanded: true,
                              underline: SizedBox(),
                              icon:
                                  SvgPicture.asset("assets/icons/dropdown.svg"),
                              items: [
                                'Bangladesh',
                                'China',
                                'United States',
                                'India',
                                'WorldWide'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                newValue = value;
                                setState(() {
                                  if (value == 'Bangladesh') {
                                    fetchBangladeshData();
                                  } else if (value == 'WorldWide') {
                                    fetchWorldWideData();
                                  }else if (value == 'United States') {
                                    fetchUsaData();
                                  }else if (value == 'India') {
                                    fetchIndiaData();
                                  }else if (value == 'China') {
                                    fetchChinaData();
                                  }
                                });
                              },
                              value: newValue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
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
                                      text: "Case Update\n",
                                      style: kTitleTextstyle,
                                    ),
                                    TextSpan(
                                      text: "Updates in real time",
                                      style: TextStyle(
                                        color: kTextLightColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              RichText(
                                textAlign: TextAlign.right,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "New Cases Today\n",
                                      style: kTitleTextstyle.copyWith(
                                          fontSize: 15, color: primaryColor),
                                    ),
                                    TextSpan(
                                        text:
                                            reportData['todayCases'].toString(),
                                        style: titleTextStyle.copyWith(
                                            fontSize: 20,
                                            color: Colors.redAccent)),
                                  ],
                                ),
                              ),
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
                                  color: kInfectedColor,
                                  number: reportData['cases'],
                                  title: "Infected",
                                ),
                                Counter(
                                  color: kDeathColor,
                                  number: reportData['deaths'],
                                  title: "Deaths",
                                ),
                                Counter(
                                  color: kRecovercolor,
                                  number: reportData['recovered'],
                                  title: "Recovered",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Spread of Virus",
                                style: kTitleTextstyle,
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            padding: EdgeInsets.all(20),
                            height: 178,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 10),
                                  blurRadius: 30,
                                  color: kShadowColor,
                                ),
                              ],
                            ),
                            child: Image.asset(
                              "assets/images/corona-heatmap.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FAQPage()));
                            },
                            child: Container(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 20),
                                color: Color(0xFF035aa6),
                                elevation: 0,
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      'assets/images/faq.png',
                                      width: 50,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  title: Text(
                                    "FAQ's",
                                    style: titleTextStyle.apply(
                                        color: Colors.white,
                                        fontSizeDelta: 0.2),
                                  ),
                                  subtitle: Text(
                                    "Covid-19 & how to stop it",
                                    style: bodyTextStyle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              launch(
                                  'https://www.who.int/emergencies/diseases/novel-coronavirus-2019/advice-for-public/myth-busters');
                            },
                            child: Container(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 20),
                                color: Color(0xFF413c69),
                                elevation: 0,
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: SvgPicture.asset(
                                      'assets/images/rumors.svg',
                                      width: 50,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  title: Text(
                                    "Myth Busters",
                                    style: titleTextStyle.apply(
                                        color: Colors.white,
                                        fontSizeDelta: 0.2),
                                  ),
                                  subtitle: Text(
                                    "Don't spread rumors",
                                    style: bodyTextStyle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              launch('https://covid19responsefund.org/');
                            },
                            child: Container(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 20),
                                color: Color(0xFFffa41b),
                                elevation: 0,
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      'assets/images/donate.png',
                                      width: 50,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  title: Text(
                                    "Donate",
                                    style: titleTextStyle.apply(
                                        color: Colors.white,
                                        fontSizeDelta: 0.2),
                                  ),
                                  subtitle: Text(
                                    "Help fight corona virus",
                                    style: bodyTextStyle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : circularProgress();
  }
}
