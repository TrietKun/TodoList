class Notification {
  String id;
  String title;
  dynamic message;
  bool read;
  DateTime createdAt;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.read,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['_id'],
      title: json['title'],
      message: json['message'],
      read: json['read'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'message': message,
      'read': read,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Notification copyWith({
    String? id,
    String? title,
    dynamic message,
    bool? read,
    DateTime? createdAt,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      read: read ?? this.read,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Notification{id: $id, title: $title, message: $message, read: $read, createdAt: $createdAt}';
  }
}
