class Teacher {
  final String id;
  final String userId; 
  final String name; 
  final String department; 
  final DateTime createdAt; 

  Teacher({
    required this.id,
    required this.userId,
    required this.name,
    required this.department,
    required this.createdAt,
  });

  // Factory method to parse JSON response into Teacher object
  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['_id'],
      userId: json['userId'], 
      name: json['name'], 
      department: json['department'], 
      createdAt: DateTime.parse(json['createdAt']), 
    );
  }

  // Method to convert Teacher object into JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId, 
      'name': name, 
      'department': department, 
      'createdAt':
          createdAt.toIso8601String(), 
    };
  }
}
