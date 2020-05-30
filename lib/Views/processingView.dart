import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/db.dart';
import 'package:formgalley/Forms/Base/formExport.dart';
import 'package:formgalley/pdfEngine.dart';

class ProcessingView extends StatefulWidget {
  final FormBase formToBuild;
  final Function(String) onViewPdf;

  ProcessingView({@required this.formToBuild, @required this.onViewPdf});

  @override
  _ProcessingViewState createState() => new _ProcessingViewState();
}

class _ProcessingViewState extends State<ProcessingView> {
  bool processing = true;
  String status = 'Downloading form content';
  String location;

  @override
  void initState() {
    super.initState();
    //First, get the content from the database
    DB.getFormFromFirebase(widget.formToBuild).then((formHtmlList) {
      setState(() => status = 'Assigning data');

      widget.formToBuild.assignData().whenComplete(() {
        setState(() => status = 'Building form');

        widget.formToBuild.buildForm(formHtmlList[0]).then((newHtml) {
          setState(() => status = 'Generating PDF');

          PdfEngine.generatePdf(newHtml, widget.formToBuild).then((result) {
            location = result;
            setState(() {
              status = 'Processing complete';
              processing = false;
            });
          });
        });
      });
    });
  }

  @override
  Widget build(context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
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
                    widget.onViewPdf(location);
                  },
                ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
