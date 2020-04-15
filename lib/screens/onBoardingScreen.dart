import 'package:flutter/material.dart';
import 'package:helping_hand/config/config.dart';
import 'package:helping_hand/screens/loginScreen.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

var pages = [
//Screen 1
  PageViewModel(
    title: "Let's be human again!",
    body:
        "It’s time to be human again. Let’s show yourself that you’re not here to humiliate. Let them know they are not alone.",
    image: Center(
      child: SvgPicture.asset("assets/images/onboarding_screen_1.svg",
          width: 308, height: 255.0),
    ),
  ),

//Screen 2
  PageViewModel(
    title: "Be a good human being",
    body:
        "Be the reason someone smiles. Be the reason someone feels loved and believes in the goodness in people.",
    image: Center(
      child: SvgPicture.asset("assets/images/onboarding_screen_2.svg",
          width: 308, height: 255.0),
    ),
  ),

//Screen 3
  PageViewModel(
    title: "Finally help them",
    body:
        "Strong people stand up for themselves, but stronger people stand up for others.",
    image: Center(
      child: SvgPicture.asset("assets/images/onboarding_screen_3.svg",
          width: 308, height: 255.0),
    ),
  )
];

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
              
                padding: EdgeInsets.all(16.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 130,
                child: IntroductionScreen(
                  pages: pages,
                  onDone: () {},
                  // onSkip: () {
                  // },
                  showSkipButton: false,
                  showNextButton: false,
                  //skip: const Icon(Icons.skip_next),
                  //next: const Icon(Icons.arrow_right),
                  done: const Text("",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  dotsDecorator: DotsDecorator(
                      size: const Size.square(6.0),
                      activeSize: const Size(20.0, 7.0),
                      activeColor: Color(0xFF2F3676),
                      color: Colors.black26,
                      spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                      activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0))),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: buttonBgColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: Center(
                      child: Text(
                        "Get Started",
                        style: buttonTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
