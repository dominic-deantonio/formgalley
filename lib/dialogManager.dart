import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:formgalley/Widgets/widgetExporter.dart';
import 'package:formgalley/dataEngine.dart';
import 'package:formgalley/db.dart';
import 'package:formgalley/User/data.dart';
import 'package:formgalley/User/user.dart';
import 'package:formgalley/Forms/Base/formExport.dart';

class DialogManager {

  static Future<void> alertUserNoConnection(BuildContext context) async {
    String msg = 'Network connection is needed to download the form content. Try:\n'
        '\n\t- Turning off airplane mode'
        '\n\t- Turning on mobile data or Wi-Fi'
        '\n\t- Checking the signal in your area';
    String title = 'No Internet';
    String option = 'Ok';

    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text(title),
            actions: <Widget>[
              CupertinoDialogAction(child: Text(option), onPressed: () => Navigator.of(context).pop()),
            ],
          );
        } else {
          return AlertDialog(
            title: Text(title),
            content: Text(msg),
            actions: <Widget>[
              FlatButton(child: Text(option), onPressed: () => Navigator.of(context).pop()),
            ],
          );
        }
      },
    );
  }

  static Future<bool> confirmClose(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text('Discard Changes?'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              CupertinoDialogAction(
                child: Text('Discard', style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Text('Discard Changes?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              FlatButton(
                child: Text('Discard', style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        }
      },
    );
  }
}
