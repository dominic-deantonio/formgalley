import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/User/data.dart';
import 'package:formgalley/Utilities/util.dart';
import 'package:async/async.dart';

class DataTile extends StatefulWidget {
  final Data data;
  String _userInput = ''; //Can't be final. Will need to set when changed
  final ValueNotifier<List<Data>> changedDataNotifier;
  final ValueNotifier<Color> colorNotifier = ValueNotifier<Color>(Colors.white);

  String getUserInput() {
    if (_userInput == '' && data.inputMethod == InputMethod.dropdown) {
      _userInput = null;
    }
    return _userInput;
  }

  String setUserInput(String input) => _userInput = input;

  DataTile({
    @required this.data,
    @required this.changedDataNotifier,
  });

  void updateTileChangedStatus() {
    String val = getUserInput();
    Color lightBlue = Color(0xffeff4ff);
    Color lightGreen = Color(0xffebffef);

    List<Data> newList = List.from(changedDataNotifier.value);
    if (val != data.getValue()) {
      if (!changedDataNotifier.value.contains(data)) {
        newList.add(data);
        changedDataNotifier.value = newList;
      }
    } else {
      if (changedDataNotifier.value.contains(data)) {
        newList.remove(data);
        changedDataNotifier.value = newList;
      }
    }

    if (val != null && val.length >= data.minRequiredChars) {
      //this should check the length
      if (val == data.getValue()) {
        colorNotifier.value = lightBlue;
      } else {
        colorNotifier.value = lightGreen;
      }
    } else {
      colorNotifier.value = Colors.grey[100];
    }
  }

  @override
  _DataTileState createState() => _DataTileState();
}

class _DataTileState extends State<DataTile> {
  Data data;
  TextEditingController textController = TextEditingController();
  int rebuildTimer; //Stop the onchanged from rebuilding too much
  CancelableOperation _cancellableOperation;

  @override
  void initState() {
    super.initState();
    data = widget.data;

    //Sets the initial field value if data pulled something from db.
    if (data.getValue() != null && data.getValue() != '') {
      widget.setUserInput(data.getValue());
      textController.text = widget.getUserInput();
    }
    widget.updateTileChangedStatus();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.colorNotifier,
      builder: (BuildContext context, Color clr, Widget child) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Card(
            elevation: 0,
            child: AnimatedContainer(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: clr),
              duration: Duration(milliseconds: 250),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      data.title,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: _buildInput(context),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text(
                        data.prompt,
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInput(BuildContext context) {
    //If editing or if displaying a value, allow clearing the value
    OverlayVisibilityMode showClearButton = OverlayVisibilityMode.editing;
    if (widget.getUserInput() != '') showClearButton = OverlayVisibilityMode.always;

    switch (data.inputMethod) {
      case InputMethod.text:
        return Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: CupertinoTextField(
            keyboardType: data.textInputType,
            clearButtonMode: showClearButton,
            placeholder: data.hintText.toString(),
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15),
            decoration: null,
            inputFormatters: data.inputFormatters,
            controller: textController,
            onChanged: (value) async {
              _cancellableOperation?.cancel();
              await _waitForReload(Util.waitMilliseconds(250));
              widget.setUserInput(value);
              widget.updateTileChangedStatus();
            },
          ),
        );
        break;
      case InputMethod.currency:
        TextEditingController controller;
        return Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Row(
            children: <Widget>[
              Text('\$', style: TextStyle(fontSize: 15)),
              Expanded(
                child: CupertinoTextField(
                  keyboardType: data.textInputType,
                  clearButtonMode: showClearButton,
                  placeholder: data.hintText.toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15),
                  decoration: null,
                  controller: controller,
                  inputFormatters: data.inputFormatters,
                  onSubmitted: (value) async {
                    _cancellableOperation?.cancel();
                    await _waitForReload(Util.waitMilliseconds(250));
                    widget.setUserInput(value);
                    widget.updateTileChangedStatus();
                  },
                ),
              ),
            ],
          ),
        );
        break;
      case InputMethod.dropdown:
        String selected = widget.getUserInput();

        if (Platform.isIOS) {
        } else {
          return Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(left: 3.0, right: 17),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        //https://github.com/flutter/flutter/issues/9211#issuecomment-532806508
                        isDense: true,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        dropdownColor: Colors.white,
                        hint: Text('Select...'),
                        value: selected,
                        items: Util.createDropdownMenuItems(data.dropdownOptions),
                        selectedItemBuilder: (BuildContext context) {
                          return data.dropdownOptions.map<Widget>((String item) {
                            return Text(
                              item,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                            );
                          }).toList();
                        },
                        onChanged: (newValue) {
                          setState(() {
                            widget.setUserInput(newValue);
                            selected = newValue;
                          });
                          widget.updateTileChangedStatus(); //Can be outside because notifies parent. Must come after
                        },
                        isExpanded: true,
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  selected == null
                      ? SizedBox(width: 18)
                      : GestureDetector(
                          onTap: () {
                            setState(() => widget.setUserInput(''));
                            selected = null;
                            widget.updateTileChangedStatus();
                          },
                          child: Icon(
                            CupertinoIcons.clear_thick_circled,
                            size: 18,
                            color: Colors.grey[700],
                          ),
                        ),
                ],
              ),
            ),
          );
        }
        break;
      case InputMethod.date:
        DateTime selectedDate;
        String displayValue = widget._userInput;
        DateTime initialDate = DateTime.now();
        TextStyle style;

        void _processDate() {
          widget.setUserInput(Util.getStringStorageFormatFromDate(selectedDate));
          setState(() {
            displayValue = Util.formatDisplayDate(selectedDate);
          });
        }

        if (displayValue == '') {
          displayValue = 'Select...';
          style = TextStyle(
            fontSize: 15,
            color: Colors.grey[400],
          );
        } else {
          initialDate = Util.getDateFromStringStorageFormat(widget._userInput);
          displayValue = Util.formatDisplayDate(initialDate);
          style = TextStyle(
            fontSize: 15,
            color: Colors.black,
          );
        }

        return GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(width: 195, child: Text(displayValue, style: style)),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.grey[800],
              ),
              SizedBox(width: 15),
              GestureDetector(
                child: Text(
                  ' Today',
                  style: TextStyle(fontSize: 15, color: Theme.of(context).primaryColorDark),
                ),
                onTap: () {
                  selectedDate = DateTime.now();
                  _processDate();
                  widget.updateTileChangedStatus();
                },
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(right: 16.5),
                child: widget.getUserInput() == ''
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          setState(() => widget.setUserInput(''));
                          widget.updateTileChangedStatus();
                        },
                        child: Icon(
                          CupertinoIcons.clear_thick_circled,
                          size: 18,
                          color: Colors.grey[700],
                        ),
                      ),
              ),
            ],
          ),
          onTap: () async {
            if (Platform.isIOS) {
              //selected = CupertinoDatePicker();
            } else {
              selectedDate = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(1900),
                lastDate: DateTime(2200),
              );
            }
            if (selectedDate != null) _processDate();
            widget.updateTileChangedStatus();
          },
        );

      default:
        return Text(
          'Error loading this input :(',
          style: TextStyle(fontSize: 15, color: Colors.red),
        );
        break;
    }
    return Text('error');
  }

  //This allows the user to type quickly without widget reloading so often.
  //Needed to update the tile color
  Future<bool> _waitForReload(Future<dynamic> future) async {
    _cancellableOperation = CancelableOperation.fromFuture(future, onCancel: () {});
    await Util.waitMilliseconds(250);
    return true;
  }
}
