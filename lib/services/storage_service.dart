import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class StorageService {
  static const String _userKey = 'user_profile';
  static const String _workoutKey = 'workouts';
  static const String _nutritionKey = 'nutrition';
  static const String _waterKey = 'water_intake';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // Expose SharedPreferences instance
  SharedPreferences get prefs => _prefs;

  // User Profile
  Future<void> saveUserProfile(UserProfile user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  UserProfile? getUserProfile() {
    final String? userData = _prefs.getString(_userKey);
    if (userData == null) return null;
    return UserProfile.fromJson(jsonDecode(userData));
  }

  // Water Intake
  Future<void> saveWaterIntake(double amount, DateTime date) async {
    final String dateKey = date.toIso8601String().split('T')[0];
    final Map<String, dynamic> waterData = 
        jsonDecode(_prefs.getString(_waterKey) ?? '{}');
    waterData[dateKey] = amount;
    await _prefs.setString(_waterKey, jsonEncode(waterData));
  }

  double getWaterIntake(DateTime date) {
    final String dateKey = date.toIso8601String().split('T')[0];
    final Map<String, dynamic> waterData = 
        jsonDecode(_prefs.getString(_waterKey) ?? '{}');
    return (waterData[dateKey] ?? 0.0).toDouble();
  }

  // Clear all data
  Future<void> clearAllData() async {
    await _prefs.clear();
  }
}
