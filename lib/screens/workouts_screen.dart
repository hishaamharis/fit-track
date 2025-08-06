import 'package:flutter/material.dart';
import '../services/mock_api.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  final MockApi _api = MockApi();
  final TextEditingController _controller = TextEditingController();
  List<String> _workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    _workouts = await _api.fetchWorkouts();
    setState(() {});
  }

  void _addWorkout() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _workouts.add(_controller.text);
        _controller.clear();
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
          const Text('Log Daily Workouts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(hintText: 'Enter workout'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addWorkout,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _workouts.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(_workouts[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
