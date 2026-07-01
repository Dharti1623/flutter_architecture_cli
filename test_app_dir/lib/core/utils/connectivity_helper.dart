import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityHelper {
  static final ConnectivityHelper _instance = ConnectivityHelper._internal();
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  factory ConnectivityHelper() => _instance;

  ConnectivityHelper._internal() {
    _connectivity.onConnectivityChanged.listen((results) {
      // For newer versions of connectivity_plus, it returns List<ConnectivityResult>
      final hasConnection =
          results.isNotEmpty && !results.contains(ConnectivityResult.none);
      _controller.add(hasConnection);
    });
  }

  Stream<bool> get onConnectivityChanged => _controller.stream;

  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result.isNotEmpty && !result.contains(ConnectivityResult.none);
  }
}
