class InternshipDetails {
  final String id;
  final String studentId; 
  final String teacherId; 
  final String internshipId; 
  final String company; 
  final String position; 
  final int score; 
  final String groupId; 

  InternshipDetails({
    required this.id,
    required this.studentId,
    required this.teacherId,
    required this.internshipId,
    required this.company,
    required this.position,
    required this.score,
    required this.groupId,
  });

  // Factory method to parse JSON response into InternshipDetails object
  factory InternshipDetails.fromJson(Map<String, dynamic> json) {
    return InternshipDetails(
      id: json['_id'] ?? '',
      studentId: json['studentId'] ??'', 
      teacherId: json['teacherId'] ??'', 
      internshipId: json['internshipId']??'',
      company: json['company']??'', 
      position: json['position']??'', 
      score: json['score']??0, 
      groupId: json['groupId']??'', 
    );
  }

  // Method to convert InternshipDetails object into JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'studentId': studentId,
      'teacherId': teacherId,
      'internshipId': internshipId,
      'company': company,
      'position': position,
      'score': score,
      'groupId': groupId,
    };
  }
}
