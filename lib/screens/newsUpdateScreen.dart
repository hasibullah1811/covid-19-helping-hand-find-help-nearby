import 'dart:convert';

import 'package:helping_hand/components/progress.dart';
import 'package:helping_hand/config/config.dart';
import 'package:helping_hand/config/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helping_hand/components/myHeader.dart';
import 'package:helping_hand/components/counter.dart';
import 'package:http/http.dart' as http;

class NewsUpdateScreen extends StatefulWidget {
  @override
  _NewsUpdateScreenState createState() => _NewsUpdateScreenState();
}

class _NewsUpdateScreenState extends State<NewsUpdateScreen> {
  Map bangladeshData;

  Map reportData;
  // fetchWorldWideData() async {
  //   http.Response response = await http.get('https://corona.lmao.ninja/v2/all');

  //   reportData = json.decode(response.body);
  // }

  fetchBangladeshData() async {
    http.Response response =
        await http.get('https://corona.lmao.ninja/v2/countries/bangladesh');

    reportData = json.decode(response.body);
  }

  // // for fetching the country data
  // List countryData;
  // fetchcountryData() async {
  //   http.Response response =
  //       await http.get('https://corona.lmao.ninja/v2/countries');

  //   reportData = json.decode(response.body);
  // }

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
              onRefresh: ()async{
                fetchBangladeshData();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    MyHeader(
                      image: "assets/icons/Drcorona.svg",
                      textTop: "All you need",
                      textBottom: "is stay at home.",
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
                            child: Text(
                              "Bangladesh",
                              style: titleTextStyle,
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
                                      text: "Newest update March 28",
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
