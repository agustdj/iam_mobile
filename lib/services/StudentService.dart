import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart'; 

class StudentService {
  final String baseUrl =
      "http://192.168.1.18:3000/api";

  // Fetch internship details by groupId
  Future<List<String>> fetchStudentIdsByGroupId(String groupId) async {
    final url = Uri.parse(
        '$baseUrl/internship/detail/group/$groupId'); 
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Extract student IDs from the fetched internship details
        List<String> studentIds = [];
        for (var item in data) {
          studentIds.add(
              item['studentId']); // Assuming the response contains a studentId
        }

        return studentIds; // Return the list of student IDs
      } else {
        throw Exception("Failed to load internship details");
      }
    } catch (e) {
      print("Error fetching internship details: $e");
      return [];
    }
  }

  Future<List<Student>> fetchStudentsByIds(List<String> studentIds) async {
    final url = Uri.parse('$baseUrl/student'); // API endpoint
    List<Student> students =
        []; // Initialize an empty list to store the students

    try {
      // Use Future.wait to fetch each student by ID in parallel
      final futures = studentIds.map((id) async {
        final response = await http.get(Uri.parse('$url/$id'), headers: {
          'Content-Type': 'application/json',
        });

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return Student.fromJson(data);
        } else {
          throw Exception("Failed to load student with ID: $id");
        }
      }).toList();

      // Wait for all requests to finish and add the students to the list
      students = await Future.wait(futures);

      return students;
    } catch (e) {
      print("Error fetching students: $e");
      return [];
    }
  }
}
