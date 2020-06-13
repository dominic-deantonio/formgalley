import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/User/data.dart';
import 'package:formgalley/constants.dart';

class InputText extends StatefulWidget {
  final ValueNotifier<String> input; //Disposed in parent
  final Data data; //Should only be read from this class

  InputText({@required this.input, @required this.data});

  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  final TextEditingController controller = TextEditingController();
  double subtract = 0;
  bool displayCancelText = false;
  FocusNode node = FocusNode();
  String startingValue;

  @override
  void initState() {
    super.initState();
    widget.input.value = widget.data.getDisplayValue();
    controller.text = widget.input.value;
    startingValue = widget.input.value; //Make sure to override this at focus/unfocus
  }

  @override
  void dispose() {
    node.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///Made the cancel button able to slide in and out by resizing textinput, placing in listview ;)
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: Constants.kMinInteractiveDimension,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(milliseconds: 150),
                width: constraints.maxWidth - subtract,
                height: Constants.kMinInteractiveDimension,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black12),
//                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Focus(
                        onFocusChange: (hasFocus) => focus(hasFocus),
                        child: CupertinoTextField(
                          focusNode: node,
                          keyboardType: widget.data.textInputType,
                          placeholder: widget.data.hintText.toString(),
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.white),
                          decoration: null,
                          inputFormatters: widget.data.inputFormatters,
                          controller: controller,
                          onChanged: (v) => widget.input.value = v,
                        ),
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
              CupertinoButton(
                padding: EdgeInsets.only(left: 10),
                onPressed: () => unfocus(),
                child: Container(
                  child: Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void clear() {
    widget.input.value = '';
    controller.clear();
  }

  void unfocus() {
    controller.text = startingValue;
    widget.input.value = startingValue;
    node.unfocus();
  }

  void focus(bool hasFocus) {
    hasFocus ? subtract = 60 : subtract = 0;
    startingValue = widget.input.value;
  }
}
