class MockApi {
  Future<List<String>> fetchWorkouts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const ["Push Ups", "Running", "Yoga"];
  }

  Future<String> fetchGoal() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return "Run 5km every week";
  }

  Future<int> fetchWaterIntake() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 8;
  }

  Future<List<int>> fetchWeeklyWorkouts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const [3, 4, 2, 5, 1, 0, 4];
  }

  Future<List<int>> fetchWeeklyWaterIntake() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const [8, 7, 6, 8, 9, 7, 8];
  }
}
