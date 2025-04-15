class Exercise {
  final String id;
  final String name;
  final String description;
  final String videoUrl;
  final String muscleGroup;
  final int durationInSeconds;
  final int sets;
  final int reps;
  final double weightKg;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.videoUrl,
    required this.muscleGroup,
    required this.durationInSeconds,
    required this.sets,
    required this.reps,
    this.weightKg = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'videoUrl': videoUrl,
    'muscleGroup': muscleGroup,
    'durationInSeconds': durationInSeconds,
    'sets': sets,
    'reps': reps,
    'weightKg': weightKg,
  };

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      videoUrl: json['videoUrl'],
      muscleGroup: json['muscleGroup'],
      durationInSeconds: json['durationInSeconds'],
      sets: json['sets'],
      reps: json['reps'],
      weightKg: json['weightKg'],
    );
  }
}

class WorkoutPlan {
  final String id;
  final String name;
  final String description;
  final String difficulty;
  final int estimatedDurationMinutes;
  final List<Exercise> exercises;

  WorkoutPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.estimatedDurationMinutes,
    required this.exercises,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'difficulty': difficulty,
    'estimatedDurationMinutes': estimatedDurationMinutes,
    'exercises': exercises.map((e) => e.toJson()).toList(),
  };

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      difficulty: json['difficulty'],
      estimatedDurationMinutes: json['estimatedDurationMinutes'],
      exercises: (json['exercises'] as List)
          .map((e) => Exercise.fromJson(e))
          .toList(),
    );
  }
}
