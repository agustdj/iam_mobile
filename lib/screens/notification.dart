import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iam_mobile/services/NotificationService.dart'; 
import 'package:iam_mobile/services/GlobalService.dart'; 
import 'package:iam_mobile/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationListScreen extends StatelessWidget {
  // Init GlobalService và NotificationService
  final GlobalService globalService = Get.find();
  final NotificationService notificationService = NotificationService();

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear saved login information
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.blueAccent,
        actions: [
          // Notification button
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              print("Notifications clicked");
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
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          // get groupId và internshipId từ GlobalService
          String groupId = globalService.groupId.value;
          String internshipId = globalService.internshipId.value;

          return FutureBuilder<List<Map<String, dynamic>>>( 
            future:
                notificationService.fetchNotifications(internshipId, groupId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No notifications found."));
              } else {
                final notifications = snapshot.data!;
                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      color: Colors.white,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                        leading: CircleAvatar(
                          radius: 25.0,
                          backgroundImage: NetworkImage(notification['avatar'] ?? 'https://placekitten.com/200/200'),
                        ),
                        title: Text(
                          notification['name'] ?? 'No title',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification['content'] ?? 'No content',
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              notification['timestamp'] ?? 'Just now',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.more_vert),
                          onPressed: () {
                            // Handle more options
                            print('More options for notification');
                          },
                        ),
                        onTap: () {
                          _showNotificationDetailsDialog(context,
                              notification['name'], notification['content']);
                        },
                      ),
                    );
                  },
                );
              }
            },
          );
        }),
      ),
    );
  }

  // Dialog to show the notification details
  void _showNotificationDetailsDialog(BuildContext context,
      String notificationTitle, String notificationContent) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(notificationTitle),
          content: Text(notificationContent),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
