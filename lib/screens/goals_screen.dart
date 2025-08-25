import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/mock_api.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class Goal {
  final String description;
  final DateTime date;
  bool isAchieved;

  Goal({
    required this.description,
    required this.date,
    this.isAchieved = false,
  });

  Map<String, dynamic> toJson() => {
    'description': description,
    'date': date.toIso8601String(),
    'isAchieved': isAchieved,
  };

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
    description: json['description'],
    date: DateTime.parse(json['date']),
    isAchieved: json['isAchieved'] ?? false,
  );
}

class _GoalsScreenState extends State<GoalsScreen> {
  final MockApi _api = MockApi();
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Goal> _goals = [];

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    try {
      final goalStrings = await _api.fetchGoals();
      final loadedGoals = goalStrings.map((str) {
        try {
          final Map<String, dynamic> goalMap = json.decode(str);
          return Goal.fromJson(goalMap);
        } catch (e) {
          debugPrint('Error parsing goal: $e');
          return null;
        }
      }).whereType<Goal>().toList();

      setState(() {
        _goals = loadedGoals;
      });
    } catch (e) {
      debugPrint('Error loading goals: $e');
    }
  }

  Future<void> _saveGoals() async {
    try {
      final goalStrings = _goals.map((goal) => json.encode(goal.toJson())).toList();
      await _api.saveGoals(goalStrings);
    } catch (e) {
      debugPrint('Error saving goals: $e');
    }
  }

  void _addGoal() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _goals.add(Goal(
          description: _controller.text,
          date: DateTime.now(),
        ));
        _controller.clear();
      });
      _saveGoals();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Goal added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _deleteGoal(int index) {
    setState(() {
      _goals.removeAt(index);
    });
    _saveGoals();
  }

  void _toggleGoalAchieved(int index) {
    setState(() {
      _goals[index].isAchieved = !_goals[index].isAchieved;
    });
    _saveGoals();

    if (_goals[index].isAchieved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Goal achieved! Congratulations! 🎉'),
          backgroundColor: Colors.green,
        ),
      );
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
            'Set Fitness Goals',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Enter your fitness goal',
                    labelText: 'Fitness Goal',
                    alignLabelWithHint: true,
                    prefixIcon: const Icon(Icons.flag_outlined, color: Colors.green),
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
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a goal';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _addGoal,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Goal'),
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
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GoalsList(
              goals: _goals,
              onDelete: _deleteGoal,
              onToggleAchieved: _toggleGoalAchieved,
            ),
          ),
        ],
      ),
    );
  }
}

class GoalsList extends StatelessWidget {
  final List<Goal> goals;
  final Function(int) onDelete;
  final Function(int) onToggleAchieved;

  const GoalsList({
    super.key,
    required this.goals,
    required this.onDelete,
    required this.onToggleAchieved,
  });

  @override
  Widget build(BuildContext context) {
    if (goals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.flag_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No goals added yet',
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
      itemCount: goals.length,
      itemBuilder: (context, index) => Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: const Icon(Icons.flag, color: Colors.green),
          ),
          title: Text(
            goals[index].description,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: goals[index].isAchieved ? TextDecoration.lineThrough : null,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  goals[index].isAchieved
                      ? Icons.check_circle
                      : Icons.check_circle_outline,
                  color: goals[index].isAchieved ? Colors.green : Colors.grey,
                ),
                onPressed: () => onToggleAchieved(index),
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

