import 'dart:async';
import 'dart:io';
import 'package:formgalley/constants.dart';
import 'package:formgalley/log.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

import 'Forms/Base/completedForm.dart';

class FileManager {
  static Future<String> getFilePath() async {
    Directory targetDirectory = await getApplicationDocumentsDirectory();
    var targetPath = targetDirectory.path;
    return targetPath;
  }

  static String createFileName(String formName) {
    var dateFormat = DateFormat('yyyyMMddHHmmss');
    var uniqueTag = dateFormat.format(DateTime.now()).toString();
    formName = formName.replaceAll(' ', '');
    var targetFileName = '$formName-$uniqueTag';
    return targetFileName;
  }

  static Future<List<FileSystemEntity>> getAllPDFs() async {
    Directory directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> found = directory.listSync();
    var pdfs = List<FileSystemEntity>();

    for (var file in found) {
      if (file.path.endsWith('.pdf')) {
        pdfs.add(file);
      }
    }

    print('Retrieved ${pdfs.length} files from system.');
    return pdfs;
  }

  static Future<String> debugPrintCompletedForms() async {
    var forms = await getAllPDFs();
    var out = '${forms.length} completed forms exist in directory';
    print(out);
    return out;
  }

  static Future<bool> deleteFromDirectory(String path) async {
    FileSystemEntity file = File(path);

    try {
      await file.delete();
      print('Deleted file from directory.');
      return true;
    } catch (err) {
      print('Failed to delete file from directory.');
      return false;
    }
  }

  static Future<void> sendFile(CompletedForm f) async {
    ShareExtend.share(
      f.path,
      'file',
      sharePanelTitle: 'Send this ${f.formName}',
      subject: '${f.formName} sent from ${Constants.kAppName}',
    );
    print('Sent ${f.formName} using share panel');
  }

  //--------------------Logging
  static Future<void> writeToLog(String s) async {
    var path = await getFilePath();
    File log;
    try {
      log = File('$path/log.txt');
    } on FileSystemException {
      print('ji');
    }
    String entries = await log.readAsString();

    await log.writeAsString('$s\n' + entries);
  }

  static Future<void> clearLog() async {
    var path = await getFilePath();
    File log = File('$path/log.txt');
    await log.writeAsString('');
  }

  static Future<String> readLog() async {
    var path = await getFilePath();
    File log = File('$path/log.txt');
    String out = await log.readAsString();
    return out;
  }
}
