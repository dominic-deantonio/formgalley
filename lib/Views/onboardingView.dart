import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:formgalley/Widgets/widgetExporter.dart';
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
    prefs.setBool('finishedOnboarding', false);//Change this at production
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Text('App Name Here'),
            ),
            Expanded(
              flex: 9,
              child: PageView(
                controller: controller,
                children: <Widget>[
                  page(msg: 'Here is page 1', color: Colors.red),
                  page(msg: 'Here is page 2', color: Colors.blue),
                  page(msg: 'Here is page 2', color: Colors.green),
                ],
              ),
            ),
            SmoothPageIndicator(
              controller: controller,
              count: 3,
              effect: WormEffect(activeDotColor: Theme.of(context).primaryColorDark),

            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }

  Widget page({String msg, Color color}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(msg),
          FlatButton(child: Text('Finish'), onPressed: finishOnboarding,),
        ],
      ),
      color: color,
    );
  }
}
