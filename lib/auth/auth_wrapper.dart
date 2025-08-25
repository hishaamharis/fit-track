import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import '../main.dart';

class UserData {
  final String username;
  final String email;

  UserData({
    required this.username,
    required this.email,
  });
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

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      if (_showLogin) {
        return LoginScreen(
          onRegisterPressed: () => setState(() => _showLogin = false),
          onLoginSuccess: _handleLoginSuccess,
        );
      } else {
        return RegisterScreen(
          onLoginPressed: () => setState(() => _showLogin = true),
          onRegisterSuccess: _handleLoginSuccess,
        );
      }
    }
    return FitTrackHome(userData: _userData!); // Remove const and pass userData
  }
}