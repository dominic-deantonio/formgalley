import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:formgalley/Utilities/util.dart';
import 'package:formgalley/Widgets/widgetExporter.dart';
import 'package:formgalley/log.dart';
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

    await Log.write('Alerted user of no network connection');
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

  static Future<bool> confirmCloseCollectionView(BuildContext context, Function onSave) async {
    await Log.write('Asked user to confirm discarding changes in collection view.');
    String title = 'Save Changes?';
    String discard = 'Discard';
    String cancel = 'Cancel';
    String save = 'Save';
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text(title),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(discard, style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.of(context).pop(true),
              ),
              CupertinoDialogAction(
                child: Text(cancel, style: TextStyle(color: Colors.black)),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              CupertinoDialogAction(
                child: Text(save),
                onPressed: () async {
                  await onSave();
                  await Util.waitMilliseconds(500); //Let the user see the blue change in the background
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Text(title),
            actions: <Widget>[
              FlatButton(
                child: Text(cancel, style: TextStyle(color: Colors.black)),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              FlatButton(
                child: Text(discard, style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.of(context).pop(true),
              ),
              FlatButton(
                child: Text(save, style: TextStyle(color: Colors.blue)),
                onPressed: () async {
                  await onSave();
                  await Util.waitMilliseconds(500); //Let the user see the blue change in the background
                  Navigator.of(context).pop(true);
                },
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
      await Log.write('Launched email for feedback flow.');
    }

    await Log.write('Displayed send feedback modal.');
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

  static Future<void> openOptions({BuildContext context, Function(CupertinoThemeData) updateTheme}) async {
    await Log.write('Displayed options modal.');
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return OptionsModal(updateTheme: (opposite) => updateTheme(opposite));
      },
    );
  }
}

class OptionsModal extends StatefulWidget {
  final Function(CupertinoThemeData) updateTheme;

  OptionsModal({this.updateTheme});

  @override
  _OptionsModalState createState() => _OptionsModalState();
}

class _OptionsModalState extends State<OptionsModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            GestureDetector(
              onTap: () => widget.updateTheme(Options.instance.switchTheme()),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Options.instance.getCurrentTheme().primaryContrastingColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.brightness_6),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Dark Mode',
                            style: TextStyle(
                              color: Options.instance.getCurrentTheme().textTheme.actionTextStyle.color,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                      Switch.adaptive(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: Options.instance.useDarkTheme,
                        onChanged: (d) {
                          widget.updateTheme(Options.instance.switchTheme());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
