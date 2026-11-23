import 'package:flutter_test/flutter_test.dart';
import 'package:naap/utils/profile_helpers.dart';

void main() {
  final today = DateTime(2026, 11, 27);

  test('turns 18 today counts as 18', () {
    expect(ProfileHelpers.isOldEnough(DateTime(2008, 11, 27), today), isTrue);
  });

  test('turns 18 tomorrow is still 17', () {
    expect(ProfileHelpers.isOldEnough(DateTime(2008, 11, 28), today), isFalse);
  });

  test('initials', () {
    expect(ProfileHelpers.initials('Aarohi Shrestha'), 'AS');
    expect(ProfileHelpers.initials('sajana'), 'S');
    expect(ProfileHelpers.initials('  '), '?');
  });
}
