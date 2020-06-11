import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/Forms/Base/formExport.dart';
import 'package:formgalley/Utilities/util.dart';
import 'package:formgalley/dataEngine.dart';
import 'package:formgalley/Widgets/widgetExporter.dart';
import 'package:formgalley/db.dart';
import 'package:formgalley/fileManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogView extends StatefulWidget {
  @override
  _LogViewState createState() => new _LogViewState();
}

class _LogViewState extends State<LogView> {
  String logData = 'Error fetching log';

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    String out = await FileManager.readLog();
    setState(() => out == '' ? logData = 'No data' : logData = out);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoScrollbar(
        child: CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              backgroundColor: Colors.white,
              largeTitle: const Text('Log'),
              previousPageTitle: 'Preferences',
              border: Border(),
              trailing: CupertinoButton(
                padding: EdgeInsets.all(0),
                child: Text('Clear Log'),
                onPressed: () async {
                  await FileManager.clearLog();
                  await initialize();
                },
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Dismissible(
                      key: UniqueKey(),
                      child: Card(
                        elevation: 0,
                        color: Colors.blue[500],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'The log collects important anonymous information about the state of the app. '
                            'It can help diagnose crashes and errors and is very helpful in '
                            'identifying precisely how to fix them.',
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      logData,
                      style: TextStyle(fontSize: 11),
                    ),
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
