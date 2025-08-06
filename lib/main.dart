
import 'package:flutter/material.dart';
import 'screens/workouts_screen.dart';
import 'screens/goals_screen.dart';
import 'screens/water_screen.dart';
import 'screens/progress_screen.dart';

void main() {
  runApp(const FitTrackApp());
}


class FitTrackApp extends StatelessWidget {
  const FitTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitTrack',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const FitTrackHome(),
    );
  }
}

class FitTrackHome extends StatefulWidget {
  const FitTrackHome({super.key});

  @override
  State<FitTrackHome> createState() => _FitTrackHomeState();
}

class _FitTrackHomeState extends State<FitTrackHome> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    WorkoutsScreen(),
    GoalsScreen(),
    WaterScreen(),
    ProgressScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitTrack'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workouts'),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Goals'),
          BottomNavigationBarItem(icon: Icon(Icons.local_drink), label: 'Water'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Progress'),
        ],
      ),
    );
  }
}
