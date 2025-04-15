class NutritionInfo {
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final double fiber;
  final double sugar;

  NutritionInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.fiber,
    required this.sugar,
  });

  Map<String, dynamic> toJson() => {
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fats': fats,
    'fiber': fiber,
    'sugar': sugar,
  };

  factory NutritionInfo.fromJson(Map<String, dynamic> json) {
    return NutritionInfo(
      calories: json['calories'],
      protein: json['protein'],
      carbs: json['carbs'],
      fats: json['fats'],
      fiber: json['fiber'],
      sugar: json['sugar'],
    );
  }
}

class FoodItem {
  final String id;
  final String name;
  final String barcode;
  final double servingSize;
  final String servingUnit;
  final NutritionInfo nutritionPer100g;

  FoodItem({
    required this.id,
    required this.name,
    required this.barcode,
    required this.servingSize,
    required this.servingUnit,
    required this.nutritionPer100g,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'barcode': barcode,
    'servingSize': servingSize,
    'servingUnit': servingUnit,
    'nutritionPer100g': nutritionPer100g.toJson(),
  };

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      name: json['name'],
      barcode: json['barcode'],
      servingSize: json['servingSize'],
      servingUnit: json['servingUnit'],
      nutritionPer100g: NutritionInfo.fromJson(json['nutritionPer100g']),
    );
  }
}

class MealLog {
  final String id;
  final DateTime timestamp;
  final String mealType; // breakfast, lunch, dinner, snack
  final FoodItem food;
  final double quantity; // in servings

  MealLog({
    required this.id,
    required this.timestamp,
    required this.mealType,
    required this.food,
    required this.quantity,
  });

  NutritionInfo get totalNutrition {
    final multiplier = (quantity * food.servingSize) / 100;
    return NutritionInfo(
      calories: food.nutritionPer100g.calories * multiplier,
      protein: food.nutritionPer100g.protein * multiplier,
      carbs: food.nutritionPer100g.carbs * multiplier,
      fats: food.nutritionPer100g.fats * multiplier,
      fiber: food.nutritionPer100g.fiber * multiplier,
      sugar: food.nutritionPer100g.sugar * multiplier,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'mealType': mealType,
    'food': food.toJson(),
    'quantity': quantity,
  };

  factory MealLog.fromJson(Map<String, dynamic> json) {
    return MealLog(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      mealType: json['mealType'],
      food: FoodItem.fromJson(json['food']),
      quantity: json['quantity'],
    );
  }
}
