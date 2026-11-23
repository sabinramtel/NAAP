import 'package:flutter_test/flutter_test.dart';
import 'package:naap/utils/unit_converter.dart';

void main() {
  test('165 cm is 5 ft 5 in', () {
    final v = UnitConverter.cmToFeetInches(165);
    expect(v.feet, 5);
    expect(v.inches, 5);
  });

  test('5 ft 5 in is 165 cm', () => expect(UnitConverter.feetInchesToCm(5, 5), 165));

  test('round trip stays within 1 cm for every valid height', () {
    for (var cm = UnitConverter.minHeightCm; cm <= UnitConverter.maxHeightCm; cm++) {
      final v = UnitConverter.cmToFeetInches(cm);
      final back = UnitConverter.feetInchesToCm(v.feet, v.inches);
      expect((back - cm).abs() <= 1, isTrue, reason: '$cm cm came back as $back cm');
    }
  });

  test('range check (US-012: 100 to 230 cm)', () {
    expect(UnitConverter.isHeightValid(99), isFalse);
    expect(UnitConverter.isHeightValid(100), isTrue);
    expect(UnitConverter.isHeightValid(230), isTrue);
    expect(UnitConverter.isHeightValid(231), isFalse);
  });
}
