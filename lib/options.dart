import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/log.dart';

class Options {
  static final Options instance = Options._privateConstructor();

  Options._privateConstructor() {
    //These aren't new instances
  }

  //https://devblog.axway.com/mobile-apps/adding-transparent-background/

  CupertinoThemeData darkTheme = CupertinoThemeData(
    brightness: Brightness.dark,
    barBackgroundColor: const Color(0xff000000),
    scaffoldBackgroundColor: const Color(0xff000000),
    primaryContrastingColor: Colors.grey[900],
    textTheme: CupertinoTextThemeData(
      textStyle: TextStyle(color: Colors.white),
      actionTextStyle: TextStyle(color: Colors.red),
      dateTimePickerTextStyle: TextStyle(color: Colors.purple),
      navActionTextStyle: TextStyle(color: Colors.orange),

    ),
  );

  CupertinoThemeData lightTheme = CupertinoThemeData(
    barBackgroundColor: Colors.grey[100],
    scaffoldBackgroundColor: Colors.grey[100],
    textTheme: CupertinoTextThemeData(textStyle: TextStyle(color: Colors.white)),
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
    Log.write('Switched theme to ${Options.instance.useDarkTheme ? 'dark' : 'light'}.');
    return getCurrentTheme();
  }

  bool useDarkTheme = true;
}
