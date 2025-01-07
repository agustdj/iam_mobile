import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  final String baseUrl = 'http://192.168.1.18:3000/api/login';
  //final String baseUrl = 'http://localhost:3000/api/login';

  // Login method
  Future<User?> login(String username, String password) async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Parse JSON response into User object
        final Map<String, dynamic> data = jsonDecode(response.body);
        final user = User.fromJson(data);
        print("user: $data");

        // Save login information locally
        await _saveLoginInfo(data);

        return user;
      } else if (response.statusCode == 401) {
        throw Exception('Invalid username or password');
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  // Save login information, including role
  Future<void> _saveLoginInfo(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    // Save the entire user object as JSON
    await prefs.setString('user', jsonEncode(data));

    // Save the role string separately for quick access
    if (data.containsKey('role') && data['role'] is String) {
      await prefs.setString('role', data['role']);
    }
  }

  // Get saved login information
  Future<User?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData != null) {
      final Map<String, dynamic> data = jsonDecode(userData);
      return User.fromJson(data);
    }
    return null;
  }

  // Get the saved role
  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  // Logout function
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all data during logout
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user');
  }

  /// Find `studentId` or `teacherId` based `userId` and `role`
  Future<String?> fetchIdByRole(String userId, String role) async {
    // endpoint base on role
    String endpoint = role == 'student' ? 'student' : 'teacher';
    //final url = Uri.parse('$baseUrl/$endpoint/user/$userId');
    final url = Uri.parse('http://localhost:3000/api/$endpoint/user/$userId');
    print(url);
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Parse response để lấy ID
        final data = jsonDecode(response.body);
        return data['_id']; // Trả về ID từ JSON
      } else {
        print('Failed to fetch ID. Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching ID: $e');
      return null;
    }
  }
}
