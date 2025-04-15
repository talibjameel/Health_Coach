import 'package:flutter/foundation.dart';
import 'package:health_coach/models/workout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WorkoutProvider with ChangeNotifier {
  List<WorkoutPlan> _workoutPlans = [];
  WorkoutPlan? _currentWorkout;
  final Map<String, double> _workoutProgress = {};
  final Map<String, List<String>> _completedExercises = {};
  DateTime? _lastWorkoutDate;
  int _weeklyWorkoutsCompleted = 0;
  int _monthlyWorkoutsCompleted = 0;

  List<WorkoutPlan> get workoutPlans => _workoutPlans;
  WorkoutPlan? get currentWorkout => _currentWorkout;
  Map<String, double> get workoutProgress => _workoutProgress;
  Map<String, List<String>> get completedExercises => _completedExercises;
  DateTime? get lastWorkoutDate => _lastWorkoutDate;
  int get weeklyWorkoutsCompleted => _weeklyWorkoutsCompleted;
  int get monthlyWorkoutsCompleted => _monthlyWorkoutsCompleted;

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final progress = prefs.getString('workout_progress');
    final completed = prefs.getString('completed_exercises');
    final lastWorkout = prefs.getString('last_workout_date');
    
    if (progress != null) {
      final Map<String, dynamic> decoded = json.decode(progress);
      _workoutProgress.clear();
      decoded.forEach((key, value) => _workoutProgress[key] = value.toDouble());
    }
    
    if (completed != null) {
      final Map<String, dynamic> decoded = json.decode(completed);
      _completedExercises.clear();
      decoded.forEach((key, value) => 
        _completedExercises[key] = List<String>.from(value));
    }
    
    if (lastWorkout != null) {
      _lastWorkoutDate = DateTime.parse(lastWorkout);
      _updateWorkoutStats();
    }
    
    notifyListeners();
  }

  Future<void> saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('workout_progress', json.encode(_workoutProgress));
    await prefs.setString('completed_exercises', json.encode(_completedExercises));
    if (_lastWorkoutDate != null) {
      await prefs.setString('last_workout_date', _lastWorkoutDate!.toIso8601String());
    }
  }

  void setWorkoutPlans(List<WorkoutPlan> plans) {
    _workoutPlans = plans;
    notifyListeners();
  }

  void setCurrentWorkout(WorkoutPlan workout) {
    _currentWorkout = workout;
    if (!_workoutProgress.containsKey(workout.id)) {
      _workoutProgress[workout.id] = 0.0;
      _completedExercises[workout.id] = [];
    }
    notifyListeners();
  }

  void completeExercise(String workoutId, String exerciseId) {
    if (!_completedExercises.containsKey(workoutId)) {
      _completedExercises[workoutId] = [];
    }
    
    if (!_completedExercises[workoutId]!.contains(exerciseId)) {
      _completedExercises[workoutId]!.add(exerciseId);
      
      // Update progress
      final workout = _workoutPlans.firstWhere((w) => w.id == workoutId);
      final totalExercises = workout.exercises.length;
      final completedCount = _completedExercises[workoutId]!.length;
      _workoutProgress[workoutId] = (completedCount / totalExercises) * 100;
      
      // Update last workout date and stats
      _lastWorkoutDate = DateTime.now();
      _updateWorkoutStats();
      
      saveProgress();
      notifyListeners();
    }
  }

  void _updateWorkoutStats() {
    if (_lastWorkoutDate == null) return;

    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final monthStart = DateTime(now.year, now.month, 1);

    _weeklyWorkoutsCompleted = 0;
    _monthlyWorkoutsCompleted = 0;

    _workoutProgress.forEach((_, progress) {
      if (progress == 100.0) {
        if (_lastWorkoutDate!.isAfter(weekStart)) {
          _weeklyWorkoutsCompleted++;
        }
        if (_lastWorkoutDate!.isAfter(monthStart)) {
          _monthlyWorkoutsCompleted++;
        }
      }
    });
  }

  void resetWorkoutProgress(String workoutId) {
    _workoutProgress[workoutId] = 0.0;
    _completedExercises[workoutId] = [];
    saveProgress();
    notifyListeners();
  }

  double getWorkoutProgress(String workoutId) {
    return _workoutProgress[workoutId] ?? 0.0;
  }

  bool isExerciseCompleted(String workoutId, String exerciseId) {
    return _completedExercises[workoutId]?.contains(exerciseId) ?? false;
  }

  void addWorkoutPlan(WorkoutPlan plan) {
    _workoutPlans.add(plan);
    _workoutProgress[plan.id] = 0.0;
    _completedExercises[plan.id] = [];
    saveProgress();
    notifyListeners();
  }

  void addCustomWorkoutPlan(WorkoutPlan workout) {
    _workoutPlans.add(workout);
    notifyListeners();
  }

  void removeWorkoutPlan(String planId) {
    _workoutPlans.removeWhere((plan) => plan.id == planId);
    _workoutProgress.remove(planId);
    _completedExercises.remove(planId);
    if (_currentWorkout?.id == planId) {
      _currentWorkout = null;
    }
    saveProgress();
    notifyListeners();
  }

  void removeCustomWorkoutPlan(String id) {
    _workoutPlans.removeWhere((plan) => plan.id == id);
    notifyListeners();
  }

  void clearWorkouts() {
    _workoutPlans = [];
    _currentWorkout = null;
    _workoutProgress.clear();
    _completedExercises.clear();
    _lastWorkoutDate = null;
    _weeklyWorkoutsCompleted = 0;
    _monthlyWorkoutsCompleted = 0;
    saveProgress();
    notifyListeners();
  }
}
