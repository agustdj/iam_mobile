
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:iam_mobile/services/ReportService.dart';
import 'package:iam_mobile/services/GlobalService.dart';
import 'package:iam_mobile/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportListScreen extends StatelessWidget {
  final GlobalService globalService = Get.find();
  final ReportService reportService = ReportService();

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
        title: Text('Internship List'),
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
          // get studentId và internshipId từ GlobalService
          String studentId = globalService.studentId.value;
          String internshipId = globalService.internshipId.value;

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: reportService.fetchReports(internshipId, studentId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No reports found."));
              } else {
                final reports = snapshot.data!;
                return ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 12.0),
                      color: Colors.grey[200],
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(
                          report['name'] ?? 'No name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        subtitle: Text(
                          "Status: ${report['status'] ?? 'Unknown'}",
                          style: TextStyle(
                            color: report['status'] == 'approved'
                                ? Colors.green
                                : report['status'] == 'rejected'
                                    ? Colors.red
                                    : Colors.orange,
                          ),
                        ),
                        onTap: () {
                          _showSubmitReportDialog(context, report['name']);
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

  void _showSubmitReportDialog(BuildContext context, String reportName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Submit Report"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Report: $reportName"),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();

                  if (result != null) {
                    File file = File(result.files.single.path!);
                    print("File selected: ${file.path}");

                    // Load file lên server
                    await _uploadFile(file);
                  } else {
                    print("No file selected.");
                  }
                },
                child: Text("Load File"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Submit report
                print('Report submitted');
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  // Hàm để tải file lên server
  Future<void> _uploadFile(File file) async {
    String uploadUrl = 'http://localhost:3000/api/upload_report';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        print('File uploaded successfully');
      } else {
        print('File upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }
}
