/// Body measurements in centimetres (US-017).
///
/// The camera scan arrives in a later sprint. Until then [Measurements.sample]
/// gives believable numbers worked out from height, marked as a sample so
/// Home can say so.
class Measurements {
  final double chest;
  final double waist;
  final double hip;
  final double shoulder;
  final double inseam;
  final double sleeve;
  final DateTime takenAt;
  final bool isSample;

  const Measurements({
    required this.chest,
    required this.waist,
    required this.hip,
    required this.shoulder,
    required this.inseam,
    required this.sleeve,
    required this.takenAt,
    this.isSample = false,
  });

  /// Average body ratios to height. Six multiplications: O(1).
  factory Measurements.sample(int heightCm, {DateTime? now}) {
    double r(double ratio) =>
        (heightCm * ratio * 2).roundToDouble() / 2; // nearest 0.5 cm
    return Measurements(
      chest: r(0.555),
      waist: r(0.475),
      hip: r(0.565),
      shoulder: r(0.255),
      inseam: r(0.45),
      sleeve: r(0.355),
      takenAt: now ?? DateTime.now(),
      isSample: true,
    );
  }

  Map<String, dynamic> toJson() => {
        'chest': chest,
        'waist': waist,
        'hip': hip,
        'shoulder': shoulder,
        'inseam': inseam,
        'sleeve': sleeve,
        'takenAt': takenAt.millisecondsSinceEpoch,
        'isSample': isSample,
      };

  factory Measurements.fromJson(Map<String, dynamic> json) => Measurements(
        chest: (json['chest'] as num).toDouble(),
        waist: (json['waist'] as num).toDouble(),
        hip: (json['hip'] as num).toDouble(),
        shoulder: (json['shoulder'] as num).toDouble(),
        inseam: (json['inseam'] as num).toDouble(),
        sleeve: (json['sleeve'] as num).toDouble(),
        takenAt: DateTime.fromMillisecondsSinceEpoch(json['takenAt'] as int),
        isSample: (json['isSample'] as bool?) ?? false,
      );
}
