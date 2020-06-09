import 'package:formgalley/fileManager.dart';
import 'package:intl/intl.dart';

class Log {

  static Future<String> write(String s) async {
    var now = DateFormat('HHmmss').format(DateTime.now()).toString();
    var event = '$now $s';
    await FileManager.writeToLog(event);
    return event;
  }

  static start() async {
    var now = DateFormat('yyyyMMdd-HHmmSS').format(DateTime.now()).toString();
    await FileManager.writeToLog('Session $now');
  }
}
