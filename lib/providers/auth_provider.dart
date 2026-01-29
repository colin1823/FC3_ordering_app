import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  // In production, integrate FirebaseAuth here.
  // This is a mock implementation for the blueprint.

  String? _userId;
  String? _role; // 'student' or 'vendor'

  bool get isAuthenticated => _userId != null;
  String? get userId => _userId;
  String? get role => _role;

  Future<void> login(String email, String password, String role) async {
    // Simulate API call
    await Future.delayed(Duration(milliseconds: 500));
    _userId = "user_123";
    _role = role;
    notifyListeners();
  }

  void logout() {
    _userId = null;
    _role = null;
    notifyListeners();
  }
}
