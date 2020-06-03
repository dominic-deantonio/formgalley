import 'dart:async';
import 'dart:io';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:formgalley/Forms/Base/formExport.dart';
import 'package:formgalley/fileManager.dart';
import 'package:formgalley/db.dart';

class PdfEngine {
  static Future<CompletedForm> generatePdf(String html, FormBase formBase) async {
    File generatedFile;
    CompletedForm completedForm;
    const maxAttempts = 5;
    int attempt;

    for (attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        generatedFile = await FlutterHtmlToPdf.convertFromHtmlContent(
          html,
          await FileManager.getFilePath(),
          FileManager.createFileName(formBase.formName),
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
      return null;
    } else {
      completedForm = await DB.saveFormDataLocalDb(formBase, generatedFile.path);
      return completedForm;
    }
  }
}
