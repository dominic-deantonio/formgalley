import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formgalley/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Options {
  static final Options instance = Options._privateConstructor();

  Options._privateConstructor() {
    //These aren't new instances
  }

  //https://devblog.axway.com/mobile-apps/adding-transparent-background/

  CupertinoThemeData darkTheme = CupertinoThemeData(
    brightness: Brightness.dark,
    barBackgroundColor: const Color(0xCC1A1A1A),
    scaffoldBackgroundColor: const Color(0xff1A1A1A),
    primaryContrastingColor: Colors.grey[900],
    primaryColor: CupertinoColors.activeBlue,
  );

  CupertinoThemeData lightTheme = CupertinoThemeData(
    barBackgroundColor: Colors.grey[100],
    scaffoldBackgroundColor: Colors.grey[100],
  );

  bool useDarkTheme = false;

  CupertinoThemeData getCurrentTheme() {
    if (useDarkTheme) {
      return darkTheme;
    } else {
      return lightTheme;
    }
  }

  CupertinoThemeData switchTheme() {
    useDarkTheme = !useDarkTheme;
    SystemChrome.setSystemUIOverlayStyle(useDarkTheme ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);


    print('Switched theme to ${useDarkTheme ? 'dark' : 'light'}.');

    return getCurrentTheme();
  }

  Future<void> saveOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }

}
