class Internship {
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String studentId; 

  Internship({
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.studentId,
  });

  // Factory method to parse the JSON response
  factory Internship.fromJson(Map<String, dynamic> json) {
    return Internship(
      name: json['name'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      studentId: json['studentId'] ?? '', 
    );
  }
}
