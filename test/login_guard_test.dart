import 'package:flutter_test/flutter_test.dart';
import 'package:naap/utils/login_guard.dart';

void main() {
  final start = DateTime(2026, 11, 27, 10);

  test('four wrong tries do not lock', () {
    final g = LoginGuard();
    for (var i = 0; i < 4; i++) {
      expect(g.recordFailure(start), isFalse);
    }
    expect(g.isLocked(start), isFalse);
  });

  test('fifth wrong try locks for 5 minutes', () {
    final g = LoginGuard();
    for (var i = 0; i < 4; i++) {
      g.recordFailure(start);
    }
    expect(g.recordFailure(start), isTrue);
    expect(g.isLocked(start.add(const Duration(minutes: 4, seconds: 59))), isTrue);
    expect(g.isLocked(start.add(const Duration(minutes: 5))), isFalse);
  });

  test('a correct password resets the count', () {
    final g = LoginGuard();
    g.recordFailure(start);
    g.recordFailure(start);
    g.recordSuccess();
    expect(g.failedCount, 0);
  });

  test('saves and loads without losing the lock', () {
    final g = LoginGuard();
    for (var i = 0; i < 5; i++) {
      g.recordFailure(start);
    }
    final copy = LoginGuard.fromJson(g.toJson());
    expect(copy.isLocked(start.add(const Duration(minutes: 1))), isTrue);
  });

  test('describe', () {
    expect(LoginGuard.describe(const Duration(seconds: 40)), '40 s');
    expect(LoginGuard.describe(const Duration(minutes: 4, seconds: 10)), '4 min 10 s');
  });
}
