class Message {
  String conversationId;
  String sender;
  String recipient;
  String message;
  DateTime timestamp;
  bool read;
  String messageType;
  String messageStatus;

  Message({
    required this.conversationId,
    required this.sender,
    required this.recipient,
    required this.message,
    required this.timestamp,
    required this.read,
    required this.messageType,
    required this.messageStatus,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      conversationId: json['conversationId'],
      sender: json['sender'],
      recipient: json['recipient'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      read: json['read'],
      messageType: json['messageType'],
      messageStatus: json['messageStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'sender': sender,
      'recipient': recipient,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'read': read,
      'messageType': messageType,
      'messageStatus': messageStatus,
    };
  }

  Message copyWith({
    String? conversationId,
    String? sender,
    String? recipient,
    String? message,
    DateTime? timestamp,
    bool? read,
    String? messageType,
    String? messageStatus,
  }) {
    return Message(
      conversationId: conversationId ?? this.conversationId,
      sender: sender ?? this.sender,
      recipient: recipient ?? this.recipient,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      read: read ?? this.read,
      messageType: messageType ?? this.messageType,
      messageStatus: messageStatus ?? this.messageStatus,
    );
  }

  @override
  String toString() {
    return 'Message{conversationId: $conversationId, sender: $sender, recipient: $recipient, message: $message, timestamp: $timestamp, read: $read, messageType: $messageType, messageStatus: $messageStatus}';
  }
}
