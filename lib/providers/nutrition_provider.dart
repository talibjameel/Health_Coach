import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_nutrition.dart';
import '../models/meal.dart';

class NutritionProvider with ChangeNotifier {
  double _waterIntake = 0;
  Map<String, DailyNutrition> _nutritionLog = {};
  int _dailyMealsLogged = 0;
  double _weeklyCalorieAverage = 0;
  final SharedPreferences _prefs;

  NutritionProvider(this._prefs) {
    initFromStorage();
  }

  Future<void> initFromStorage() async {
    // Load water intake
    _waterIntake = _prefs.getDouble('waterIntake') ?? 0;

    // Load nutrition log
    final nutritionLogJson = _prefs.getString('nutritionLog');
    if (nutritionLogJson != null) {
      final Map<String, dynamic> decoded = json.decode(nutritionLogJson);
      _nutritionLog = decoded.map(
        (key, value) => MapEntry(
          key,
          DailyNutrition.fromJson(value as Map<String, dynamic>),
        ),
      );
    }

    // Calculate daily meals and weekly average
    _updateStats();
    notifyListeners();
  }

  void _updateStats() {
    final today = DateTime.now();
    final todayKey = _formatDate(today);
    
    // Update daily meals logged
    final todayNutrition = _nutritionLog[todayKey];
    _dailyMealsLogged = todayNutrition?.meals.length ?? 0;

    // Calculate weekly calorie average
    double weeklyTotal = 0;
    int daysWithData = 0;
    
    for (int i = 0; i < 7; i++) {
      final date = today.subtract(Duration(days: i));
      final dateKey = _formatDate(date);
      final dailyNutrition = _nutritionLog[dateKey];
      
      if (dailyNutrition != null) {
        weeklyTotal += dailyNutrition.calories;
        daysWithData++;
      }
    }

    _weeklyCalorieAverage = daysWithData > 0 
        ? (weeklyTotal / daysWithData).roundToDouble()
        : 0;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Getters
  double get waterIntake => _waterIntake;
  int get dailyMealsLogged => _dailyMealsLogged;
  double get weeklyCalorieAverage => _weeklyCalorieAverage;

  DailyNutrition getDailyNutrition(DateTime date) {
    final key = _formatDate(date);
    return _nutritionLog[key] ?? DailyNutrition(
      calories: 0,
      macros: {'Carbs': 0, 'Protein': 0, 'Fat': 0},
      meals: [],
    );
  }

  // Methods to update data
  Future<void> updateWaterIntake(double amount) async {
    _waterIntake = amount;
    await _prefs.setDouble('waterIntake', _waterIntake);
    notifyListeners();
  }

  Future<void> addMeal(String name, double calories, Map<String, double> macros) async {
    final today = DateTime.now();
    final todayKey = _formatDate(today);
    
    final dailyNutrition = _nutritionLog[todayKey] ?? DailyNutrition(
      calories: 0,
      macros: {'Carbs': 0, 'Protein': 0, 'Fat': 0},
      meals: [],
    );

    dailyNutrition.calories += calories;
    dailyNutrition.meals.add(Meal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      calories: calories,
      macros: macros,
      mealType: 'Other',
      timestamp: DateTime.now(),
    ));
    
    for (final entry in macros.entries) {
      dailyNutrition.macros[entry.key] = 
          (dailyNutrition.macros[entry.key] ?? 0) + entry.value;
    }

    _nutritionLog[todayKey] = dailyNutrition;
    await _saveNutritionLog();
    _updateStats();
    notifyListeners();
  }

  Future<void> _saveNutritionLog() async {
    final encoded = json.encode(
      _nutritionLog.map((key, value) => MapEntry(key, value.toJson())),
    );
    await _prefs.setString('nutritionLog', encoded);
  }

  Future<void> resetDailyProgress() async {
    final today = DateTime.now();
    final todayKey = _formatDate(today);
    _nutritionLog.remove(todayKey);
    _waterIntake = 0;
    
    await Future.wait([
      _saveNutritionLog(),
      _prefs.setDouble('waterIntake', 0),
    ]);
    
    _updateStats();
    notifyListeners();
  }
}
