import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

class ReportService {
  final String apiUrl = 'http://localhost:3000/api/report'; 

  /// get list sách báo cáo dựa trên studentId và internshipId
  Future<List<Map<String, dynamic>>> fetchReports(
      String internshipId, String studentId) async {
    final Uri url = Uri.parse('$apiUrl/$internshipId/$studentId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw Exception(
            'Failed to load reports. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching reports: $error');
      throw Exception('Could not fetch reports');
    }
  }

  Future<void> uploadReport(String reportId, String internshipId,
      String studentId, String filePath) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$apiUrl/update-report'));

    request.fields['reportId'] = reportId;
    request.fields['internshipId'] = internshipId;
    request.fields['studentId'] = studentId;

    var file = await http.MultipartFile.fromPath(
      'reportFile',
      filePath,
      contentType: MediaType.parse(
          lookupMimeType(filePath) ?? 'application/octet-stream'),
    );
    request.files.add(file);

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Report uploaded and updated successfully');
      } else {
        print('Failed to upload report');
      }
    } catch (error) {
      print('Error uploading report: $error');
    }
  }
}
