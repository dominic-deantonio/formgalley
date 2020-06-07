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
import 'package:formgalley/options.dart';
import 'package:url_launcher/url_launcher.dart';

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

  static Future<bool> confirmCloseCollectionView(BuildContext context) async {
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

  static Future<void> sendFeedback(BuildContext context) async {
    Future<void> sendEmail(String subj, String body) async {
      try {
        String email = 'mailto:support@formgalley.com?subject=$subj&body=$body';
        await launch(email);
      } catch (e) {
        print('Failed to send email');
      }
    }

    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                StandardButton(
                    leading: Icon(Icons.bug_report),
                    title: 'Bug Report',
                    onTap: () async {
                      String subj = 'Bug Report';
                      String body = 'Please enter a detailed message about the bug you found:';
                      await sendEmail(subj, body);
                    }),
                StandardButton(
                  leading: Icon(Icons.description),
                  title: 'Form Request',
                  onTap: () async {
                    String subj = 'Form Request';
                    String body = 'Please enter detailed information about the form you would like added - '
                        'including the form name and where it can be found:';
                    await sendEmail(subj, body);
                  },
                ),
                StandardButton(
                  leading: Icon(Icons.build),
                  title: 'Feature Request',
                  onTap: () async {
                    String subj = 'Feature Request';
                    String body = 'Please enter detailed information about the feature you would like added:';
                    await sendEmail(subj, body);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> openOptions(BuildContext context) async {
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return OptionsModal();
      },
    );
  }
}

class OptionsModal extends StatefulWidget {
  @override
  _OptionsModalState createState() => _OptionsModalState();
}

class _OptionsModalState extends State<OptionsModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StandardButton(
              leading: Icon(Icons.invert_colors),
              title: 'Dark Theme',
              onTap: () => setState(() => Options.instance.useDarkTheme = !Options.instance.useDarkTheme),
              superTrailing: Switch.adaptive(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: Options.instance.useDarkTheme,
                onChanged: (d) => setState(() => Options.instance.useDarkTheme = !Options.instance.useDarkTheme),
              ),
            ),
//            StandardButton(title: 'An Option'),
//            StandardButton(title: 'An Option'),
          ],
        ),
      ),
    );
  }
}
