import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:formgalley/Widgets/widgetExporter.dart';

//Displays the prompts when getting information from the user needed for the form creation
class MeView extends StatefulWidget {
  final Function navigateToMyInfo;

  MeView({@required this.navigateToMyInfo});

  @override
  _MeViewState createState() => new _MeViewState();
}

class _MeViewState extends State<MeView> {
  final String msg =
      'Your data is stored on this device - never transmitted over a network. If you delete the app, your data will be lost forever.';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoScrollbar(
        child: CustomScrollView(
          physics: NeverScrollableScrollPhysics(),
          //Remove when more options exist
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              backgroundColor: Colors.white,
              largeTitle: Text('Me'),
              border: Border(),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  StandardButton(
                    callback: () => widget.navigateToMyInfo(),
                    title: 'My Info',
                    description: msg,
                    icon: Icon(Icons.person),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Confirm file deletion',
                                    textAlign: TextAlign.left,
                                  ),
                                  CupertinoSwitch(
                                    onChanged: (v) {},
                                    value: true,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Save provided form data',
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
                    icon: Icon(Icons.settings),
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
