import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:formgalley/Forms/Base/completedForm.dart';
import 'package:formgalley/Utilities/util.dart';
import 'package:formgalley/db.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/Widgets/widgetExporter.dart';
import 'package:formgalley/fileManager.dart';
import 'package:share_extend/share_extend.dart';

class FilesView extends StatefulWidget {
  final SlidableController slidableController = SlidableController();
  final Function(CompletedForm) openFileCallback;
  final Function() updateFilesViewCallback;
  final List<CompletedForm> completedForms;

  FilesView({
    @required this.openFileCallback,
    this.completedForms,
    this.updateFilesViewCallback,
  });

  @override
  _FilesViewState createState() => new _FilesViewState();
}

class _FilesViewState extends State<FilesView> {
  var forms = List<CompletedForm>();
  SlidableController controller = SlidableController();

  @override
  Widget build(BuildContext context) {
    forms = widget.completedForms.reversed.toList();
    print('Rebuilt files view');
    return CupertinoPageScaffold(
      child: CupertinoScrollbar(
        child: CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: Text('${forms.length < 1 ? '' : forms.length} ${Util.plural(forms.length, 'File', 'Files')}'),
              border: Border(),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int i) {
                  CompletedForm f = forms[i];
                  DateTime d = Util.getDateFromStringStorageFormat(f.id);
                  return Slidable(
                    dismissal: SlidableDismissal(
                      closeOnCanceled: true,
                      dragDismissible: false,
                      child: SlidableDrawerDismissal(),
                      onDismissed: ((type) => {}),
                      onWillDismiss: (type) async {
                        if (type == SlideActionType.primary) {
                          ShareExtend.share(f.path, "Send this file");
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
                          onTap: () => FileManager.sendFile(f),
                        ),
                      ),
                    ],
                    secondaryActions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: IconSlideAction(
                          iconWidget: Icon(Icons.delete, color: Colors.red),
                          onTap: () async {
                            await DB.deleteFromTable('completedForms', f.id);
                            await FileManager.deleteFromDirectory(f.path);
                            forms.removeAt(i);
                            controller.activeState.dismiss();
                            await Util.waitMilliseconds(1000);
                            widget.updateFilesViewCallback();
                          },
                          closeOnTap: false,
                        ),
                      ),
                    ],
                    child: StandardButton(
                      title: f.formName,
                      subTitle: f.longName,
                      trailing: Util.getHowLongAgo(d),
                      onTap: () => widget.openFileCallback(f),
                    ),
                  );
                },
                childCount: forms.length,
              ),
            ),
            //If there are no files, inform the user.
            SliverList(
              delegate: SliverChildListDelegate(
                forms.length == 0
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
                        FractionallySizedBox(widthFactor: .75, child: Image.asset('images/guyWithPencil.jpg'))
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
