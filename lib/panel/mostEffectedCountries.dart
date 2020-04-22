import 'package:flutter/material.dart';
import 'package:helping_hand/config/config.dart';
import 'package:helping_hand/config/constant.dart';

class MostEffectedCountries extends StatelessWidget {
  final List countryData;

  const MostEffectedCountries({Key key, this.countryData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            child: Row(
              children: <Widget>[
                Image.network(countryData[index]['countryInfo']['flag'], height: 30,),
                Text(countryData[index]['country'], style: titleTextStyle,),
                Text(
                  "Deaths: " + countryData[index]['deaths'].toString(),
                  style: kTitleTextstyle.copyWith(color: Colors.red),
                ),
              ],
            ),
          );
        },
        itemCount: 5,
      ),
    );
  }
}
