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

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'hashedPassword': hashedPassword,
        'createdAt': createdAt.toIso8601String(),
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        hashedPassword: json['hashedPassword'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}