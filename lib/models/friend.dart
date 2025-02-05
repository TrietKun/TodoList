import 'package:json_annotation/json_annotation.dart';
import 'package:todo_list_riverpod/models/conversation.dart';
part 'friend.g.dart';

@JsonSerializable()
class Friend {
  String id;
  String name;
  String email;
  String status;
  Conversation conversation;

  Friend({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.conversation,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      status: json['status'] ?? 'offline',
      conversation: Conversation.fromJson(json['conversation']),
    );
  }

  Friend copyWith({
    String? id,
    String? name,
    String? email,
    String? status,
    Conversation? conversation,
  }) {
    return Friend(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      status: status ?? this.status,
      conversation: conversation ?? this.conversation,
    );
  }

  Map<String, dynamic> toJson() => _$FriendToJson(this);

  @override
  String toString() {
    return 'Friend{id: $id, name: $name, email: $email, status: $status}';
  }
}