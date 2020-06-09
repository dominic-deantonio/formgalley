import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Formatters {
  static final List<TextInputFormatter> name = [
    LengthLimitingTextInputFormatter(35),
    WhitelistingTextInputFormatter(RegExp(r"[a-zA-Z. '-]")),
  ];

  static final List<TextInputFormatter> payGrade = [
    LengthLimitingTextInputFormatter(6),
    WhitelistingTextInputFormatter(RegExp(r"[a-zA-Z0-9-]")),
  ];

  static final List<TextInputFormatter> streetAddress = [
    LengthLimitingTextInputFormatter(35),
    WhitelistingTextInputFormatter(RegExp(r"[A-z0-9 ,.-]")),
  ];

  static final List<TextInputFormatter> zip = [
    LengthLimitingTextInputFormatter(10),
    WhitelistingTextInputFormatter(RegExp(r"[0-9\-]")),
  ];

  static final List<TextInputFormatter> apartment = [
    LengthLimitingTextInputFormatter(15),
    WhitelistingTextInputFormatter(RegExp(r"[A-z0-9 \,\.\-]")),
  ];

  static final List<TextInputFormatter> city = [
    LengthLimitingTextInputFormatter(25),
    WhitelistingTextInputFormatter(RegExp(r"[A-z0-9 ]")),
  ];

  static final List<TextInputFormatter> phone = [
    LengthLimitingTextInputFormatter(10),
    WhitelistingTextInputFormatter(RegExp(r"[0-9]")),
  ];

  static final List<TextInputFormatter> currency = [
    LengthLimitingTextInputFormatter(30),
    WhitelistingTextInputFormatter(RegExp(r'^[0-9\.\,]*$')),
  ];

  static List<TextInputFormatter> numeric(int length) {
    return <TextInputFormatter>[
      LengthLimitingTextInputFormatter(length),
      WhitelistingTextInputFormatter(RegExp(r"[0-9]")),
    ];
  }




}
