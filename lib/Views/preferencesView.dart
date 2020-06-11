import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:formgalley/Utilities/util.dart';
import 'package:formgalley/Widgets/widgetExporter.dart';
import 'package:formgalley/constants.dart';
import 'package:formgalley/encryption.dart';
import 'package:formgalley/fileManager.dart';
import 'package:package_info/package_info.dart';

//Displays the prompts when getting information from the user needed for the form creation
class PreferencesView extends StatefulWidget {
  final Function navigateToMyInfo;
  final Function giveFeedback;
  final Function openOptionsModal;
  final Function viewLog;

  PreferencesView({
    @required this.navigateToMyInfo,
    @required this.giveFeedback,
    @required this.openOptionsModal,
    this.viewLog,
  });

  @override
  _PreferencesViewState createState() => new _PreferencesViewState();
}

class _PreferencesViewState extends State<PreferencesView> {
  final String msg =
      'Your data is stored on this device - never transmitted over a network. If you delete the app, your info will be lost forever.';

  Widget encryptionIcon = Icon(Icons.lock);
  bool checkingEncryption = false;
  String encryptionStatus = Encryption.getStatusMessage();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoScrollbar(
        child: CustomScrollView(
          physics: ClampingScrollPhysics(),
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
//              backgroundColor: Colors.white,
              largeTitle: Text('Preferences'),
              border: Border(),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  StandardButton(
                    onTap: () => widget.navigateToMyInfo(),
                    title: 'My Info',
                    subTitle: msg,
                    leading: Icon(Icons.person),
                  ),
                  StandardButton(
                    leading: checkingEncryption ? CupertinoActivityIndicator(radius: 12) : encryptionIcon,
                    title: 'Encryption',
                    subTitle: encryptionStatus,
                    onTap: () async {
                      setState(() => checkingEncryption = true);
                      await Util.waitMilliseconds(500); //Actually check the encryption in future update
                      String status = Encryption.getStatusMessage();
                      setState(() {
                        checkingEncryption = false;
                        encryptionStatus = status;
                      });
                    },
                  ),
//                  StandardButton(
//                    leading: Icon(Icons.monetization_on, color: Colors.green,),
//                    title: 'Tip Jar',
//                    subTitle: 'If you\'d like to support the development of Formgalley further, or are just feeling extra nice.',
//                    function: () async {
//                      print('Open Tip Jar');
//                    },
//                  ),
                  StandardButton(
                    leading: Icon(Icons.message),
                    title: 'Feedback',
                    subTitle: 'Found a bug? Want a form or feature? Drop a line.',
                    onTap: () => widget.giveFeedback(),
                  ),
                  StandardButton(
                    onTap: () => widget.openOptionsModal(),
                    title: 'Options',
                    leading: Icon(Icons.settings),
                  ),
                  StandardButton(
                      leading: Icon(Icons.info),
                      title: 'About',
                      onTap: () async {
                        PackageInfo package = await PackageInfo.fromPlatform();
                        showAboutDialog(
                          context: context,
                          applicationName: 'Formgalley',
                          applicationVersion: package.version,
                          applicationLegalese: Constants.kLegalese,
                        );
                      }),
//                  StandardButton(
//                    leading: Icon(CupertinoIcons.folder_solid),
//                    title: 'Print Database',
//                    onTap: () async {
//                      DB.debugPrintDatabase();
//                    },
//                  ),
//                  StandardButton(
//                    leading: Icon(CupertinoIcons.folder_solid),
//                    title: 'View Log',
//                    onTap: () async {
//                      widget.viewLog();
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
