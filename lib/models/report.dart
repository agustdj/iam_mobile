import 'dart:convert';

class Report {
  final String id;
  final String name;
  final String path;
  final String createdBy; 
  final DateTime createdAt;
  final String status;
  final String fileType;
  final String internshipId; 

  Report({
    required this.id,
    required this.name,
    required this.path,
    required this.createdBy,
    required this.createdAt,
    required this.status,
    required this.fileType,
    required this.internshipId, 
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['_id'],
      name: json['name'],
      path: json['path'],
      createdBy: json['createdBy'],
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'],
      fileType: json['fileType'],
      internshipId: json['internshipId'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'path': path,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
      'fileType': fileType,
      'internshipId': internshipId, 
    };
  }
}
