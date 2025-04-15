class Meal {
  final String id;
  final String name;
  final double calories;
  final Map<String, double> macros;
  final String mealType;
  final DateTime timestamp;

  Meal({
    required this.id,
    required this.name,
    required this.calories,
    required this.macros,
    required this.mealType,
    required this.timestamp,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] as String,
      name: json['name'] as String,
      calories: json['calories']?.toDouble() ?? 0,
      macros: Map<String, double>.from(json['macros'] ?? {}),
      mealType: json['mealType'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'macros': macros,
      'mealType': mealType,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
