import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialise() async {
    if (Platform.isIOS) {
      // Request permission if we are on iOS
      _fcm.requestNotificationPermissions(
        IosNotificationSettings(sound: true, alert: true, badge: true),
      );
      _fcm.onIosSettingsRegistered.listen((settings) {
        print('Settings registered: $settings');
      });
    }
    _fcm.configure(
      //Called when the app is in the foreground and we recieve a push notification
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage : $message');
      },
      // Called when the app has been closed completely and it's opened
      //from the push notification
      onLaunch: (Map<String, dynamic> message) async {
        print('onMessage : $message');
      },
      //Called when the app is in the foreground and it's opened
      // from the push notification
      onResume: (Map<String, dynamic> message) async {
        print('onMessage : $message');
      },
    );
  }
}

//   void _serialiseAndNavigate(Map<String, dynamic> message) {
//     var notificationData = message['data'];
//     var view = notificationData['view'];

//     if (view != null) {
//       //Navigate to the create post view
//       if (view == 'create_post') {
//         Navigator.push(
//           MaterialPageRoute(
//             builder: (context) => MessageScreen(),
//           ),
//         );
//       }
//     }
//   }
// }
