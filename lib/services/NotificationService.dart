import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

class NotificationService {
  final String apiUrl = 'http://localhost:3000/api/notification'; 

  /// get list thông báo dựa trên internshipId và groupId
  Future<List<Map<String, dynamic>>> fetchNotifications(
      String internshipId, String groupId) async {
    final Uri url = Uri.parse('$apiUrl/group/$groupId/internship/$internshipId');

    try {
      final response = await http.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw Exception(
            'Failed to load notifications. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching notifications: $error');
      throw Exception('Could not fetch notifications');
    }
  }
}