import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/Utilities/util.dart';
import 'package:package_info/package_info.dart';

class ErrorView extends StatefulWidget {
  final Exception exception;
  final String view;

  ErrorView(this.exception, this.view);

  @override
  _ErrorViewState createState() => new _ErrorViewState();
}

class _ErrorViewState extends State<ErrorView> {
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
    e = widget.exception;
    String errorTitle = 'An unexpected error occurred';
    String errorMsg = 'An error report is ready to send to help fix the issue.'
        '\nNo personal data will be sent.';

    Future<String> buildReport() async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String out = 'Error report-----------'
          '\nversion: ${packageInfo.version}'
          '\nbuildNumber: ${packageInfo.buildNumber}'
          '\nexception: ${e.runtimeType.toString()}'
          '\nplatform: ${Platform.operatingSystem} ${Platform.version}'
          '\nconnection: $connection'
          '\n${widget.view}: ${e.toString()}';
      return out;
    }

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(flex: 3, child: Container()),
              Text('Uh oh!', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
              Expanded(flex: 1, child: Container()),
              Text(
                '$errorTitle\n\n$errorMsg',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              Expanded(flex: 4, child: Container()),
              Image.asset('images/NoConnection.png', height: 300),
              Expanded(
                flex: 3,
                child: Center(child: hasInternet ? Text('') : Text('No internet connection')),
              ),
              SizedBox(
                height: 50,
                child: working
                    ? CupertinoActivityIndicator()
                    : didSend
                        ? Center(child: Text('Report sent. Thank you!'))
                        : CupertinoButton.filled(
                            child: Text('Send Report'),
                            onPressed: () async {
                              if (!working) {
                                setState(() => working = true);
                                setState(() => hasInternet = true);
                                var conn = await Connectivity().checkConnectivity();
                                if (conn == ConnectivityResult.none) {
                                  setState(() => hasInternet = false);
                                } else {
                                  print(await buildReport());
                                  await Util.waitMilliseconds(500); //pretend sending function
                                  setState(() => didSend = true);
                                }
                              }
                              setState(() => working = false);
                            }),
              ),
              Expanded(flex: 4, child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
