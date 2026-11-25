import 'package:flutter_test/flutter_test.dart';
import 'package:naap/models/measurements.dart';
import 'package:naap/utils/size_recommender.dart';

Measurements body({double chest = 96, double waist = 80, double hip = 98}) =>
    Measurements(
      chest: chest,
      waist: waist,
      hip: hip,
      shoulder: 44,
      inseam: 78,
      sleeve: 60,
      takenAt: DateTime(2026, 11, 27),
    );

void main() {
  group('SizeChart binary search', () {
    final chart = SizeRecommender.charts[Garment.top]!;
    test('a value on a bound belongs to that size',
        () => expect(chart.sizeFor(98), 'M'));
    test('just above a bound moves up one size',
        () => expect(chart.sizeFor(98.5), 'L'));
    test('below the first bound is the smallest size',
        () => expect(chart.sizeFor(60), 'XS'));
    test('above the last bound is the largest size',
        () => expect(chart.sizeFor(200), 'XXL'));
  });

  group('fit preference (US-013)', () {
    final m = body(chest: 97);
    test('regular uses the body measurement', () {
      expect(SizeRecommender.recommend(Garment.top, m, FitPreference.regular),
          'M');
    });
    test('relaxed adds room and goes up a size near the boundary', () {
      expect(SizeRecommender.recommend(Garment.top, m, FitPreference.relaxed),
          'L');
    });
    test('slim never gives a bigger size than regular', () {
      expect(
          SizeRecommender.recommend(
              Garment.top, body(chest: 91), FitPreference.slim),
          'S');
    });
    test('unknown or missing code falls back to regular', () {
      expect(FitPreferenceCode.fromCode(null), FitPreference.regular);
      expect(FitPreferenceCode.fromCode('baggy'), FitPreference.regular);
      expect(FitPreferenceCode.fromCode('slim'), FitPreference.slim);
    });
  });

  test('a brand that runs small pushes the size up', () {
    final m = body(waist: 82);
    expect(SizeRecommender.recommend(Garment.jeans, m, FitPreference.regular),
        '32');
    expect(
        SizeRecommender.recommend(Garment.jeans, m, FitPreference.regular,
            brandOffsetCm: 2),
        '34');
  });

  test('sample measurements scale with height', () {
    final short = Measurements.sample(150);
    final tall = Measurements.sample(190);
    expect(tall.chest > short.chest, isTrue);
    expect(short.isSample, isTrue);
  });
}
