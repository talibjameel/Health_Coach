import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../services/storage_service.dart';

class UserProvider with ChangeNotifier {
  UserProfile? _currentUser;
  StorageService? _storageService;

  UserProfile? get currentUser => _currentUser;

  Future<void> initFromStorage(StorageService storageService) async {
    _storageService = storageService;
    _currentUser = _storageService?.getUserProfile();
    notifyListeners();
  }

  Future<void> setUser(UserProfile user) async {
    _currentUser = user;
    await _storageService?.saveUserProfile(user);
    notifyListeners();
  }

  Future<void> updateUser({
    String? name,
    int? age,
    double? weight,
    double? height,
    FitnessGoal? goal,
    double? targetWeight,
    DateTime? targetDate,
    int? dailyCalorieTarget,
    int? dailyWaterTarget,
  }) async {
    if (_currentUser == null) return;

    final updatedUser = UserProfile(
      id: _currentUser!.id,
      name: name ?? _currentUser!.name,
      age: age ?? _currentUser!.age,
      weight: weight ?? _currentUser!.weight,
      height: height ?? _currentUser!.height,
      goal: goal ?? _currentUser!.goal,
      targetWeight: targetWeight ?? _currentUser!.targetWeight,
      targetDate: targetDate ?? _currentUser!.targetDate,
      dailyCalorieTarget: dailyCalorieTarget ?? _currentUser!.dailyCalorieTarget,
      dailyWaterTarget: dailyWaterTarget ?? _currentUser!.dailyWaterTarget,
    );

    await setUser(updatedUser);
  }
}
