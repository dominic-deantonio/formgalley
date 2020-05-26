import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:share_extend/share_extend.dart';

//Make this a separate class file
class PdfView extends StatefulWidget {
  final pdfPath;

  PdfView({this.pdfPath});

  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  @override
  Widget build(context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('View the PDF'),
      ),
      child: Center(
        child: PdfViewer(
          filePath: widget.pdfPath,
        ),
      ),
    );
  }
}
