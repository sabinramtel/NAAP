import 'package:flutter_test/flutter_test.dart';
import 'package:naap/utils/validators.dart';

void main() {
  group('email', () {
    test('accepts a normal address',
        () => expect(Validators.email('sabin@example.com'), isNull));
    test('rejects empty', () => expect(Validators.email(''), isNotNull));
    test('rejects missing domain',
        () => expect(Validators.email('sabin@'), isNotNull));
    test('trims spaces', () => expect(Validators.email('  a@b.com  '), isNull));
  });

  group('password (US-001: 8+ characters, one number)', () {
    test('too short', () => expect(Validators.password('abc1'), isNotNull));
    test('no number', () => expect(Validators.password('abcdefgh'), isNotNull));
    test('good', () => expect(Validators.password('abcdefg1'), isNull));
  });

  test('name needs 2+ characters', () {
    expect(Validators.name('A'), isNotNull);
    expect(Validators.name('Aarohi'), isNull);
  });
}
