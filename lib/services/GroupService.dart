import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/group.dart';

class GroupService {
  final String baseUrl =
      "http://192.168.1.18:3000/api"; 

  Future<List<Group>> fetchGroupsByTeacherId(String teacherId) async {
    final url = Uri.parse('$baseUrl/group/teacher/$teacherId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((item) => Group.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load groups");
      }
    } catch (e) {
      print("Error fetching groups: $e");
      return [];
    }
  }
}
