import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helping_hand/config/config.dart';
import 'package:helping_hand/config/dataSource.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //this little code down here turns off auto rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
      ),
      body: ListView.builder(
          itemCount: DataSource.questionAnswers.length,
          itemBuilder: (context, index) {
            return ExpansionTile(
              title: Text(
                DataSource.questionAnswers[index]['question'],
                style: titleTextStyle.copyWith(fontSize: 16),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    DataSource.questionAnswers[index]['answer'],
                    style: bodyTextStyle.copyWith(
                        fontSize: 12, color: Colors.black, letterSpacing: 1),
                  ),
                )
              ],
            );
          }),
    );
  }
}
