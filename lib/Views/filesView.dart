import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:formgalley/Utilities/util.dart';
import 'package:formgalley/db.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/Widgets/widgetExporter.dart';
import 'package:formgalley/fileManager.dart';
import 'package:share_extend/share_extend.dart';

class FilesView extends StatefulWidget {
  final SlidableController slidableController = SlidableController();
  final Function(String) openFileCallback;
  final Function() updateFilesViewCallback;
  final List<Map<String, dynamic>> files;

  FilesView({@required this.openFileCallback, this.files, this.updateFilesViewCallback});

  @override
  _FilesViewState createState() => new _FilesViewState();
}

class _FilesViewState extends State<FilesView> {
  var files = List<Map<String, dynamic>>();
  SlidableController controller = SlidableController();

  @override
  Widget build(BuildContext context) {
    files = widget.files.reversed.toList();

    return CupertinoPageScaffold(
      child: CupertinoScrollbar(
        child: CustomScrollView(
          physics: ClampingScrollPhysics(),
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              backgroundColor: Colors.white,
              largeTitle: Text('${files.length < 1 ? '' : files.length} ${Util.plural(files.length, 'File', 'Files')}'),
              border: Border(),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int i) {
                  Map<String, dynamic> f = files[i];
                  DateTime d = Util.getDateFromStringStorageFormat(f['id']);
                  return Slidable(
                    dismissal: SlidableDismissal(
                      closeOnCanceled: true,
                      dragDismissible: false,
                      child: SlidableDrawerDismissal(),
                      onDismissed: ((type) => print('deleted')),
                      onWillDismiss: (type) async {
                        if (type == SlideActionType.primary) {
                          ShareExtend.share(f['path'], "Send this file");
                          //Currently unused because slide is not implemented
                          return false;
                        } else {
                          return true;
                        }
                      },
                    ),
                    controller: controller,
                    actionPane: SlidableScrollActionPane(),
                    key: UniqueKey(),
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: IconSlideAction(
                          iconWidget: Icon(Icons.send),
                          onTap: () => ShareExtend.share(f['path'], "Send this file"),
                        ),
                      ),
                    ],
                    secondaryActions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: IconSlideAction(
                          iconWidget: Icon(Icons.delete, color: Colors.red),
                          onTap: () async {
                            await DB.deleteFromTable('completedForms', f['id']);
                            await FileManager.deleteFromDirectory(f['path']);
                            files.removeAt(i);
                            controller.activeState.dismiss();
                            await Util.waitMilliseconds(1000);
                            widget.updateFilesViewCallback();
                          },
                          closeOnTap: false,
                        ),
                      ),
                    ],
                    child: StandardButton(
                      title: f['formName'],
                      description: f['longName'],
                      trailing: Util.getHowLongAgo(d),
                      callback: () => widget.openFileCallback(f['path']),
                    ),
                  );
                },
                childCount: files.length,
              ),
            ),
            //If there are no files, inform the user.
            SliverList(
              delegate: SliverChildListDelegate(
                files.length == 0
                    ? [
                        SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: Text(
                            'No files created yet.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: Image.network(
                            'https://image.freepik.com/free-vector/hand-drawn-checklist-background_23-2148070711.jpg',
                          ),
                        )
                      ]
                    : [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
