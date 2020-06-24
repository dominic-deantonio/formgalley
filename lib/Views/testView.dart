import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/User/data.dart';
import 'package:formgalley/User/user.dart';
import 'package:formgalley/Utilities/formatters.dart';

import 'package:formgalley/Widgets/widgetExporter.dart';

class TestView extends StatefulWidget {
  @override
  _TestViewState createState() => new _TestViewState();
}

class _TestViewState extends State<TestView> {

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Center(
//          child: ListView(
//            children: <Widget>[
//              DataCard(User.instance.lastName),
//              SizedBox(height: 10),
//              DataCard(User.instance.branch),
//              SizedBox(height: 10),
//              DataCard(User.instance.birthDate),
//              SizedBox(height: 10),
//              DataCard(
//                Data(
//                  hintText: '99.99',
//                  title: 'Allotment amount',
//                  minRequiredChars: 5,
//                  prompt: 'The amount of the allotment. Use precise commas and decimals.',
//                  usedInForms: ['DD 2558'],
//                  inputMethod: InputMethod.currency,
//                  inputFormatters: Formatters.currency,
//                  textInputType: TextInputType.number,
//                ),
//              ),
//            ],
//          ),
        ),
      ),
    );
  }
}
