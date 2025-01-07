
class User {
  final String id;
  final String username;
  final String email;
  final String role; 
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  // Assuming this is how you parse the JSON response
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      username: json['username'],
      email: json['email'],
      role: json[
          'role'], 
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
