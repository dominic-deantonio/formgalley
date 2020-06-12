import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/db.dart';
import 'package:formgalley/Forms/Base/formExport.dart';
import 'package:formgalley/pdfEngine.dart';

class ProcessingView extends StatefulWidget {
  final FormBase formToBuild;
  final Function(dynamic) viewPdfCallback;
  final Function(Exception, String) onException;

  ProcessingView({@required this.formToBuild, @required this.viewPdfCallback, @required this.onException});

  @override
  _ProcessingViewState createState() => new _ProcessingViewState();
}

class _ProcessingViewState extends State<ProcessingView> {
  bool processing = true;
  String status = 'Downloading form content';
  CompletedForm newPdf;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    try {
      List<String> formHTML = await DB.getFormFromFirebase(widget.formToBuild).timeout(Duration(seconds: 10));
      setState(() => status = 'Assigning data');
      await widget.formToBuild.assignData().timeout(Duration(seconds: 10));
      setState(() => status = 'Building form');
      String newHtml = await widget.formToBuild.buildForm(formHTML[0]).timeout(Duration(seconds: 10));
      newPdf = await PdfEngine.generatePdf(newHtml, widget.formToBuild);
      setState(() {
        status = 'Done - form saved.';
        processing = false;
      });
    } catch (e) {
      widget.onException(e, 'initialize processing view');
    }
  }

  @override
  Widget build(context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: processing
            ? Text('')
            : CupertinoButton(
                padding: EdgeInsets.all(0),
                child: Text('Back'),
                onPressed: () => Navigator.of(context).pop(),
              ),
        border: Border(),
//        backgroundColor: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          Expanded(child: Container()),
          Center(child: processing ? CupertinoActivityIndicator() : Container()),
          Text(status),
          Expanded(child: Container()),
          processing
              ? Container()
              : CupertinoButton(
                  child: Text('View PDF'),
                  onPressed: () async {
                    widget.viewPdfCallback(newPdf);
                  },
                ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
