import 'package:connectivity/connectivity.dart';

class Connection {
  static Future<void> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult.toString());
  }
}
