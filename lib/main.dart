import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helping_hand/components/progress.dart';
import 'package:helping_hand/screens/completeProfileScreen.dart';
import 'package:helping_hand/screens/loginScreen.dart';
import 'package:helping_hand/screens/onBoardingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/config.dart';
import 'package:helping_hand/screens/userProfileScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int initScreen;
final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  print('initScreen ${initScreen}');
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      //home: OnBoardingPage(),
      initialRoute: initScreen == 0 || initScreen == null ? "first" : "/",
      routes: {
        '/': (context) => OnBoardingPage(),
        "first": (context) => OnBoardingScreen(),
      },
      theme: ThemeData(
        primaryColor: primaryColor,
        brightness: Brightness.light,
        primaryTextTheme: TextTheme(
          body1: bodyTextStyle,
          title: titleTextStyle,
          button: buttonTextStyle,
        ),
      ),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool goToProfileScreen = false;

  Future<void> ProfileScreenDesicion() async {
    final auth = FirebaseAuth.instance;
    final FirebaseUser currentUser = await auth.currentUser();
    final currentUserUID = currentUser.uid;

    final DocumentReference user =
        Firestore.instance.document('users/' + currentUserUID);

    await for (var snapshot in user.snapshots()) {
      if (snapshot.data == null) {
        setState(() {
          goToProfileScreen = false;
        });
        break;
      } else {
        setState(() {
          goToProfileScreen = true;
        });
      }
    }
  }

  @override
  void initState() {
    ProfileScreenDesicion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _auth.onAuthStateChanged,
        builder: (ctx, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            FirebaseUser user = snapshot.data;
            if (user != null) {
              if (goToProfileScreen == true) {
                return UserProfile();
              } else if (goToProfileScreen == false) {
                return CompleteProfileScreen();
              }
            } else {
              return circularProgress();
            }
          }
          return LoginScreen();
        },
      ),
    );
  }
}
