import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/User/data.dart';
import 'package:formgalley/Widgets/inputs/inputs.dart';

class DataCard extends StatelessWidget {
  final Data data;
  String initialValue; //Only update this when the inputNotifier in state is updated
  final Function(bool) onChanged;
  final ValueNotifier<String> input = ValueNotifier<String>('');

  DataCard(this.data, {this.onChanged}) {
    initialValue = data.getDisplayValue();
    input.value = data.getDisplayValue();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: ValueListenableBuilder(
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
                  Text(data.title, style: TextStyle(color: Colors.white)),
                  SizedBox(height: 5),
                  getInput(),
                  SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(data.prompt, style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

//class DataCard extends StatefulWidget {
//  final Data data;
//  String currentValue; //Only update this when the inputNotifier in state is updated
//  final Function(bool) onChanged;
//
//  DataCard(this.data, {this.onChanged}) {
//    currentValue = data.getDisplayValue();
//  }
//
//  @override
//  _DataCardState createState() => _DataCardState();
//}
//
//class _DataCardState extends State<DataCard> {
//  final ValueNotifier<String> input = ValueNotifier<String>('');
//
//  @override
//  void initState() {
//    super.initState();
//    input.value = widget.data.getDisplayValue();
//  }
//
//  @override
//  void dispose() {
//    input.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
//      child: ValueListenableBuilder(
//        valueListenable: input,
//        builder: (context, value, child) {
//          return AnimatedContainer(
//            duration: Duration(milliseconds: 250),
//            decoration: BoxDecoration(
//              borderRadius: BorderRadius.circular(10),
//              color: getColor(value),
//            ),
//            child: Padding(
//              padding: const EdgeInsets.all(10),
//              child: Column(
//                mainAxisSize: MainAxisSize.min,
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Text(
//                    widget.data.title,
//                    style: TextStyle(color: Colors.white),
//                  ),
//                  SizedBox(height: 5),
//                  getInput(),
//                  SizedBox(height: 5),
//                  Align(
//                    alignment: Alignment.centerLeft,
//                    child: Text(widget.data.prompt, style: TextStyle(color: Colors.white)),
//                  ),
//                ],
//              ),
//            ),
//          );
//        },
//      ),
//    );
//  }

  Color getColor(String value) {
    if (data.isAdequate(value)) {
      if (value == data.getDisplayValue()) {
//        return CupertinoColors.activeBlue;
        return const Color(0xff5E85C1);
      } else {
//        return CupertinoColors.systemGreen;
        return const Color(0xff429A80);
      }
    } else {
      return CupertinoColors.inactiveGray;
    }
  }

  Widget getInput() {
    switch (data.inputMethod) {
      case InputMethod.text:
        return InputText(
          data: data,
          input: input,
          onChanged: (changed) => onChanged(changed),
        );
        break;
      case InputMethod.currency:
        return InputText(
          data: data,
          input: input,
          onChanged: (changed) => onChanged(changed),
        );
        break;
      case InputMethod.dropdown:
        return InputDropdown(
          data: data,
          input: input,
          onChanged: (changed) => onChanged(changed),
        );
        break;
      case InputMethod.date:
        return InputDate(
          data: data,
          input: input,
          onChanged: (changed) => onChanged(changed),
        );
        break;
      default:
        return Text('Error producing input for ${data.title}');
        break;
    }
  }
}
