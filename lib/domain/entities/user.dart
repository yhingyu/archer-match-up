class User {
  final String userId;
  final String name;
  final String? email;
  final DateTime createdAt;

  const User({
    required this.userId,
    required this.name,
    this.email,
    required this.createdAt,
  });

  User copyWith({
    String? userId,
    String? name,
    String? email,
    DateTime? createdAt,
  }) {
    return User(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;

  @override
  String toString() {
    return 'User(userId: $userId, name: $name, email: $email, createdAt: $createdAt)';
  }
}