import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotification {
  final String? title;
  final String? body;
  final Map<String, dynamic> data;
  final String? messageId;
  final String? sentTime;
  final String? from;

  FirebaseNotification({
    this.title,
    this.body,
    required this.data,
    this.messageId,
    this.sentTime,
    this.from,
  });

  // Factory method để chuyển đổi từ RemoteMessage
  factory FirebaseNotification.fromRemoteMessage(RemoteMessage message) {
    return FirebaseNotification(
      title: message.notification?.title,
      body: message.notification?.body,
      data: message.data,
      messageId: message.messageId,
      sentTime: message.sentTime?.toIso8601String(),
      from: message.from,
    );
  }

  // Phương thức toJson để chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "body": body,
      "data": data,
      "messageId": messageId,
      "sentTime": sentTime,
      "from": from,
    };
  }
}
