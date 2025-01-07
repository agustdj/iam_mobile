import 'package:flutter/material.dart';
import '../services/test.dart';
import '../models/student.dart';

class StudentDetailsScreen extends StatefulWidget {
  final String userId;

  const StudentDetailsScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  _StudentDetailsScreenState createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  final StudentService _service = StudentService();
  late Future<Student?> _studentFuture;

  @override
  void initState() {
    super.initState();
    _studentFuture = _service.getStudentByUserId(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Details'),
      ),
      body: FutureBuilder<Student?>(
        future: _studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Student not found.'));
          }

          final student = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${student.name}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text('Class: ${student.className}',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text('Department: ${student.department}',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text('Major: ${student.major}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text('User ID: ${student.userId}',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text('Created At: ${student.createdAt}',
                    style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );
  }
}
