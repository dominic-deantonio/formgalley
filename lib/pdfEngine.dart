import 'dart:async';
import 'dart:io';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:formgalley/Forms/Base/formExport.dart';
import 'package:formgalley/fileManager.dart';
import 'package:formgalley/db.dart';
import 'package:formgalley/log.dart';

class PdfEngine {
  static Future<CompletedForm> generatePdf(String html, FormBase formBase) async {
    await Log.write('Starting pdf generation.');
    File generatedFile;
    CompletedForm completedForm;
    const maxAttempts = 7;
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
        await Log.write('Failed pdf generation attempt $attempt.');
      } on Error catch (e) {
        await Log.write('An error occurred during pdf generation ${e.runtimeType}.');
        print(e);
      }
    }
    print('Finished after attempt $attempt.');
    await Log.write('Finished pdf generation after attempt $attempt.');

    if (attempt >= maxAttempts) {
      await Log.write('Exceeded maximum number of pdf generation attempts ($maxAttempts).');
      throw Exception();
    } else {
      completedForm = await DB.saveFormDataLocalDb(formBase, generatedFile.path);
      await Log.write('Saved pdf information in the device database.');
      return completedForm;
    }
  }
}
