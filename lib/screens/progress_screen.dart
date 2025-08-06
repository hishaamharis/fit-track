import 'package:flutter/material.dart';
import '../services/mock_api.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final MockApi _api = MockApi();
  List<int> _weeklyWorkouts = [];
  List<int> _weeklyWater = [];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    _weeklyWorkouts = await _api.fetchWeeklyWorkouts();
    _weeklyWater = await _api.fetchWeeklyWaterIntake();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Weekly Progress', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('Workouts (mocked):'),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_weeklyWorkouts.length, (i) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: _weeklyWorkouts[i] * 15.0,
                    color: Colors.green,
                    child: Center(child: Text('${_weeklyWorkouts[i]}')),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Water Intake (mocked):'),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_weeklyWater.length, (i) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: _weeklyWater[i] * 10.0,
                    color: Colors.blue,
                    child: Center(child: Text('${_weeklyWater[i]}')),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
