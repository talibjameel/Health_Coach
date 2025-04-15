import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/nutrition_provider.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition'),
        actions: [
          IconButton(
            icon: const Icon(Icons.water_drop),
            onPressed: () {
              _showWaterIntakeDialog(context);
            },
          ),
        ],
      ),
      body: Consumer<NutritionProvider>(
        builder: (context, nutritionProvider, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildMealCard(
                context,
                'Breakfast',
                Icons.breakfast_dining,
                [
                  _MealItem('Oatmeal with Berries', 350, {
                    'Carbs': 45,
                    'Protein': 12,
                    'Fat': 8,
                  }),
                  _MealItem('Greek Yogurt', 150, {
                    'Carbs': 6,
                    'Protein': 20,
                    'Fat': 5,
                  }),
                ],
              ),
              const SizedBox(height: 16),
              _buildMealCard(
                context,
                'Lunch',
                Icons.lunch_dining,
                [
                  _MealItem('Grilled Chicken Salad', 450, {
                    'Carbs': 15,
                    'Protein': 40,
                    'Fat': 25,
                  }),
                ],
              ),
              const SizedBox(height: 16),
              _buildMealCard(
                context,
                'Dinner',
                Icons.dinner_dining,
                [
                  _MealItem('Salmon with Quinoa', 550, {
                    'Carbs': 40,
                    'Protein': 35,
                    'Fat': 30,
                  }),
                ],
              ),
              const SizedBox(height: 16),
              _buildMealCard(
                context,
                'Snacks',
                Icons.apple,
                [
                  _MealItem('Almonds', 160, {
                    'Carbs': 6,
                    'Protein': 6,
                    'Fat': 14,
                  }),
                  _MealItem('Banana', 105, {
                    'Carbs': 27,
                    'Protein': 1,
                    'Fat': 0,
                  }),
                ],
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddMealDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMealCard(
    BuildContext context,
    String title,
    IconData icon,
    List<_MealItem> items,
  ) {
    final totalCalories = items.fold(
      0,
      (sum, item) => sum + item.calories,
    );

    final macros = {
      'Carbs': 0.0,
      'Protein': 0.0,
      'Fat': 0.0,
    };

    for (final item in items) {
      for (final entry in item.macros.entries) {
        macros[entry.key] = (macros[entry.key] ?? 0) + entry.value;
      }
    }

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: Text(
              '$totalCalories kcal',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const Divider(height: 1),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: index < items.length - 1
                      ? Border(
                          bottom: BorderSide(
                            color: Theme.of(context).dividerColor.withOpacity(0.1),
                          ),
                        )
                      : null,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${item.calories} kcal',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildMacroIndicator(
                          context,
                          'C',
                          item.macros['Carbs']!,
                          Colors.amber,
                        ),
                        const SizedBox(width: 8),
                        _buildMacroIndicator(
                          context,
                          'P',
                          item.macros['Protein']!,
                          Colors.green,
                        ),
                        const SizedBox(width: 8),
                        _buildMacroIndicator(
                          context,
                          'F',
                          item.macros['Fat']!,
                          Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Macros:',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Row(
                  children: [
                    _buildTotalMacro(context, 'C', macros['Carbs']!),
                    const SizedBox(width: 12),
                    _buildTotalMacro(context, 'P', macros['Protein']!),
                    const SizedBox(width: 12),
                    _buildTotalMacro(context, 'F', macros['Fat']!),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroIndicator(
    BuildContext context,
    String label,
    double value,
    Color color,
  ) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${value.toInt()}g',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalMacro(BuildContext context, String label, double value) {
    return Text(
      '$label: ${value.toInt()}g',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.w500,
      ),
    );
  }

  void _showAddMealDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Meal'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Meal Name',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Calories',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // TODO: Add meal
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showWaterIntakeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Water Intake'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Amount (ml)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Consumer<NutritionProvider>(
              builder: (context, provider, _) {
                return Text(
                  'Current: ${provider.waterIntake.toInt()} ml',
                  style: Theme.of(context).textTheme.titleMedium,
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // TODO: Add water intake
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _MealItem {
  final String name;
  final int calories;
  final Map<String, double> macros;

  _MealItem(this.name, this.calories, this.macros);
}
