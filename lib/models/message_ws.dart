class MessageWs {
  String typeMessage;
  dynamic message;

  MessageWs({
    required this.typeMessage,
    required this.message,
  });

  factory MessageWs.fromJson(Map<String, dynamic> json) {
    return MessageWs(
      typeMessage: json['typeMessage'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'typeMessage': typeMessage,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'MessageWs{typeMessage: $typeMessage, message: $message}';
  }
}
