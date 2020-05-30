import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/fileManager.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:share_extend/share_extend.dart';

//Make this a separate class file
class PdfView extends StatefulWidget {
  final pdf;

  PdfView({this.pdf});

  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  @override
  Widget build(context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        border: Border(),
        backgroundColor: Colors.white,
        trailing: CupertinoButton(
          padding: EdgeInsets.all(0),
          child: Platform.isIOS ? Icon(CupertinoIcons.share_solid) : Icon(Icons.share),
          onPressed: () async => FileManager.sendFile(widget.pdf),
        ),
      ),
      child: Center(
        child: PdfViewer(
          filePath: widget.pdf['path'],
        ),
      ),
    );
  }
}
