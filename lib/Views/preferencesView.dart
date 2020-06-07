import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:formgalley/Utilities/util.dart';
import 'package:formgalley/Widgets/widgetExporter.dart';
import 'package:formgalley/encryption.dart';

//Displays the prompts when getting information from the user needed for the form creation
class PreferencesView extends StatefulWidget {
  final Function navigateToMyInfo;
  final Function navigateToOptions;
  final Function giveFeedback;
  final Function openOptionsModal;

  PreferencesView({
    @required this.navigateToMyInfo,
    @required this.navigateToOptions,
    @required this.giveFeedback,
    @required this.openOptionsModal,
  });

  @override
  _PreferencesViewState createState() => new _PreferencesViewState();
}

class _PreferencesViewState extends State<PreferencesView> {
  final String msg =
      'Your data is stored on this device - never transmitted over a network. If you delete the app, your info will be lost forever.';

  Widget encryptionIcon = Icon(Icons.lock);
  bool checkingEncryption = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoScrollbar(
        child: CustomScrollView(
          physics: ClampingScrollPhysics(),
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
                    function: () => widget.navigateToMyInfo(),
                    title: 'My Info',
                    subTitle: msg,
                    leading: Icon(Icons.person),
                  ),
                  StandardButton(
                    leading: checkingEncryption ? CupertinoActivityIndicator(radius: 12) : encryptionIcon,
                    title: 'Encryption',
                    subTitle: Encryption.getStatusMessage(),
                    function: () async {
                      setState(() => checkingEncryption = true);
                      await Util.waitMilliseconds(500); //Actually check the encryption in future update
                      setState(() => checkingEncryption = false);
                    },
                  ),
                  StandardButton(
                    leading: Icon(Icons.monetization_on, color: Colors.green,),
                    title: 'Tip Jar',
                    subTitle: 'If you\'d like to support the development of Formgalley further, or are just feeling extra nice.',
                    function: () async {
                      print('Open Tip Jar');
                    },
                  ),
                  StandardButton(
                    leading: Icon(Icons.message),
                    title: 'Feedback',
                    subTitle: 'Found a bug? Need a form or feature? Drop us a line.',
                    function: () => widget.giveFeedback(),
                  ),
                  StandardButton(
//                    callback: () => widget.navigateToOptions(),
                    function: () => widget.openOptionsModal(),
                    title: 'Options',
                    leading: Icon(Icons.settings),
                  ),
                  StandardButton(
                    leading: Icon(Icons.info),
                    title: 'About',
                    function: () => showAboutDialog(context: context),
                  ),
//                  StandardButton(
//                    leading: Icon(CupertinoIcons.folder_solid),
//                    title: 'Print Database',
//                    callback: () async {
//                      DB.debugPrintDatabase();
//                    },
//                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
