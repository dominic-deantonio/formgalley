import 'dart:io';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

///Represents a completed form saved on the device
///Used to generate the files view list, and should be fed anywhere a completed form is needed, rather than using maps
class CompletedForm {
  CompletedForm({
    @required this.id,
    @required this.formName,
    @required this.longName,
    @required this.dateCompleted,
    @required this.path,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'formName': formName,
      'longName': longName,
      'date': dateCompleted,
      'path': path,
    };
  }

  String id, formName, longName, dateCompleted, path;
}
