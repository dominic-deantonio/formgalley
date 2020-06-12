import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

//Displays the prompts when getting information from the user needed for the form creation
class OnboardingView extends StatefulWidget {
  @override
  _OnboardingViewState createState() => new _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final String msg =
      'Your data is stored on this device - never transmitted over a network. If you delete the app, your data will be lost forever.';
  SharedPreferences prefs;
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((instance) => prefs = instance);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void finishOnboarding() {
    prefs.setBool('finishedOnboarding', false); //Change this at production
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Image.network('https://pngimage.net/wp-content/uploads/2018/06/logo-placeholder-png.png')),
                  Text('Formgalley'),
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: PageView(
                controller: controller,
                children: <Widget>[
                  page(
                    msg: 'Welcome to Formgalley!',
                    sub: 'Generate forms on the go',
                  ),
                  page(
                    msg: 'We\'ll handle the boring part',
                    sub: 'Use your saved data to quickly create new forms',
                  ),
                  page(
                    msg: 'Privacy is Paramount',
                    sub: 'Personal data is encrypted and never transmitted over a network',
                  ),
                  page(
                    msg: 'Get notified when new forms are added',
                    sub: 'Enable notifications to get instant access to new forms',
                    onPressed: () => print('Clicked the notifications button'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            SmoothPageIndicator(
              controller: controller,
              count: 4,
              effect: WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Theme.of(context).primaryColorDark,
              ),
            ),
            SizedBox(height: 40),
            CupertinoButton.filled(
              child: Text('Get Started'),
              onPressed: finishOnboarding,
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget page({String msg, String sub, Function onPressed}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Image.network(
                'https://image.freepik.com/free-vector/hand-drawn-checklist-background_23-2148070711.jpg'),
          ),
          onPressed != null
              ? CupertinoButton(
                  child: Text(
                    'Turn on notifications',
                    style: TextStyle(fontSize: 13),
                  ),
                  onPressed: onPressed)
              : Text(' '),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(msg, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Text(
              sub,
              style: TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
