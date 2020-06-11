import 'dart:io';

import 'package:formgalley/fileManager.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:device_info/device_info.dart';

class Log {
  static Future<void> write(String s) async {
    var now = DateFormat('HHmmss').format(DateTime.now()).toString();
    var event = '$now $s';
    await FileManager.writeToLog(event);
  }

  static start() async {
    /*
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String model = 'Error getting model';
    String version = 'Error getting OS version';
    String platform = Platform.operatingSystem;
    if (Platform.isIOS == true) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      //TODO get IOS stuff here
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      model = androidInfo.model;
      version = androidInfo.version.release;
    }

    var now = DateFormat('yyyyMMdd-HHmmss').format(DateTime.now()).toString();
    PackageInfo package = await PackageInfo.fromPlatform();
    await FileManager.writeToLog('Session $now, v: ${package.version}, $model, $platform $version');*/
  }
}
