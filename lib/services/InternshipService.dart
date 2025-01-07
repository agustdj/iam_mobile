import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:iam_mobile/models/internship-detail.dart'; 

class InternshipService {
  final String apiUrl =
      'http://localhost:3000/api/internship'; 

  // getdetail Internship vào studentId
  Future<List<InternshipDetails>> fetchInternships(String studentId) async {
    final url = Uri.parse(
        '$apiUrl/detail/studentId/$studentId'); 

    print(url);
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        print("API Response: $data");

        return data.map((item) {
          return InternshipDetails.fromJson(
              item); 
        }).toList();
      } else {
        throw Exception('Failed to load internships');
      }
    } catch (e) {
      print('Error fetching internships: $e');
      return [];
    }
  }
}
