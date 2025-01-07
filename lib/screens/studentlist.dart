import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/StudentService.dart';
import '../models/student.dart'; 
import '../services/GlobalService.dart'; 
class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final GlobalService globalService =
      Get.find(); // Access the GlobalService instance
  final StudentService internshipService = StudentService();

  List<Student> students = [];
  List<Student> filteredStudents = [];
  bool _isSearching = false;

  // Text editing controller for search bar
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  // Load students based on groupId
  Future<void> _loadStudents() async {
    final groupId = globalService.groupId.value;
    List<Student> studentList = await getStudentsByGroupId(groupId);
    setState(() {
      students = studentList;
      filteredStudents =
          students; // Initialize filtered students with all students
    });
  }

  // Filter students based on search query
  void _filterStudents(String query) {
    List<Student> filtered = students
        .where((student) =>
            student.name.toLowerCase().contains(query.toLowerCase()) ||
            student.className.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredStudents = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                onChanged: _filterStudents,
                autofocus: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              )
            : Text('Student List'),
        leading: Image.asset(
          'assets/images/logo.png', 
          fit: BoxFit.cover,
          height: 40, 
          width: 40, 
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.clear : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _filterStudents('');
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              _showCreateNotificationPopup(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: filteredStudents.isEmpty
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: DataTable(
                      headingRowHeight: 56,
                      dataRowHeight: 60,
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Class')),
                        DataColumn(label: Text('Department')),
                        DataColumn(label: Text('Created At')),
                      ],
                      rows: filteredStudents
                          .map(
                            (student) => DataRow(
                              cells: [
                                DataCell(Text(student.name)),
                                DataCell(Text(student.className)),
                                DataCell(Text(student.department)),
                                DataCell(
                                    Text(student.createdAt.toIso8601String())),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }


  // Get the list of students by groupId
  Future<List<Student>> getStudentsByGroupId(String groupId) async {
    // Fetch student IDs by groupId
    List<String> studentIds =
        await internshipService.fetchStudentIdsByGroupId(groupId);

    if (studentIds.isNotEmpty) {
      // Fetch student details by studentIds
      return await internshipService.fetchStudentsByIds(studentIds);
    } else {
      return [];
    }
  }

  // Show the popup dialog to create a new notification
  void _showCreateNotificationPopup(BuildContext context) {
    final _titleController = TextEditingController();
    final _messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          title: Text('Create New Notification', textAlign: TextAlign.center),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Notification Title',
                    labelStyle: TextStyle(color: Colors.blueAccent),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _messageController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Notification Message',
                    labelStyle: TextStyle(color: Colors.blueAccent),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Dismiss the dialog
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    String title = _titleController.text;
                    String message = _messageController.text;

                    // Implement your logic to save the notification
                    // For example, call an API or save it locally

                    // Show a success message and dismiss the popup
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Notification Created')),
                    );
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Create'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
