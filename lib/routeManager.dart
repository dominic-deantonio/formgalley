//import 'package:flutter/material.dart';
//import 'package:formgalley/Views/viewsExporter.dart';
//
//class RouteManager {
//  static Route<dynamic> generateRoute(RouteSettings settings) {
//    //Reference https://resocoder.com/2019/04/27/flutter-routes-navigation-parameters-named-routes-ongenerateroute/
//    final args = settings.arguments;
//
//    switch (settings.name) {
////      case '/': //Initial route by convention
////        return MaterialPageRoute(builder: (_) => SplashScreen());
////      case '/welcome': //Initial route by convention
////        return MaterialPageRoute(builder: (_) => WelcomeScreen());
//      case '/getUserInfo':
//        return MaterialPageRoute(builder: (_) => CollectionView(selForm: args, onStartProcessing: (out){},));
//      case '/viewPdf':
//        if(args is String)
//          return MaterialPageRoute(builder: (_) => PdfView(pdfPath: args));
//
//          return _errorRoute(); //else
//
//      case '/viewForms':
//        return MaterialPageRoute(builder: (_) => FilesView());
//      case '/viewProcessing':
//        return MaterialPageRoute(builder: (_) => ProcessingView(formToBuild: args));
//      default:
//      // If there is no such named route in the switch statement, e.g. /third
//        return _errorRoute();
//    }
//  }
//
//  static Route<dynamic> _errorRoute() {
//    return MaterialPageRoute(builder: (_) {
//      return Scaffold(
//        appBar: AppBar(
//          title: Text('Error'),
//        ),
//        body: Center(
//          child: Text('ERROR'),
//        ),
//      );
//    });
//  }
//}