import '../models/measurements.dart';

/// US-013: how the user likes clothes to fit.
/// This file has no Flutter imports, so its tests run as plain Dart.
enum FitPreference { slim, regular, relaxed }

extension FitPreferenceCode on FitPreference {
  String get code => name; // 'slim', 'regular', 'relaxed'

  /// Unknown or missing codes fall back to Regular (US-013 default).
  static FitPreference fromCode(String? code) =>
      FitPreference.values.firstWhere((f) => f.name == code, orElse: () => FitPreference.regular);
}

enum Garment { top, jeans, dress }

/// A size chart for one kind of clothing: each size covers body measurements
/// up to its upper bound (in cm). Bounds are sorted, so finding a size is a
/// binary search: O(log n) in the number of sizes.
class SizeChart {
  final List<String> sizes;
  final List<double> upperBounds;

  const SizeChart(this.sizes, this.upperBounds);

  String sizeFor(double cm) {
    var low = 0, high = upperBounds.length - 1;
    while (low < high) {
      final mid = (low + high) ~/ 2;
      if (cm <= upperBounds[mid]) {
        high = mid;
      } else {
        low = mid + 1;
      }
    }
    return sizes[low]; // anything above the last bound gets the largest size
  }
}

/// Picks a size from measurements, fit preference and brand.
///
/// Fit works as "ease": slim takes 2 cm off the body measurement (so you go
/// down a size near a boundary) and relaxed adds 4 cm (so you go up one).
/// A brand that runs small has a positive offset and pushes you up a size.
class SizeRecommender {
  SizeRecommender._();

  static const Map<Garment, SizeChart> charts = {
    // Tops by chest
    Garment.top: SizeChart(['XS', 'S', 'M', 'L', 'XL', 'XXL'], [84, 90, 98, 106, 114, 124]),
    // Jeans by waist, sold by waist size in inches
    Garment.jeans: SizeChart(['28', '30', '32', '34', '36', '38'], [73, 78, 83, 88, 94, 100]),
    // Dresses by hip
    Garment.dress: SizeChart(['XS', 'S', 'M', 'L', 'XL'], [88, 94, 100, 106, 114]),
  };

  static double ease(FitPreference fit) {
    switch (fit) {
      case FitPreference.slim:
        return -2;
      case FitPreference.regular:
        return 0;
      case FitPreference.relaxed:
        return 4;
    }
  }

  static double keyMeasurement(Garment garment, Measurements m) {
    switch (garment) {
      case Garment.top:
        return m.chest;
      case Garment.jeans:
        return m.waist;
      case Garment.dress:
        return m.hip;
    }
  }

  static String recommend(Garment garment, Measurements m, FitPreference fit, {double brandOffsetCm = 0}) {
    final cm = keyMeasurement(garment, m) + ease(fit) + brandOffsetCm;
    return charts[garment]!.sizeFor(cm);
  }
}
