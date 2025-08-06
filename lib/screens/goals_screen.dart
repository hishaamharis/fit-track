import 'package:flutter/material.dart';
import '../services/mock_api.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final MockApi _api = MockApi();
  final TextEditingController _controller = TextEditingController();
  String _goal = '';

  @override
  void initState() {
    super.initState();
    _loadGoal();
  }

  Future<void> _loadGoal() async {
    _goal = await _api.fetchGoal();
    setState(() {});
  }

  void _setGoal() {
    setState(() {
      _goal = _controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _GoalsTitle(),
          _GoalInputRow(controller: _controller, onSetGoal: _setGoal),
          const SizedBox(height: 10),
          _GoalStatus(goal: _goal),
        ],
      ),
    );
  }

}

class _GoalsTitle extends StatelessWidget {
  const _GoalsTitle();

  @override
  Widget build(BuildContext context) {
    return const Text('Set Fitness Goals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
  }
}

class _GoalInputRow extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSetGoal;
  const _GoalInputRow({required this.controller, required this.onSetGoal});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter your goal'),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.check),
          onPressed: onSetGoal,
        ),
      ],
    );
  }
}

class _GoalStatus extends StatelessWidget {
  final String goal;
  const _GoalStatus({required this.goal});

  @override
  Widget build(BuildContext context) {
    return Text(goal.isEmpty ? 'No goal set.' : 'Current Goal: $goal', style: const TextStyle(fontSize: 16));
  }
}

