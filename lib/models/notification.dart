class Notifications {
  final String id;
  final String name;
  final String content;
  final String internshipId;
  final String groupId;
  final String creator;
  final DateTime datePosted;

  Notifications({
    required this.id,
    required this.name,
    required this.content,
    required this.internshipId,
    required this.groupId,
    required this.creator,
    required this.datePosted,
  });

  // Factory method to create a Notification object from a JSON response
  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      id: json['_id'],
      name: json['name'],
      content: json['content'],
      internshipId: json['internshipId'],
      groupId: json['groupId'],
      creator: json['creator'], 
      datePosted: DateTime.parse(json['datePosted']),
    );
  }

  // Method to convert a Notification object to JSON (useful for requests)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'content': content,
      'internshipId': internshipId,
      'groupId': groupId,
      'creator': creator,
      'datePosted': datePosted.toIso8601String(),
    };
  }
}
