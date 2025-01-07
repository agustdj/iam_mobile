import './teacher.dart';

class Group {
  final String id;
  final String name;
  final String internshipId;
  final Teacher teacher; 
  final DateTime createdAt;

  Group({
    required this.id,
    required this.name,
    required this.internshipId,
    required this.teacher, 
    required this.createdAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['_id'],
      name: json['name'],
      internshipId: json['internshipId'],
      teacher: Teacher.fromJson(json['teacherId']), 
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'internshipId': internshipId,
      'teacherId': teacher.toJson(), 
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
