
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/mock_api.dart';

class Workout {
  final String name;
  final int reps;
  final DateTime date;
  bool isCompleted;  

  Workout({
    required this.name,
    required this.reps,
    required this.date,
    this.isCompleted = false,  // Default to false
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'reps': reps,
    'date': date.toIso8601String(),
    'isCompleted': isCompleted,  // Add this to JSON
  };

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
    name: json['name'],
    reps: json['reps'],
    date: DateTime.parse(json['date']),
    isCompleted: json['isCompleted'] ?? false,
  );
}

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  final MockApi _api = MockApi();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  List<Workout> _workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    try {
      final workoutStrings = await _api.fetchWorkouts();
      final loadedWorkouts = workoutStrings.map((str) {
        try {
          final Map<String, dynamic> workoutMap = json.decode(str);
          return Workout.fromJson(workoutMap);
        } catch (e) {
          debugPrint('Error parsing workout: $e');
          return null;
        }
      }).whereType<Workout>().toList();

      setState(() {
        _workouts = loadedWorkouts;
      });
    } catch (e) {
      debugPrint('Error loading workouts: $e');
      setState(() {
        _workouts = [];
      });
    }
  }

  Future<void> _saveWorkouts() async {
    try {
      final workoutStrings = _workouts.map((workout) {
        return json.encode(workout.toJson());
      }).toList();
      await _api.saveWorkouts(workoutStrings);
    } catch (e) {
      debugPrint('Error saving workouts: $e');
    }
  }

  void _addWorkout() {
    if (_nameController.text.isNotEmpty && _repsController.text.isNotEmpty) {
      final reps = int.tryParse(_repsController.text) ?? 0;
      if (reps < 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Minimum 10 reps required!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _workouts.add(Workout(
          name: _nameController.text,
          reps: reps,
          date: DateTime.now(),
        ));
        _nameController.clear();
        _repsController.clear();
      });
      _saveWorkouts();
      _updateProgress();
    }
  }

  Future<void> _updateProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final dayIndex = now.weekday - 1;

    // Only count completed workouts
    final todaysWorkouts = _workouts.where(
          (workout) =>
          workout.date.day == now.day &&
          workout.date.month == now.month &&
          workout.date.year == now.year &&
          workout.isCompleted,  // Add this condition
    );
    final totalReps = todaysWorkouts.fold(0, (sum, workout) => sum + workout.reps);

    await prefs.setDouble('workout_day_$dayIndex', totalReps.toDouble());
  }

  void _deleteWorkout(int index) {
    setState(() {
      _workouts.removeAt(index);
    });
    _saveWorkouts();
    _updateProgress();
  }

  void _toggleComplete(int index) {
    setState(() {
      _workouts[index].isCompleted = !_workouts[index].isCompleted;
    });
    _saveWorkouts();
    _updateProgress();

    if (_workouts[index].isCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Workout completed! Great job! 💪'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Log Daily Workouts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Workout Name',
                hintText: 'Enter workout name',
                prefixIcon: const Icon(Icons.fitness_center, color: Colors.green),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _repsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Reps',
                      hintText: 'Minimum 10',
                      prefixIcon: const Icon(Icons.repeat, color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.green, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _addWorkout,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
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
            const SizedBox(height: 16),
            Expanded(
              child: WorkoutList(
                workouts: _workouts,
                onDelete: _deleteWorkout,
                onToggleComplete: _toggleComplete,  // Add this
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutList extends StatelessWidget {
  final List<Workout> workouts;
  final Function(int) onDelete;
  final Function(int) onToggleComplete;  // Add this

  const WorkoutList({
    super.key,
    required this.workouts,
    required this.onDelete,
    required this.onToggleComplete,  // Add this
  });

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.fitness_center_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No workouts added',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: workouts.length,
      itemBuilder: (context, index) => Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade200,
            child: const Icon(Icons.fitness_center, color: Colors.white),
          ),
          title: Text(
            workouts[index].name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: workouts[index].isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            '${workouts[index].reps} reps',
            style: TextStyle(color: Colors.grey[600]),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  workouts[index].isCompleted
                      ? Icons.check_circle
                      : Icons.check_circle_outline,
                  color: workouts[index].isCompleted
                      ? Colors.green
                      : Colors.grey,
                ),
                onPressed: () => onToggleComplete(index),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(index),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
