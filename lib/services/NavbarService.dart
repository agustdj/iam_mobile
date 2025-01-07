import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:iam_mobile/screens/login.dart'; 

class NavbarService {
  /// Logs the user out and navigates to the login screen
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear saved login information
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false, // Remove all previous routes
    );
  }

  /// Handles navigation to a given route
  void navigateTo(BuildContext context, Widget destination) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  /// Handles actions like notifications (placeholder function)
  void handleNotifications() {
    print("Notifications clicked");
  }
}
