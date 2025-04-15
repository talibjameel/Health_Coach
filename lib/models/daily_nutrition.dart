import 'meal.dart';

class DailyNutrition {
  double calories;
  Map<String, double> macros;
  List<Meal> meals;

  DailyNutrition({
    this.calories = 0,
    required this.macros,
    required this.meals,
  });

  factory DailyNutrition.fromJson(Map<String, dynamic> json) {
    return DailyNutrition(
      calories: json['calories']?.toDouble() ?? 0,
      macros: Map<String, double>.from(json['macros'] ?? {}),
      meals: (json['meals'] as List?)
          ?.map((meal) => Meal.fromJson(meal))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'macros': macros,
      'meals': meals.map((meal) => meal.toJson()).toList(),
    };
  }
}
