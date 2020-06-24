import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/User/data.dart';
import 'package:formgalley/Utilities/util.dart';
import 'package:formgalley/constants.dart';

import '../../options.dart';

class InputDropdown extends StatefulWidget {
  final ValueNotifier<String> input; //Disposed in parent
  final Data data; //Should only be read from this class
  final Function onChanged;

  InputDropdown({@required this.input, @required this.data, @required this.onChanged});

  @override
  _InputDropdownState createState() => _InputDropdownState();
}

class _InputDropdownState extends State<InputDropdown> {
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
                    child: Padding(padding: const EdgeInsets.only(left: 8), child: getDropdown()),
                  ),
                ),
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
        );
      },
    );
  }

  void clear() {
    widget.input.value = '';
    //Run the callback to update the changed list to rebuild the collection view (for the save button)
    widget.onChanged(widget.input.value != widget.data.getDisplayValue());
  }

  Color getTextColor() {
    Color out;
    Options.instance.useDarkTheme ? out = Colors.white : out = Colors.black;
    return out;
  }

  Widget getDropdown() {
    if (Platform.isIOS) {
      return Text('Need to implement iOS dropdown still');
    } else {
      return Material(
        color: Colors.transparent,
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            //https://github.com/flutter/flutter/issues/9211#issuecomment-532806508
            isDense: true,
            style: TextStyle(
              fontSize: 15,
              color: getTextColor(),
            ),
            dropdownColor: Options.instance.getCurrentTheme().primaryContrastingColor,
            iconEnabledColor: Colors.white,
            hint: Text(
              'Select...',
              style: TextStyle(
                fontFamily: Options.instance.getCurrentTheme().textTheme.textStyle.fontFamily,
                fontSize: Options.instance.getCurrentTheme().textTheme.textStyle.fontSize,
                color: Colors.white30,
              ),
            ),
            value: widget.input.value == '' ? null : widget.input.value,
            items: Util.createDropdownMenuItems(widget.data.dropdownOptions),
            selectedItemBuilder: (BuildContext context) {
              return widget.data.dropdownOptions.map<Widget>((String item) {
                return Text(
                  item,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: TextStyle(
                    fontFamily: Options.instance.getCurrentTheme().textTheme.textStyle.fontFamily,
                    fontSize: Options.instance.getCurrentTheme().textTheme.textStyle.fontSize,
                    color: Colors.white,
                  ),
                );
              }).toList();
            },
            onChanged: (newValue) {
              widget.input.value = newValue;
              widget.onChanged(newValue != widget.data.getDisplayValue());
            },
            isExpanded: true,
          ),
        ),
      );
    }
  }
}
