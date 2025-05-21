import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectivityStatus { connected, disconnected }

class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  final Connectivity _connectivity = Connectivity();

  ConnectivityCubit() : super(ConnectivityStatus.connected) {
    _init();
  }

  void _init() {
    checkInitialConnection();

    _connectivity.onConnectivityChanged.listen(
            (List<ConnectivityResult> results) {
      final isDisconnected = results.contains(ConnectivityResult.none);
      final newState = isDisconnected
          ? ConnectivityStatus.disconnected
          : ConnectivityStatus.connected;

      if (state != newState) emit(newState);
    });
  }

  Future<void> checkInitialConnection() async {
    final results = await _connectivity.checkConnectivity();
    final isDisconnected = results.contains(ConnectivityResult.none);

    final newState = isDisconnected
        ? ConnectivityStatus.disconnected
        : ConnectivityStatus.connected;

    emit(newState);
  }
}
