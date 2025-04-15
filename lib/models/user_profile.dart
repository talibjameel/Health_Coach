import 'package:flutter/foundation.dart';

enum FitnessGoal {
  weightLoss,
  maintenance,
  muscleGain
}

class UserProfile {
  final String id;
  final String name;
  final int age;
  final double weight;
  final double height;
  final FitnessGoal goal;
  final double targetWeight;
  final DateTime targetDate;
  final int dailyCalorieTarget;
  final int dailyWaterTarget;

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.goal,
    required this.targetWeight,
    required this.targetDate,
    required this.dailyCalorieTarget,
    required this.dailyWaterTarget,
  });

  double get bmi => weight / ((height / 100) * (height / 100));

  String get bmiCategory {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'weight': weight,
    'height': height,
    'goal': goal.toString(),
    'targetWeight': targetWeight,
    'targetDate': targetDate.toIso8601String(),
    'dailyCalorieTarget': dailyCalorieTarget,
    'dailyWaterTarget': dailyWaterTarget,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'],
    name: json['name'],
    age: json['age'],
    weight: json['weight'],
    height: json['height'],
    goal: FitnessGoal.values.firstWhere(
      (e) => e.toString() == json['goal'],
      orElse: () => FitnessGoal.maintenance,
    ),
    targetWeight: json['targetWeight'],
    targetDate: DateTime.parse(json['targetDate']),
    dailyCalorieTarget: json['dailyCalorieTarget'],
    dailyWaterTarget: json['dailyWaterTarget'],
  );
}
