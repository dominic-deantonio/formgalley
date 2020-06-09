import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/log.dart';
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
  String status = 'Checking Connection';
  bool hasInternet = true;
  bool retrying = false;

  @override
  void initState() {
    super.initState();
    initialize().whenComplete(() => {});
  }

  Future<void> initialize() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    await Util.waitMilliseconds(500);
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        retrying = false;
        hasInternet = false;
      });
    } else {
      try {
        setState(() => status = 'Initializing local database');
        await DB.initializeLocalDb().timeout(Duration(seconds: 10));
        setState(() => status = 'Initializing encryption');
        await Encryption.initialize().timeout(Duration(seconds: 10));
        setState(() => status = 'Getting user data');
        var maps = await DB.getUserDataFromLocalDb().timeout(Duration(seconds: 10));
        setState(() => status = 'Loading user data');
        await User.instance.loadUserDataToInstance(maps).timeout(Duration(seconds: 10));
        setState(() => status = 'Loading application');
        await Util.waitMilliseconds(1500);
        hasInternet = true;
        widget.onSuccessfulLoad();
        print('Initialized with no errors');
      } catch (e) {
        widget.onException(e, 'initializing splash');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: hasInternet ? showLoading() : showNoInternet(),
      ),
    );
  }

  Widget showLoading() {
    return Column(
      children: <Widget>[
        Expanded(child: Container()),
        Center(child: SizedBox(height: 40, child: CupertinoActivityIndicator())),
        Text(status),
        Expanded(child: Container()),
      ],
    );
  }

  Widget showNoInternet() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'No Internet Connection\n\nFormgalley needs to connect to check'
            '\nfor new forms and other updates.',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 100),
          CupertinoButton.filled(
            child: retrying ? SizedBox(width: 37, child: CupertinoActivityIndicator()) : Text('Retry'),
            onPressed: () async {
              setState(() {
                retrying = true;
              });
              initialize();
            },
          ),
        ],
      ),
    );
  }
}
