
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iam_mobile/models/internship-detail.dart';
import 'package:iam_mobile/screens/homepage.dart';
import 'package:iam_mobile/services/GlobalService.dart';
import 'package:iam_mobile/services/InternshipService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iam_mobile/screens/login.dart';
import './report.dart'; 
import './notification.dart';

class InternshipListScreen extends StatefulWidget {
  @override
  _InternshipListScreenState createState() => _InternshipListScreenState();
}

class _InternshipListScreenState extends State<InternshipListScreen> {
  final GlobalService _globalService = Get.find();
  final InternshipService _internshipService = Get.find();

  RxList<InternshipDetails> internships = RxList<InternshipDetails>();

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear saved login information
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false, // Remove all previous routes
    );
  }

  @override
  void initState() {
    super.initState();
    _loadInternships();
  }

  void _loadInternships() async {
    final studentId = _globalService.studentId.value;

    print("studentId got: $studentId");

    if (studentId.isNotEmpty) {
      List<InternshipDetails> fetchedInternships =
          await _internshipService.fetchInternships(studentId);

      internships.value = fetchedInternships;
    } else {
      print("No student ID found.");
    }
  }

  // Navigate to Submit Report screen
  void _navigateToSubmitReport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportListScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internship List'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              print("Notifications clicked");

              // Navigate to a NotificationScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotificationListScreen()),
              );
            },
          ),

          // Profile button with menu
          PopupMenuButton<String>(
            icon: Icon(Icons.account_circle),
            onSelected: (value) {
              if (value == 'logout') {
                _logout(); // Handle logout
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Obx(() {
        if (internships.isEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: internships.length,
            itemBuilder: (context, index) {
              final internship = internships[index];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Column(
                  children: [
                    Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        title: Text(
                          internship.company,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4.0),
                            Text(
                              internship.position,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Group ID: ${internship.groupId}',
                              style: TextStyle(fontSize: 14.0),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Score: ${internship.score}',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            // Navigate to internship detail page
                          },
                        ),
                        onTap: () {
                          // Handle tap action
                        },
                      ),
                    ),
                    // Button takes full width
                    SizedBox(
                      width:
                          double.infinity, // Make the button stretch full width
                      child: ElevatedButton.icon(
                        onPressed:
                            _navigateToSubmitReport, // Navigate to Submit Report
                        icon: Icon(Icons.upload_file),
                        label: Text("Submit"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 20),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }),
    );
  }
}
