import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/internship-detail.dart'; 

class InternshipDetailsService {
  final String baseUrl =
      'http://192.168.1.18:3000/api/internship/detail'; 

  // Get internship details by ID
  Future<InternshipDetails?> getInternshipDetailsById(String id) async {
    final url = Uri.parse('$baseUrl/$id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return InternshipDetails.fromJson(data);
      } else if (response.statusCode == 404) {
        return null; // ID not found
      } else {
        throw Exception(
            'Failed to fetch internship detail. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching internship detail: $e');
      throw Exception('An error occurred while fetching internship detail.');
    }
  }
  
}
