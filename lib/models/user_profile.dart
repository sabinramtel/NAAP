/// What the user tells us during profile setup (US-011, US-012).
class UserProfile {
  final String name;
  final DateTime? birthDate;
  final String? photoPath;
  final int? heightCm;
  final bool prefersImperial;

  const UserProfile({
    required this.name,
    this.birthDate,
    this.photoPath,
    this.heightCm,
    this.prefersImperial = false,
  });

  /// Setup is finished once we have a date of birth and a height.
  bool get isComplete => birthDate != null && heightCm != null;

  UserProfile copyWith({
    String? name,
    DateTime? birthDate,
    String? photoPath,
    int? heightCm,
    bool? prefersImperial,
  }) {
    return UserProfile(
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      photoPath: photoPath ?? this.photoPath,
      heightCm: heightCm ?? this.heightCm,
      prefersImperial: prefersImperial ?? this.prefersImperial,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'birthDate': birthDate?.millisecondsSinceEpoch,
        'photoPath': photoPath,
        'heightCm': heightCm,
        'prefersImperial': prefersImperial,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: (json['name'] as String?) ?? '',
        birthDate: json['birthDate'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['birthDate'] as int),
        photoPath: json['photoPath'] as String?,
        heightCm: json['heightCm'] as int?,
        prefersImperial: (json['prefersImperial'] as bool?) ?? false,
      );
}
