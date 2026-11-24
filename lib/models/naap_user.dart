/// A signed-in account. Passwords are never kept here, only in the store as a salted hash.
class NaapUser {
  final String name;
  final String email;
  final bool emailVerified;

  const NaapUser({required this.name, required this.email, this.emailVerified = false});

  NaapUser copyWith({String? name, bool? emailVerified}) => NaapUser(
        name: name ?? this.name,
        email: email,
        emailVerified: emailVerified ?? this.emailVerified,
      );
}
