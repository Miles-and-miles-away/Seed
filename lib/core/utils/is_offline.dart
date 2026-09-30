import 'dart:async';
import 'dart:io';

const _probeTimeout = Duration(seconds: 2);

/// True when a DNS lookup fails, which is the cheapest offline signal
/// that needs no extra dependency.
Future<bool> isOffline() async {
  try {
    final hosts = await InternetAddress.lookup(
      'firestore.googleapis.com',
    ).timeout(_probeTimeout);
    return hosts.isEmpty;
  } on SocketException {
    return true;
  } on TimeoutException {
    return true;
  }
}
