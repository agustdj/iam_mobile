import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/GroupService.dart';
import '../models/group.dart';
import '../services/GlobalService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iam_mobile/screens/login.dart';
import './notification.dart';
import './studentlist.dart';

class GroupListScreen extends StatelessWidget {
  final GlobalService globalService =
      Get.find(); // Access the GlobalService instance
  final GroupService groupService = GroupService();

  // Variable to track the selected index of the BottomNavigationBar
  final RxInt _selectedIndex = 0.obs;

  // Function to handle BottomNavigationBar item taps
  void _onItemTapped(int index) {
    _selectedIndex.value = index;
    // You can navigate to different screens here based on the index
    // For example:
    // if (index == 0) {
    //   Get.to(HomeScreen());
    // } else if (index == 1) {
    //   Get.to(ProfileScreen());
    // }
  }

  @override
  Widget build(BuildContext context) {
    // Get the teacherId from GlobalService dynamically
    final teacherId = globalService.teacherId.value;

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
                _logout(context); 
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
      body: FutureBuilder<List<Group>>(
        future: groupService
            .fetchGroupsByTeacherId(teacherId), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No groups found"));
          } else {
            final groups = snapshot.data!; // List of Group objects

            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(group.name),
                    subtitle: Text(
                      'Internship: ${group.internshipId}\nTeacher: ${group.teacher.name}',
                    ),
                    trailing: Text(
                      group.createdAt.toIso8601String(),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentListScreen(),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear saved login information
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false, // Remove all previous routes
    );
  }
}
