import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:formgalley/Forms/Base/formExport.dart';
import 'package:formgalley/Utilities/util.dart';
import 'package:formgalley/fileManager.dart';
import 'package:formgalley/db.dart';
import 'package:async/async.dart';

class PdfEngine {
  static CancelableOperation _cancellableOperation;

  static Future<String> generatePdf(String html, FormBase form) async {
    var generatedPdfFile;
    const maxAttempts = 5;
    int attempt;

    for (attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
          html,
          await FileManager.getFilePath(),
          FileManager.createFileName(form.id),
        ).timeout(const Duration(seconds: 3));
         break; //Success, leave the loop
      } on TimeoutException catch (e) {
        print('Timed out attempt $attempt');
      } on Error catch (e) {
        print(e);
      }
    }
    print('Finished after attempt $attempt.');

    if (attempt >= maxAttempts) {
      return 'timeout';
    } else {
      await DB.saveFormDataLocalDb(form, generatedPdfFile.path);
      return generatedPdfFile.path;
    }
  }

  Future<bool> _waitForReload(Future<dynamic> future) async {
    _cancellableOperation = CancelableOperation.fromFuture(future, onCancel: () {});
    return true;
  }
}
