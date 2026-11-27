/// What the user tells us during setup.
/// Sprint 1: name, birth date, photo, height (US-011, US-012).
/// Sprint 2: language (US-016), fit (US-013), styles (US-014), brands (US-015).
///
/// A Sprint 2 field that is null means the user has not reached that step yet.
/// An empty list means they reached it and chose nothing, which is allowed.
class UserProfile {
  final String name;
  final DateTime? birthDate;
  final String? photoPath;
  final int? heightCm;
  final bool prefersImperial;
  final String? language; // 'en' or 'ne'
  final String? fit; // 'slim', 'regular' or 'relaxed'
  final List<String>? styles;
  final List<String>? brands;

  const UserProfile({
    required this.name,
    this.birthDate,
    this.photoPath,
    this.heightCm,
    this.prefersImperial = false,
    this.language,
    this.fit,
    this.styles,
    this.brands,
  });

  UserProfile copyWith({
    String? name,
    DateTime? birthDate,
    String? photoPath,
    int? heightCm,
    bool? prefersImperial,
    String? language,
    String? fit,
    List<String>? styles,
    List<String>? brands,
  }) {
    return UserProfile(
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      photoPath: photoPath ?? this.photoPath,
      heightCm: heightCm ?? this.heightCm,
      prefersImperial: prefersImperial ?? this.prefersImperial,
      language: language ?? this.language,
      fit: fit ?? this.fit,
      styles: styles ?? this.styles,
      brands: brands ?? this.brands,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'birthDate': birthDate?.millisecondsSinceEpoch,
        'photoPath': photoPath,
        'heightCm': heightCm,
        'prefersImperial': prefersImperial,
        'language': language,
        'fit': fit,
        'styles': styles,
        'brands': brands,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: (json['name'] as String?) ?? '',
        birthDate: json['birthDate'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['birthDate'] as int),
        photoPath: json['photoPath'] as String?,
        heightCm: json['heightCm'] as int?,
        prefersImperial: (json['prefersImperial'] as bool?) ?? false,
        language: json['language'] as String?,
        fit: json['fit'] as String?,
        styles: (json['styles'] as List?)?.cast<String>(),
        brands: (json['brands'] as List?)?.cast<String>(),
      );
}
