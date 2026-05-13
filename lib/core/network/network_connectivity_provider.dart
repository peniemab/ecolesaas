import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'network_connectivity_status.dart';

final _connectivity = Connectivity();

/// Stream du statut réseau (interfaces). Premier événement = état actuel.
final networkConnectivityProvider = StreamProvider<NetworkConnectivityStatus>((ref) async* {
  yield mapConnectivityResults(await _connectivity.checkConnectivity());

  await for (final results in _connectivity.onConnectivityChanged) {
    yield mapConnectivityResults(results);
  }
});
