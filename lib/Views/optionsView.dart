import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/Utilities/util.dart';
import 'package:package_info/package_info.dart';
import 'package:formgalley/options.dart';

class OptionsView extends StatefulWidget {
  final Options options;

  OptionsView({this.options});

  @override
  _OptionsViewState createState() => new _OptionsViewState();
}

class _OptionsViewState extends State<OptionsView> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoScrollbar(
        child: CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              backgroundColor: Colors.white,
              largeTitle: Text('Options'),
              leading: CupertinoButton(
                padding: EdgeInsets.all(0),
                child: Text('Done'),
                onPressed: () async => Navigator.pop(context),
              ),
              border: Border(),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [],
              ),
            )
          ],
        ),
      ),
    );
  }
}
