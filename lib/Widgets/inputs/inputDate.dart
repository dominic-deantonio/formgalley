import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/User/data.dart';
import 'package:formgalley/Utilities/util.dart';
import 'package:formgalley/constants.dart';

import '../../options.dart';

class InputDate extends StatefulWidget {
  final ValueNotifier<String> input; //Disposed in parent
  final Data data; //Should only be read from this class

  InputDate({@required this.input, @required this.data});

  @override
  _InputDateState createState() => _InputDateState();
}

class _InputDateState extends State<InputDate> {
  double subtract = 0;
  bool displayCancelText = false;
  FocusNode node = FocusNode();
  String startingValue;

  @override
  void initState() {
    super.initState();
    widget.input.value = widget.data.getDisplayValue();
    startingValue = widget.input.value; //Make sure to override this at focus/unfocus
  }

  @override
  void dispose() {
    node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: Constants.kMinInteractiveDimension,
          child: GestureDetector(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 150),
              width: constraints.maxWidth - subtract,
              height: Constants.kMinInteractiveDimension,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: widget.input.value == ''
                            ? Text(
                                'Select...',
                                style: TextStyle(color: Colors.white30),
                              )
                            : Text(Util.formatDisplayDate(Util.getDateFromStringStorageFormat(widget.input.value))),
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.white),
                  Visibility(
                    visible: widget.input.value != '',
                    child: CupertinoButton(
                      padding: EdgeInsets.all(0),
                      child: Icon(CupertinoIcons.clear_thick_circled, color: Colors.white54),
                      onPressed: () => clear(),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () async {
              if (Platform.isIOS) {
                //date = CupertinoDatePicker();
              } else {
                DateTime init =
                    widget.input.value != '' ? Util.getDateFromStringStorageFormat(widget.input.value) : DateTime.now();
                DateTime date = await showDatePicker(
                  context: context,
                  initialDate: init,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2200),
                );
                date == null ? widget.input.value = widget.input.value : widget.input.value = Util.getStringStorageFormatFromDate(date);
              }
            },
          ),
        );
      },
    );
  }

  void clear() {
    widget.input.value = '';
  }

  Color getTextColor() {
    Color out;
    Options.instance.useDarkTheme ? out = Colors.white : out = Colors.black;
    return out;
  }
}
