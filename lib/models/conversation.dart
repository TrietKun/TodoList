class Conversation {
  String id;
  List<String> participants;
  DateTime createdAt;
  DateTime updatedAt;
  String theLastMessage;
  DateTime theLastMessageTime;
  String conversationStatus;

  Conversation({
    required this.id,
    required this.participants,
    required this.createdAt,
    required this.updatedAt,
    required this.theLastMessage,
    required this.theLastMessageTime,
    required this.conversationStatus,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['_id'],
      participants: List<String>.from(json['participants']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      theLastMessage: json['theLastMessage'],
      theLastMessageTime: DateTime.parse(json['theLastMessageTime']),
      conversationStatus: json['conversationStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'participants': participants,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'theLastMessage': theLastMessage,
      'theLastMessageTime': theLastMessageTime.toIso8601String(),
      'conversationStatus': conversationStatus,
    };
  }

  @override
  String toString() {
    return 'Conversation{id: $id, participants: $participants, createdAt: $createdAt, updatedAt: $updatedAt, theLastMessage: $theLastMessage, theLastMessageTime: $theLastMessageTime, conversationStatus: $conversationStatus}';
  }

  copyWith({required conversationStatus}) {
    return Conversation(
      id: id,
      participants: participants,
      createdAt: createdAt,
      updatedAt: updatedAt,
      theLastMessage: theLastMessage,
      theLastMessageTime: theLastMessageTime,
      conversationStatus: conversationStatus,
    );
  }
}
