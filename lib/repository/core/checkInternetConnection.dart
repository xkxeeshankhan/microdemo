import 'dart:io';

class CheckInternetConnection {
  Future<bool> checkConnection() async {
    try {
      ///TODO: not sure => change it to the connectivity
      await InternetAddress.lookup("www.google.com");
      return true;
    } on SocketException catch (e) {
      print("Socket Exception");
      return false;
    }
  }
}
