import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/db.dart';
import 'package:formgalley/User/user.dart';
import 'package:formgalley/encryption.dart';
import 'package:formgalley/utilities/util.dart';

class SplashScreen extends StatefulWidget {
  final Function onCompletedLoading;

  SplashScreen({
    @required this.onCompletedLoading,
  });

  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String status;

  @override
  void initState() {
    super.initState();
    setState(() => status = 'Initializing local database');
    DB.initializeLocalDb().whenComplete(() {
      setState(() => status = 'Initializing encryption');
      Encryption.initialize().whenComplete(() {
        setState(() => status = 'Getting user data');
        DB.getUserDataFromLocalDb().then((maps) {
          setState(() => status = 'Loading user data');
          User.instance.loadUserDataToInstance(maps).whenComplete(() {
            setState(() => status = 'Loading application');
            Util.waitMilliseconds(1000).whenComplete(() {
              widget.onCompletedLoading();
              //Navigator.of(context).pushReplacementNamed('/welcome', arguments: formData);
            });
          });
        });
      });
    });
    //First, get the content from the database
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(child: Container()),
            Center(child: CupertinoActivityIndicator()),
            Text(status),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
