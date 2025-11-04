class User {
  final String id;
  final String name;
  final String email;
  final String hashedPassword;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.hashedPassword,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'hashedPassword': hashedPassword,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      hashedPassword: map['hashedPassword'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
