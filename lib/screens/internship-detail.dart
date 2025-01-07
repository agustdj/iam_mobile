import 'package:flutter/material.dart';
import '../services/IntershipDetailService.dart';
import '../models/internship-detail.dart';

class InternshipDetailScreen extends StatefulWidget {
  final String id; // studentID

  InternshipDetailScreen({required this.id});

  @override
  _InternshipDetailScreenState createState() => _InternshipDetailScreenState();
}

class _InternshipDetailScreenState extends State<InternshipDetailScreen> {
  final InternshipDetailsService _service = InternshipDetailsService();

  late Future<InternshipDetails?> _internshipDetail;

  @override
  void initState() {
    super.initState();
    _internshipDetail = _service.getInternshipDetailsById(widget.id);
  }

  void _navigateToSubmitReport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubmitReportScreen(), 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internship Detail'),
      ),
      body: FutureBuilder<InternshipDetails?>(
        future: _internshipDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No internship detail found.'));
          }

          final detail = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, 
                      children: [
                        Text(
                          detail.company,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('Position: ${detail.position}',
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 8),
                        Text('Score: ${detail.score}/10',
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 8),
                        Text('Student ID: ${detail.studentId}',
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 8),
                        Text('Teacher ID: ${detail.teacherId}',
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 8),
                        Text('Group ID: ${detail.groupId}',
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _navigateToSubmitReport,
                  icon: Icon(Icons.upload_file),
                  label: Text("Report"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SubmitReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Report'),
      ),
      body: Center(
        child: Text(
          'Report',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
