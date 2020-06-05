import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/Views/viewsExporter.dart';
import 'package:formgalley/db.dart';
import 'package:formgalley/User/user.dart';
import 'package:formgalley/encryption.dart';
import 'package:formgalley/utilities/util.dart';

class SplashView extends StatefulWidget {
  final Function onSuccessfulLoad;
  final Function(Exception, String) onException;

  SplashView({
    @required this.onSuccessfulLoad,
    @required this.onException,
  });

  @override
  _SplashViewState createState() => new _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  String status;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    try {
      setState(() => status = 'Initializing local database');
      await DB.initializeLocalDb().timeout(Duration(seconds: 0));
      setState(() => status = 'Initializing encryption');
      await Encryption.initialize().timeout(Duration(seconds: 10));
      setState(() => status = 'Getting user data');
      var maps = await DB.getUserDataFromLocalDb().timeout(Duration(seconds: 10));
      setState(() => status = 'Loading user data');
      await User.instance.loadUserDataToInstance(maps).timeout(Duration(seconds: 10));
      setState(() => status = 'Loading application');
      await Util.waitMilliseconds(1500);
      widget.onSuccessfulLoad();
      print('Initialized with no errors');
    } catch (e) {
      widget.onException(e, 'initialize splash');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(child: Container()),
            Center(child: SizedBox(height: 40, child: CupertinoActivityIndicator())),
            Text(status),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
