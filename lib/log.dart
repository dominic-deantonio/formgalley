import 'package:intl/intl.dart';

class Log {
  static write(String s) {
    var now = DateFormat('HHmmss').format(DateTime.now()).toString();
    print('$now: $s');
  }

  static start(){
    var now = DateFormat('yyyyMMdd').format(DateTime.now()).toString();
    print('Starting log $now');
  }
}
