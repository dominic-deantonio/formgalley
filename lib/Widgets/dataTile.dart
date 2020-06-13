import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:formgalley/User/data.dart';
import 'package:formgalley/Utilities/util.dart';
import 'package:async/async.dart';
import 'package:formgalley/options.dart';

class DataTile extends StatefulWidget {
  final Data data;
  final ValueNotifier<String> userInputNotifier = ValueNotifier<String>(''); //Can't be final. Will need to set when changed
  final ValueNotifier<List<Data>> changedDataNotifier;
  final ValueNotifier<Color> colorNotifier = ValueNotifier<Color>(Colors.white);

  String getUserInput() {
    if (userInputNotifier.value == '' && data.inputMethod == InputMethod.dropdown) {
      userInputNotifier.value = null;
    }
    return userInputNotifier.value;
  }

  String setUserInput(String input) => userInputNotifier.value = input;

  DataTile({
    @required this.data,
    @required this.changedDataNotifier,
  });

  void updateTileChangedStatus() {
    String val = getUserInput();
    Color lightBlue = Options.instance.getCurrentTheme().primaryColor;
    Color lightGreen = CupertinoColors.systemGreen;

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
      colorNotifier.value = Colors.grey[900];
    }
  }

  @override
  _DataTileState createState() => _DataTileState();
}

class _DataTileState extends State<DataTile> {
  Data data;
  TextEditingController textController = TextEditingController();
  int rebuildTimer; //Stop the onChanged from rebuilding too much
  CancelableOperation _cancellableOperation;
  final Color kWhite = Colors.white;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {
    data = widget.data;

    //Sets the initial field value if data pulled something from db.
    if (data.getValue() != null && data.getValue() != '') {
      widget.setUserInput(data.getValue());
      textController.text = widget.userInputNotifier.value;
    }
    widget.updateTileChangedStatus();
  }

  void clear() {
    setState(() {
      widget.setUserInput('');
      textController.text = widget.userInputNotifier.value;
    });
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
          padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 9),
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
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17, color: kWhite),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: _buildInput(context),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: widget.userInputNotifier,
                        builder: (BuildContext context, String input, Widget child) {
                          if (input == null || input == '') {
                            return Container();
                          } else {
                            return GestureDetector(
                              onTap: () {
                                clear();
                              },
                              child: Icon(CupertinoIcons.clear_thick, color: Colors.red),
                            );
//                            return GestureDetector(
//                              child: Icon(CupertinoIcons.clear_thick, color: Colors.red),
//                            );
                          }
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text(
                      data.prompt,
                      style: TextStyle(fontSize: 15, color: kWhite),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
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
    if (widget.userInputNotifier.value != '') showClearButton = OverlayVisibilityMode.always;

    switch (data.inputMethod) {
      case InputMethod.text:
        return Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: CupertinoTextField(
            keyboardType: data.textInputType,
            placeholder: data.hintText.toString(),
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15, color: kWhite),
            decoration: BoxDecoration(),
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
        return Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Row(
            children: <Widget>[
              Text('\$', style: TextStyle(fontSize: 15, color: kWhite)),
              Expanded(
                child: CupertinoTextField(
                  keyboardType: data.textInputType,
                  placeholder: data.hintText.toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15, color: kWhite),
                  decoration: null,
                  controller: textController,
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
          return Text("Not implemented yet");
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
                        style: TextStyle(
                          fontSize: 15,
                          color: Options.instance.useDarkTheme ? kWhite: Colors.black,
                        ),
                        dropdownColor: Options.instance.getCurrentTheme().scaffoldBackgroundColor,
                        iconEnabledColor: Colors.white,
                        hint: Text(
                          'Select...',
                          style: TextStyle(color: Colors.grey[300]),
                        ),
                        value: selected,
                        items: Util.createDropdownMenuItems(data.dropdownOptions),
                        selectedItemBuilder: (BuildContext context) {
                          return data.dropdownOptions.map<Widget>((String item) {
                            return Text(
                              item,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: TextStyle(color: kWhite),
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
                ],
              ),
            ),
          );
        }
        break;
      case InputMethod.date:
        DateTime selectedDate;
        String displayValue = widget.userInputNotifier.value;
        DateTime initialDate = DateTime.now();

        void _processDate() {
          widget.setUserInput(Util.getStringStorageFormatFromDate(selectedDate));
          setState(() {
            displayValue = Util.formatDisplayDate(selectedDate);
          });
        }

        if (displayValue == '') {
          displayValue = 'Select...';
        } else {
          initialDate = Util.getDateFromStringStorageFormat(widget.userInputNotifier.value);
          displayValue = Util.formatDisplayDate(initialDate);
        }

        return GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(width: 195, child: Text(displayValue, style: TextStyle(color: kWhite, fontSize: 15))),
              Icon(
                Icons.arrow_drop_down,
                color: kWhite,
              ),
              SizedBox(width: 15),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    ' Today',
                    style: TextStyle(color: kWhite, fontSize: 15),
                  ),
                ),
                onTap: () {
                  selectedDate = DateTime.now();
                  _processDate();
                  widget.updateTileChangedStatus();
                },
              ),
              Expanded(child: Container()),
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
