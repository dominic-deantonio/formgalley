import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/User/user.dart';

import 'package:formgalley/Widgets/widgetExporter.dart';

class TestView extends StatefulWidget {
  @override
  _TestViewState createState() => new _TestViewState();
}

class _TestViewState extends State<TestView> {
  Exception e;
  bool working = false;
  bool didSend = false;
  bool hasInternet = true;
  ConnectivityResult connection;

  @override
  void initState() {
    super.initState();
    Connectivity().checkConnectivity().then((r) => connection = r);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Center(
          child: ListView(children: <Widget>[DataCard(User.instance.lastName)],),
        ),
      ),
    );
  }
}
