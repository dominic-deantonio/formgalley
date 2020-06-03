import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:formgalley/Utilities/util.dart';
import 'package:formgalley/Widgets/widgetExporter.dart';
import 'package:formgalley/connection.dart';
import 'package:formgalley/db.dart';
import 'package:formgalley/encryption.dart';

//Displays the prompts when getting information from the user needed for the form creation
class PreferencesView extends StatefulWidget {
  final Function navigateToMyInfo;

  PreferencesView({@required this.navigateToMyInfo});

  @override
  _PreferencesViewState createState() => new _PreferencesViewState();
}

class _PreferencesViewState extends State<PreferencesView> {
  final String msg =
      'Your data is stored on this device - never transmitted over a network. If you delete the app, your data will be lost forever.';

  Icon encryptionIcon = Icon(Icons.lock);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoScrollbar(
        child: CustomScrollView(
          //Remove when more options exist
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              backgroundColor: Colors.white,
              largeTitle: Text('Preferences'),
              border: Border(),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  StandardButton(
                    callback: () => widget.navigateToMyInfo(),
                    title: 'My Info',
                    subTitle: msg,
                    leading: Icon(Icons.person),
                  ),
                  StandardButton(
                    leading: encryptionIcon,
                    title: 'Encryption',
                    subTitle: Encryption.getStatusMessage(),
                    callback: () async {
                      setState(() => encryptionIcon = Icon(Icons.lock_outline));
                      await Util.waitMilliseconds(250);
                      setState(() => encryptionIcon = Icon(Icons.lock));
                    },
                  ),
                  StandardButton(
                    callback: () => showDialog(
                        context: context,
                        builder: CupertinoAlertDialog(
                          content: Column(
                            children: <Widget>[
                              Text(
                                'Options',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Dark mode (requires restart)',
                                    textAlign: TextAlign.left,
                                  ),
                                  CupertinoSwitch(
                                    onChanged: (v) {},
                                    value: true,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ).build),
                    title: 'Options',
                    leading: Icon(Icons.settings),
                  ),
                  StandardButton(
                    leading: Icon(Icons.feedback),
                    title: 'Give Feedback',
                    subTitle: 'Here is a subtitle for feedback. Fill this in later.',
                    callback: () async {
                      print('Tapped feedback button');
                    },
                  ),
                  StandardButton(
                    leading: Icon(CupertinoIcons.heart_solid),
                    title: 'Support',
                    subTitle: 'Support the development of Formgalley, new forms, and new features.',
                    callback: () async {
                      print('Tapped feedback button');
                    },
                  ),
                  StandardButton(
                    leading: Icon(Icons.info_outline),
                    title: 'About',
                    callback: () {
                      showAboutDialog(context: context);
                    },
                  ),
                  StandardButton(
                    leading: Icon(CupertinoIcons.folder_solid),
                    title: 'Print Database',
                    callback: () async {
                      DB.debugPrintDatabase();
                    },
                  ),
                  StandardButton(
                    leading: Icon(Icons.wifi),
                    title: 'Check Connectivity',
                    callback: () async {
                      await Connection.check();
                    },
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
