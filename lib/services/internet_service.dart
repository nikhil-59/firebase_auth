import 'package:connectivity_plus/connectivity_plus.dart';

class InterentConnectionService {
  final Connectivity _connectivity = Connectivity();
  Stream<ConnectivityResult> get connection {
    return _connectivity.onConnectivityChanged;
  }
}
