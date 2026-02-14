import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserRole { freemium, premium }

class RoleProvider extends ChangeNotifier {
  UserRole _userRole = UserRole.freemium;

  UserRole get userRole => _userRole;

  RoleProvider() {
    _loadRole();
  }

  void _loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    final roleIndex = prefs.getInt('userRole') ?? 0;
    _userRole = UserRole.values[roleIndex];
    notifyListeners();
  }

  void setRole(UserRole role) async {
    _userRole = role;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userRole', role.index);
    notifyListeners();
  }
}
