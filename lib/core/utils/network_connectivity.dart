import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkConnectivity {
  NetworkConnectivity._();
  static final _instance = NetworkConnectivity._();
  static NetworkConnectivity get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;

  // Check initial connectivity state
  Future<bool> initialise() async {
    final result = await _connectivity.checkConnectivity();
    _checkStatus(result.first);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result.first);
    });
    return await checkInternet();
  }

  // Check realtime connectivity status
  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add(isOnline);
  }

  // Method to actively check current internet connectivity
  Future<bool> checkInternet() async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    return isOnline;
  }

  // Dispose the stream controller
  void disposeStream() => _controller.close();
}
