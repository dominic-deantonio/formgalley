import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/User/data.dart';
import 'package:formgalley/constants.dart';

class InputText extends StatefulWidget {
  final ValueNotifier<String> input; //Disposed in parent
  final Data data; //Should only be read from this class
  final Function(bool) onChanged; //Updates the list depending on true or false

  InputText({@required this.input, @required this.data, @required this.onChanged});

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Visibility(
                      visible: widget.data.inputMethod == InputMethod.currency,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text('\$'),
                      ),
                    ),
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
                          onChanged: (v) {
                            widget.input.value = v;
                            widget.onChanged(v != widget.data.getDisplayValue());
                          },
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
    controller.text = '';
    //Run the callback to update the changed list to rebuild the collection view (for the save button)
    widget.onChanged(controller.value.text != widget.data.getDisplayValue());
  }

  void unfocus() {
    controller.text = startingValue;
    widget.input.value = startingValue;
    node.unfocus();
  }

  void focus(bool hasFocus) {
    setState(() => hasFocus ? subtract = 60 : subtract = 0);
    startingValue = widget.input.value;
  }
}
