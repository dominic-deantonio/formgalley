import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/Forms/Base/formExport.dart';
import 'package:formgalley/Utilities/util.dart';
import 'package:formgalley/dataEngine.dart';
import 'package:formgalley/Widgets/widgetExporter.dart';
import 'package:formgalley/db.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeView extends StatefulWidget {
  final Function(FormBase) onFormSelected;
  final Function runOnboarding;

  WelcomeView({@required this.onFormSelected, @required this.runOnboarding});

  @override
  _WelcomeViewState createState() => new _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  bool loading = true;
  var formsMap = List<Map<String, dynamic>>();
  Image image1 = Image.asset('images/guyWithPencil.jpg', height: 230);
  Image image2 = Image.asset('images/thinkingPerson.jpg', height: 230);

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    var instance = await SharedPreferences.getInstance().timeout(Duration(seconds: 5));
    bool finishedOnboarding = instance.getBool('finishedOnboarding') ?? false;
    if (!finishedOnboarding) widget.runOnboarding();
    var formData = await DB.getFormDataFromFirebase().timeout(Duration(seconds: 10));
    setState(() {
      formsMap = List.from(formData);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoScrollbar(
        child: CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              backgroundColor: Colors.white,
              largeTitle: const Text('Create'),
              previousPageTitle: 'Something',
              trailing: CupertinoButton(
                padding: EdgeInsets.all(0),
                child: Icon(CupertinoIcons.info),
                onPressed: () {
                  setState(() => loading = !loading);
                },
              ),
              border: Border(),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                loading ? getShimmerListItems() : getListItems(),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> getShimmerListItems() {
    var items = List<Widget>();
    items.add(
      Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: Row(
          children: <Widget>[
            Flexible(child: image1),
            Flexible(child: image2),
          ],
        ),
      ),
    );
    for (int i = 0; i < 7; i++) items.add(ShimmerListItem());
    return items;
  }

  List<Widget> getListItems() {
    var items = List<Widget>();

    items.add(
      Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: Row(
          children: <Widget>[
            Flexible(child: image1),
            Flexible(child: image2),
          ],
        ),
      ),
    );

    for (var map in formsMap) {
      var reg = FormRegistry.instance.registeredForms;
      bool existsInApp = reg.containsKey(map['formNum']); //If false, exists in firebase but not in app - need upgrade

      items.add(
        StandardButton(
          title: map['formNum'],
          subTitle: existsInApp ? map['formName'] : '(Update required) ${map['formName']}',
          allowWrap: false,
          color: existsInApp ? null : Colors.grey[200],
          callback: () async {
            if (existsInApp) {
              var form = await DataEngine.getSelectedFormObject(map);
              widget.onFormSelected(form);
            } else {
              print('Open the app store');
            }
          }, //On tap
        ),
      );
    }

    return items;
  }
}
