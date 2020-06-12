import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/options.dart';

class StandardButton extends StatefulWidget {
  final Function onTap;
  final Widget leading;
  final String title;
  final String subTitle;
  final bool allowWrap;
  final String trailing;
  final Color color;
  final Widget superTrailing;

  StandardButton({
    this.title,
    this.subTitle,
    this.onTap,
    this.leading,
    this.trailing,
    this.color,
    this.superTrailing,
    this.allowWrap = true,
  });

  @override
  _StandardButtonState createState() => _StandardButtonState();
}

class _StandardButtonState extends State<StandardButton> {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () => widget.onTap != null ? widget.onTap() : print('No callback given'),
      padding: EdgeInsets.only(top: 8, left: 8, right: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Options.instance.getCurrentTheme().primaryContrastingColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      widget.leading ?? Container(),
                      widget.leading == null ? Container() : SizedBox(width: 10),
                      Text(
                        widget.title ?? '',
                        style: TextStyle(
                          fontSize: 17,
                          color: Options.instance.getCurrentTheme().textTheme.actionTextStyle.color,
                        ),
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        widget.trailing ?? '',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      widget.superTrailing ??
                          Icon(
                            CupertinoIcons.forward,
                            size: 12,
                            color: Colors.grey,
                          ),
                    ],
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: widget.subTitle != null
                    ? Text(
                        widget.subTitle,
                        softWrap: widget.allowWrap,
                        //overflow: widget.allowWrap ? TextOverflow.clip : TextOverflow.fade, //Must clip to allow wrap
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
