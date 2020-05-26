import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:formgalley/Utilities/util.dart';

class DismissibleCustom extends StatelessWidget {
  final Widget child;
  final Function onDelete;
  final Function onShare;
  final SlidableController controller;

  DismissibleCustom({@required this.child, @required this.onDelete, @required this.onShare, @required this.controller});

  @override
  Widget build(BuildContext context) {
    Future<bool> promptUser() async {
      return showCupertinoDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete'),
            content: Text('Permanently delete this form?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              FlatButton(
                child: Text('Delete'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      );
    }

    return Slidable(
      key: UniqueKey(),
      dismissal: SlidableDismissal(
        closeOnCanceled: true,
        dragDismissible: false,
        child: SlidableDrawerDismissal(),
        onDismissed: ((type) => onDelete()),
        onWillDismiss: (type) async {
          if (type == SlideActionType.primary) {
            onShare();
            return false;
          } else {
            return true;
          }
        },
      ),
      actionPane: SlidableScrollActionPane(),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: IconSlideAction(
            iconWidget: Icon(Icons.send),
            onTap: () => onShare(),
          ),
        ),
      ],
      secondaryActions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 25.0),
          child: IconSlideAction(
            iconWidget: Icon(Icons.delete, color: Colors.red),
            onTap: () async {
              bool doDelete = await promptUser();
              print(doDelete);
              print(controller.activeState);
              //onDelete();
            },
            closeOnTap: false,
          ),
        ),
      ],
      child: child,
    );

//    return Dismissible(
//      onDismissed: (dir) {
//        if (dir == DismissDirection.endToStart) {
//          print('Delete');
//          onDelete();
//        }
//      },
//      confirmDismiss: (dir) async {
//        bool doDismiss;
//        if (dir == DismissDirection.startToEnd) {
//          onShare();
//          doDismiss = false;
//        } else {
//          doDismiss = await promptUser();
//        }
//        print(doDismiss);
//        return doDismiss;
//      },
//      key: UniqueKey(),
//      child: child,
//      secondaryBackground: Padding(
//        padding: const EdgeInsets.only(right: 10.0),
//        child: Align(
//          alignment: Alignment.centerRight,
//          child: Icon(
//            Icons.delete,
//            color: Colors.red,
//          ),
//        ),
//      ),
//      background: Padding(
//        padding: const EdgeInsets.only(left: 10.0),
//        child: Align(
//          alignment: Alignment.centerLeft,
//          child: Icon(
//            Platform.isIOS ? CupertinoIcons.share : Icons.share,
//            color: Colors.blueAccent,
//          ),
//        ),
//      ),
//    );
  }
}
