import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';

class StudentService {
  final String baseUrl = 'http://192.168.1.18:3000/api/students'; 

  // get studentid dựa vào userId
  Future<Student?> getStudentByUserId(String userId) async {
    final url = Uri.parse('$baseUrl/user/$userId'); 

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Student.fromJson(data);
      } else if (response.statusCode == 404) {
        return null; 
      } else {
        throw Exception(
            'Failed to fetch student. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching student by userId: $e');
      throw Exception('An error occurred while fetching student details.');
    }
  }
}
