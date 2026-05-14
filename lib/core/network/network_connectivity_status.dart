import 'package:connectivity_plus/connectivity_plus.dart';

/// État réseau simplifié (L-02). « Online » = au moins une interface autre que `none`
/// (ne garantit pas l’accès Internet — cf. issue L-02 optionnel ping).
enum NetworkConnectivityStatus {
  unknown,
  offline,
  online,
}

NetworkConnectivityStatus mapConnectivityResults(List<ConnectivityResult> results) {
  if (results.isEmpty) return NetworkConnectivityStatus.offline;
  var hasUsable = false;
  for (final r in results) {
    switch (r) {
      case ConnectivityResult.none:
        break;
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.mobile:
      case ConnectivityResult.other:
      case ConnectivityResult.satellite:
      case ConnectivityResult.vpn:
      case ConnectivityResult.wifi:
        hasUsable = true;
    }
  }
  return hasUsable ? NetworkConnectivityStatus.online : NetworkConnectivityStatus.offline;
}
