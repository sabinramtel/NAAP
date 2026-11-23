/// Height conversions for US-012. Whole-number maths only, O(1) time and space.
class UnitConverter {
  UnitConverter._();

  static const double cmPerInch = 2.54;
  static const int minHeightCm = 100;
  static const int maxHeightCm = 230;

  /// 165 cm -> (5, 5)  meaning 5 ft 5 in.
  static ({int feet, int inches}) cmToFeetInches(int cm) {
    final totalInches = (cm / cmPerInch).round();
    return (feet: totalInches ~/ 12, inches: totalInches % 12);
  }

  /// 5 ft 5 in -> 165 cm (rounded to the nearest centimetre).
  static int feetInchesToCm(int feet, int inches) {
    return ((feet * 12 + inches) * cmPerInch).round();
  }

  static bool isHeightValid(int cm) => cm >= minHeightCm && cm <= maxHeightCm;

  static String formatCm(int cm) => '$cm cm';

  static String formatFeetInches(int cm) {
    final v = cmToFeetInches(cm);
    return '${v.feet} ft ${v.inches} in';
  }
}
