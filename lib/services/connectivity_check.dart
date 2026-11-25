import 'dart:io';

/// US-022: a quick "are we online?" check for the offline banner.
/// One DNS lookup with a 2 second limit, so Home never waits longer than that.
class ConnectivityCheck {
  ConnectivityCheck._();

  static Future<bool> isOnline(
      {Duration timeout = const Duration(seconds: 2)}) async {
    try {
      final result =
          await InternetAddress.lookup('example.com').timeout(timeout);
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
