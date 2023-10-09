import 'package:connectivity/connectivity.dart';

Future<bool> checkInternetConnectivity() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    return true; // Connected to the internet
  } else {
    return false; // Not connected to the internet
  }
}