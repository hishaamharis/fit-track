import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/mock_api.dart';

class WaterScreen extends StatefulWidget {
  const WaterScreen({super.key});

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  final MockApi _api = MockApi();
  int _waterIntake = 0;

  @override
  void initState() {
    super.initState();
    _loadWater();
  }

  Future<void> _loadWater() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final dayIndex = now.weekday - 1;

    // Load today's water intake
    _waterIntake = prefs.getInt('water_day_${dayIndex}_intake') ?? 0;
    setState(() {});
  }

  Future<void> _updateProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final dayIndex = now.weekday - 1;

    // Save today's water intake
    await prefs.setInt('water_day_${dayIndex}_intake', _waterIntake);

    // Update progress for current day
    await prefs.setDouble('water_day_$dayIndex', _waterIntake.toDouble());
  }

  void _addWater() {
    setState(() {
      _waterIntake++;
    });
    _updateProgress();
  }

  void _removeWater() {
    if (_waterIntake > 0) {
      setState(() {
        _waterIntake--;
      });
      _updateProgress();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Track Water Intake',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green, // Changed from blue to green
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(
                    Icons.water_drop,
                    size: 48,
                    color: Colors.green.shade300, // Changed from blue to green
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$_waterIntake',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.green, // Changed from blue to green
                    ),
                  ),
                  const Text(
                    'glasses',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _removeWater,
                        icon: const Icon(Icons.remove),
                        label: const Text('Remove'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade100,
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: _addWater,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Glass'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Changed from blue to green
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily Goal',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: _waterIntake / 8,
                    backgroundColor: Colors.green.shade50, // Changed from blue to green
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green), // Changed from blue to green
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_waterIntake}/8 glasses',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_waterIntake >= 8)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Center(
                child: Card(
                  color: Colors.green.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Daily Goal Achieved! 🎉',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
