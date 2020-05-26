import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formgalley/Widgets/widgetExporter.dart';
import 'dart:io';


enum InputMethod { text, dropdown, boolean, date, time, currency }

class Data {
  //Constructor
  Data({
    this.value,
    @required this.title,
    @required this.prompt,
    @required this.usedInForms,
    this.inputFormatters,
    this.minRequiredChars = 1,
    this.databaseId = 100,
    this.hintText = 'Default',
    this.inputMethod = InputMethod.text,
    this.dropdownOptions = List,
    this.textInputType = TextInputType.text,
    this.obscureText = false,
    this.tempId = 'notTempData',
  });

  var value; //The actual value of the data
  var hintText; //This will fill the input field when the value is empty
  String title; //The title of the data, not of the user (e.g. "First name")
  String prompt; //Question or prompt for user to answer (to get data)
  bool obscureText; //If this data requires text to be obscured
  InputMethod inputMethod; //Dropdown? text? boolean?
  var dropdownOptions; //If the item is a dropdown, what are the options?
  TextInputType textInputType; //What type of input field this data requires
  List<String> usedInForms; //List of the forms which use this data element
  String tempId; //If temporary object need to reconnect to the form map, also used to identify what is/not tempData
  int databaseId; //Used for faster lookups in the database instead of using string-based
  List<TextInputFormatter> inputFormatters; //Used to check the input as user is typing
  int minRequiredChars; //The number of characters required to considered complete

  @override //Allows variable to be called directly instead of using a method
  String toString() {
    var s = 'Title: $title\nValue: ${value.toString()}\nTempID: $tempId';
    return s.toString();
  }

  String getValue() {
    var x = value ?? '';
    if (inputMethod == InputMethod.dropdown && x == '') return null; //Null required to show hint
    return x.toString();
  }

  String getPrintValue() {
    var x = value ?? '';
    return x.toString();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': databaseId,
      'value': getValue(),
    };
  }

  void setValue(var val) {
    inputMethod == InputMethod.dropdown && val == '' ? value = null : value = val;
  }
}
