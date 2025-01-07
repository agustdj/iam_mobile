
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/login.dart';
import './screens/student-homepage.dart';
import './screens/internship.dart';
import './screens/test.dart';
import 'package:get/get.dart';
import 'package:iam_mobile/services/GlobalService.dart';
import 'package:iam_mobile/services/InternshipService.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(GlobalService());
  Get.put(InternshipService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginState();
  }

  Future<void> _checkLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn =
        prefs.containsKey('user'); // Check if user data is stored

    // Navigate to the appropriate screen
    if (isLoggedIn) {
      // Navigate to the home page if logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => InternshipListScreen()),
      );
    } else {
      // Navigate to the login page if not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Show loading indicator
      ),
    );
  }
}
