import 'package:flutter/material.dart';
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
    _waterIntake = await _api.fetchWaterIntake();
    setState(() {});
  }

  void _addWater() {
    setState(() {
      _waterIntake++;
    });
  }

  void _removeWater() {
    if (_waterIntake > 0) {
      setState(() {
        _waterIntake--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Track Water Intake', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _removeWater,
              ),
              Text('$_waterIntake glasses', style: const TextStyle(fontSize: 18)),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addWater,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
