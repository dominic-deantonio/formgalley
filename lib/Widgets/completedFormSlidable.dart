import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:formgalley/db.dart';
import 'package:formgalley/fileManager.dart';

class CompletedFormSlidable extends StatefulWidget {
  final List<Map<String, dynamic>> files;
  final int index;
  final SlidableController controller;
  final Function onDismissCallback;
  final Function(String) onWasTapped;

  CompletedFormSlidable({
    @required this.files,
    @required this.index,
    @required this.controller,
    @required this.onDismissCallback,
    @required this.onWasTapped,
  });

  @override
  _CompletedFormSlidableState createState() => _CompletedFormSlidableState();
}

class _CompletedFormSlidableState extends State<CompletedFormSlidable> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(widget.files[widget.index]['id']),
      controller: widget.controller,
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) async {
          await DB.deleteFromTable('completedForms', widget.files[widget.index]['id']);
          await FileManager.deleteFromDirectory(widget.files[widget.index]['path']);
          // This must come second, else cant find in directory
          widget.onDismissCallback();
        },
        onWillDismiss: (actionType) async {
          bool shouldRemove = false;
          if (actionType == SlideActionType.primary) {
            print('${widget.files[widget.index]['id']}');
            return shouldRemove;
          } else {
            await showDialog<void>(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Delete this form?'),
                  content: Text('This cannot be undone.'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    FlatButton(
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        shouldRemove = true;
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
            return shouldRemove;
          }
        },
      ),
      actionPane: SlidableDrawerDismissal(),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Share',
          color: Colors.blue,
          icon: Icons.share,
          onTap: () => print('Share'),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => widget.controller.activeState?.dismiss(),
        ),
      ],
      child: Container(
        color: Colors.white,
        child: Material(
          child: ListTile(
            onTap: () {
              setState(() => widget.controller.activeState?.close());
              widget.onWasTapped(widget.files[widget.index]['path']);
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${widget.files[widget.index]['formName']} ${widget.files[widget.index]['id']}',
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    children: <Widget>[
                      Text(
                        widget.files[widget.index]['date'],
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Icon(
                        CupertinoIcons.forward,
                        size: 12,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            subtitle: Text(widget.files[widget.index]['longName']),
          ),
        ),
      ),
    );
  }
}