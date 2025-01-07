
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iam_mobile/screens/student-homepage.dart';
import 'package:iam_mobile/screens/teacher-homepage.dart';
import 'package:iam_mobile/screens/internship.dart';
import 'package:iam_mobile/services/AuthService.dart';
import 'package:iam_mobile/services/GlobalService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  final AuthService _authService = AuthService();

  void _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Username and password cannot be empty.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final user = await _authService.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null) {
        print('Login successful! Welcome, ${user.username}');

        //final GlobalService studentTeacherService = GlobalService();
        final GlobalService studentTeacherService = Get.find();

        //get username và role từ SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('userId') ?? user.id;
        final role = prefs.getString('role') ?? user.role;

        // Gọi AuthService để fetch ID
        final id = await _authService.fetchIdByRole(userId, role);
        print("Param: $id");

        if (id != null) {
          if (role == 'student') {
            studentTeacherService.setStudentId(id);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => InternshipListScreen(),
              ),
            );
          } else if (role == 'teacher') {
            studentTeacherService.setTeacherId(id);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => GroupListScreen(),
              ),
            );
          }
        } else {
          setState(() {
            _errorMessage = 'Failed to fetch ID for role: $role';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Invalid login credentials. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred during login: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.account_circle, color: Colors.blue),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.blue),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1877F2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Login',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Handle forgot password action
                },
                child: const Text('Forgot Password?'),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      // Handle sign-up navigation
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}