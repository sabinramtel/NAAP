/// US-003: after 5 wrong passwords in a row, pause logins for 5 minutes.
///
/// We keep only two numbers per email (failed count and lock end time),
/// so every check and update is O(1) time and O(1) space per email.
/// The state is plain data so it can be saved to the phone and tested
/// without any Flutter code.
class LoginGuard {
  static const int maxAttempts = 5;
  static const Duration lockTime = Duration(minutes: 5);

  int failedCount;
  DateTime? lockedUntil;

  LoginGuard({this.failedCount = 0, this.lockedUntil});

  /// How long the user still has to wait, or null if they can try now.
  Duration? remainingLock(DateTime now) {
    final until = lockedUntil;
    if (until == null || !now.isBefore(until)) return null;
    return until.difference(now);
  }

  bool isLocked(DateTime now) => remainingLock(now) != null;

  /// Call after a wrong password. Returns true when this attempt caused a lock.
  bool recordFailure(DateTime now) {
    if (lockedUntil != null && !now.isBefore(lockedUntil!)) {
      // The old lock has finished, start counting again.
      lockedUntil = null;
      failedCount = 0;
    }
    failedCount++;
    if (failedCount >= maxAttempts) {
      lockedUntil = now.add(lockTime);
      failedCount = 0;
      return true;
    }
    return false;
  }

  /// Call after a correct password.
  void recordSuccess() {
    failedCount = 0;
    lockedUntil = null;
  }

  Map<String, dynamic> toJson() => {
        'failedCount': failedCount,
        'lockedUntil': lockedUntil?.millisecondsSinceEpoch,
      };

  factory LoginGuard.fromJson(Map<String, dynamic> json) => LoginGuard(
        failedCount: (json['failedCount'] as int?) ?? 0,
        lockedUntil: json['lockedUntil'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['lockedUntil'] as int),
      );

  /// "4 min 10 s" style text for the error message.
  static String describe(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    if (minutes == 0) return '$seconds s';
    return '$minutes min $seconds s';
  }
}
