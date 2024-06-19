import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionStatusSingleton {
  static final ConnectionStatusSingleton _connectionStatusSingleton = ConnectionStatusSingleton._internal();

  ConnectionStatusSingleton._internal();

  //This is what's used to retrieve the instance through the app
  static ConnectionStatusSingleton getInstance() => _connectionStatusSingleton;

  //This tracks the current connection status
  bool hasConnection = false;

  // subscribing to connection changes
  StreamController connectionChangeController = StreamController.broadcast();

  // flutter connectivity
  final Connectivity _connectivity = Connectivity();

  // listen for change and check the connection status out of the gate
  void initialize() {
    _connectivity.onConnectivityChanged.listen((event) {
      checkConnection();
    });
    checkConnection();
  }

  Stream get connectionChange => connectionChangeController.stream;

  void dispose() {
    connectionChangeController.close();
  }

  // flutter _connectivity's listener
  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  // test & check connection
  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    // The connection status changed send out an update to all listeners
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }
    return hasConnection;
  }
}
