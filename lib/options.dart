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
    barBackgroundColor: Colors.black, //Allows for transparency
    scaffoldBackgroundColor: const Color(0xff000000),
    primaryContrastingColor: Colors.grey[900],

  );

  CupertinoThemeData lightTheme = CupertinoThemeData(
    barBackgroundColor: Colors.grey[100],
    scaffoldBackgroundColor: Colors.grey[100],
  );

  CupertinoThemeData getCurrentTheme() {
    if (useDarkTheme) {
      return darkTheme;
    } else {
      return lightTheme;
    }
  }

  CupertinoThemeData switchTheme() {
    Options.instance.useDarkTheme = !Options.instance.useDarkTheme;
    SystemChrome.setSystemUIOverlayStyle(Options.instance.useDarkTheme ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);

    Log.write('Switched theme to ${Options.instance.useDarkTheme ? 'dark' : 'light'}.');
    return getCurrentTheme();
  }

  Future<void> saveOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  bool useDarkTheme = true;
}
