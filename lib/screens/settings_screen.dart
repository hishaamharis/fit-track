import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _showNotifications = true;
  double _waterGoal = 8;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
      _showNotifications = prefs.getBool('notifications') ?? true;
      _waterGoal = prefs.getDouble('waterGoal') ?? 8;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
    await prefs.setBool('notifications', _showNotifications);
    await prefs.setDouble('waterGoal', _waterGoal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.brightness_6, color: Colors.green),
                  title: const Text('Dark Mode'),
                  trailing: Switch(
                    value: _isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value;
                      });
                      _saveSettings();
                    },
                    activeColor: Colors.green,
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.green),
                  title: const Text('Notifications'),
                  trailing: Switch(
                    value: _showNotifications,
                    onChanged: (value) {
                      setState(() {
                        _showNotifications = value;
                      });
                      _saveSettings();
                    },
                    activeColor: Colors.green,
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.water_drop, color: Colors.green),
                  title: const Text('Daily Water Goal'),
                  subtitle: Slider(
                    value: _waterGoal,
                    min: 4,
                    max: 12,
                    divisions: 8,
                    label: '${_waterGoal.toInt()} glasses',
                    onChanged: (value) {
                      setState(() {
                        _waterGoal = value;
                      });
                      _saveSettings();
                    },
                    activeColor: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.green),
                  title: const Text('Account'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle account settings
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.backup, color: Colors.green),
                  title: const Text('Backup Data'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle backup settings
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}