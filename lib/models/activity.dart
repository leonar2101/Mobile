enum ActivityType {
  running('Corrida', 'assets/icons/running.png'),
  cycling('Ciclismo', 'assets/icons/cycling.png'),
  gym('Academia', 'assets/icons/gym.png'),
  walking('Caminhada', 'assets/icons/walking.png'),
  yoga('Yoga', 'assets/icons/yoga.png'),
  swimming('Natação', 'assets/icons/swimming.png'),
  custom('Personalizada', 'assets/icons/custom.png');

  const ActivityType(this.displayName, this.iconPath);
  final String displayName;
  final String iconPath;
}

class Activity {
  final String id;
  final String userId;
  final ActivityType type;
  final String? customTypeName; // when type == ActivityType.custom
  final int durationMinutes;
  final double? distanceKm;
  final int? calories;
  final DateTime date;
  final String? notes;

  Activity({
    required this.id,
    required this.userId,
    required this.type,
    this.customTypeName,
    required this.durationMinutes,
    this.distanceKm,
    this.calories,
    required this.date,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'type': type.name,
        'customTypeName': customTypeName,
        'durationMinutes': durationMinutes,
        'distanceKm': distanceKm,
        'calories': calories,
        'date': date.toIso8601String(),
        'notes': notes,
      };

  factory Activity.fromJson(Map<String, dynamic> json) {
    final typeName = json['type'] as String;
    final parsedType = ActivityType.values.firstWhere(
      (e) => e.name == typeName,
      orElse: () => ActivityType.custom,
    );
    return Activity(
      id: json['id'],
      userId: json['userId'],
      type: parsedType,
      customTypeName: json['customTypeName'],
      durationMinutes: json['durationMinutes'],
      distanceKm: (json['distanceKm'] is int)
          ? (json['distanceKm'] as int).toDouble()
          : json['distanceKm'],
      calories: json['calories'],
      date: DateTime.parse(json['date']),
      notes: json['notes'],
    );
  }

  String get displayTypeName => customTypeName ?? type.displayName;

  String get formattedDuration {
    if (durationMinutes < 60) return '${durationMinutes}min';
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;
    return '${hours}h${minutes > 0 ? ' ${minutes}min' : ''}';
  }

  String get formattedDistance =>
      distanceKm != null ? '${distanceKm!.toStringAsFixed(1)} km' : '';
}
