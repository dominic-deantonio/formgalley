import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/User/data.dart';
import 'package:formgalley/Widgets/inputs/inputs.dart';

class DataCard extends StatefulWidget {
  final Data data;

  DataCard(this.data);

  @override
  _DataCardState createState() => _DataCardState();
}

class _DataCardState extends State<DataCard> {
  final ValueNotifier<String> input = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    input.value = widget.data.getDisplayValue();
  }

  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: input,
      builder: (context, value, child) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 250),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: getColor(value),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.data.title,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 5),
                getInput(),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(widget.data.prompt, style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color getColor(String value) {
    if (widget.data.isAdequate(value)) {
      if (value == widget.data.getDisplayValue()) {
        return CupertinoColors.activeBlue;
      } else {
        return CupertinoColors.systemGreen;
      }
    } else {
      return CupertinoColors.inactiveGray;
    }
  }

  Widget getInput() {
    switch (widget.data.inputMethod) {
      case InputMethod.text:
        return InputText(data: widget.data, input: input);
        break;
      case InputMethod.currency:
        return InputText(data: widget.data, input: input);
        break;
      case InputMethod.dropdown:
        return InputDropdown(data: widget.data, input: input);
        break;
      case InputMethod.date:
        return InputDate(data: widget.data, input: input);
        break;
      default:
        return Text('Error producing input for ${widget.data.title}');

        break;
    }
  }
}
