class Student {
  final String id;
  final String name;
  final String
      className; 
  final String department;
  final String major;
  final String userId; 
  final DateTime createdAt;

  Student({
    required this.id,
    required this.name,
    required this.className,
    required this.department,
    required this.major,
    required this.userId, 
    required this.createdAt,
  });

  // Factory method to parse JSON response into Student object
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'],
      name: json['name'],
      className: json['class'], 
      department: json['department'],
      major: json['major'],
      userId: json['userID']?['_id'] ?? '', 
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'class': className, 
      'department': department,
      'major': major,
      'userID': {'_id': userId}, 
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
