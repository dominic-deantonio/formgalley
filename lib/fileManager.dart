import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

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
      print('Deleted $path from the directory');
      return true;
    } catch (err) {
      print('Failed to delete $path from directory');
      return false;
    }
  }

  static Future<void> sendFile(var f) async {
    ShareExtend.share(
      f['path'],
      'file',
      sharePanelTitle: 'Send this ${f['formName']}',
      subject: f['formName'],
    );
  }
}
