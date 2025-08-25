import 'package:fittrack/auth/auth_wrapper.dart';
import 'package:fittrack/screens/help_screen.dart';
import 'package:fittrack/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/settings_provider.dart';
import 'screens/workouts_screen.dart';
import 'screens/goals_screen.dart';
import 'screens/water_screen.dart';
import 'screens/progress_screen.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: const FitTrackApp(),
    ),
  );
}

class FitTrackApp extends StatelessWidget {
  const FitTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FitTrack',
          themeMode: settings.themeMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          home: const AuthWrapper(),
        );
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoggedIn = false;
  bool _showLogin = true;
  UserData? _userData;

  void _handleLoginSuccess(String username, String email) {
    setState(() {
      _userData = UserData(username: username, email: email);
      _isLoggedIn = true;
    });
  }

  void _handleRegisterSuccess(String username, String email) {
    setState(() {
      _userData = UserData(username: username, email: email);
      _isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn || _userData == null) {
      if (_showLogin) {
        return LoginScreen(
          onRegisterPressed: () => setState(() => _showLogin = false),
          onLoginSuccess: _handleLoginSuccess,
        );
      } else {
        return RegisterScreen(
          onLoginPressed: () => setState(() => _showLogin = true),
          onRegisterSuccess: _handleRegisterSuccess,
        );
      }
    }
    return FitTrackHome(userData: _userData!);
  }
}

class FitTrackHome extends StatefulWidget {
  final UserData userData;

  const FitTrackHome({
    super.key,
    required this.userData,
  });

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

  void _handleLogout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AuthWrapper()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitTrack'),
      ),
      drawer: ProfileDrawer(
        username: widget.userData.username,
        email: widget.userData.email,
        onLogout: _handleLogout,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 11,
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.fitness_center,
                  size: _selectedIndex == 0 ? 28 : 24,
                ),
                label: 'Workouts',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.flag,
                  size: _selectedIndex == 1 ? 28 : 24,
                ),
                label: 'Goals',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.water_drop,
                  size: _selectedIndex == 2 ? 28 : 24,
                ),
                label: 'Water',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.show_chart,
                  size: _selectedIndex == 3 ? 28 : 24,
                ),
                label: 'Progress',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileDrawer extends StatelessWidget {
  final String username;
  final String email;
  final VoidCallback onLogout;

  const ProfileDrawer({
    super.key,
    required this.username,
    required this.email,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(username),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                username[0],
                style: TextStyle(fontSize: 40.0, color: Colors.green),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.green),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help, color: Colors.green),
            title: const Text('Help'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpScreen()),
              );
            },
          ),
          const Spacer(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout'),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
