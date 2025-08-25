import 'package:shared_preferences/shared_preferences.dart';

// lib/services/mock_api.dart

class MockApi {
  Future<List<String>> fetchWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('workouts') ?? [];
  }

  Future<void> saveWorkouts(List<String> workouts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('workouts', workouts);
  }

  Future<int> fetchWaterIntake() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('waterIntake') ?? 8;
  }

  Future<void> saveWaterIntake(int intake) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('waterIntake', intake);
  }

  Future<String> fetchGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('goal') ?? "Run 5km every week";
  }

  Future<void> saveGoal(String goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('goal', goal);
  }

  Future<List<String>> fetchGoals() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('goals') ?? [];
  }

  Future<void> saveGoals(List<String> goals) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('goals', goals);
  }
}
