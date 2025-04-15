import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health_coach/screens/home_screen.dart';
import 'package:health_coach/screens/onboarding_screen.dart';
import 'package:health_coach/providers/user_provider.dart';
import 'package:health_coach/providers/workout_provider.dart';
import 'package:health_coach/providers/nutrition_provider.dart';
import 'package:health_coach/services/storage_service.dart';
import 'package:health_coach/config/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final storageService = StorageService(prefs);
  
  runApp(MyApp(storageService: storageService));
}

class MyApp extends StatelessWidget {
  final StorageService storageService;
  
  const MyApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider()..initFromStorage(storageService),
        ),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(
          create: (_) => NutritionProvider(storageService.prefs),
        ),
        Provider.value(value: storageService),
      ],
      child: MaterialApp(
        title: 'Health Coach',
        theme: AppTheme.lightTheme,
        home: Consumer<UserProvider>(
          builder: (context, userProvider, _) {
            return userProvider.currentUser == null
                ? const OnboardingScreen()
                : const HomeScreen();
          },
        ),
      ),
    );
  }
}
