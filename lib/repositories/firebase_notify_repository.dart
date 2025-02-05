import 'package:todo_list_riverpod/services/firebase_notify_service.dart';

class FirebaseNotifyRepository {
  final FirebaseNotifyService firebaseNotifyService;

  FirebaseNotifyRepository(this.firebaseNotifyService);

  Future<void> sendNotificationToAllUser(String title, String body) async {
    return firebaseNotifyService.sendNotificationToAllUser(title, body);
  }
}
