import 'package:todo_list_riverpod/services/api_service.dart';

class FirebaseNotifyService extends ApiService {
  Future<void> sendNotificationToAllUser(String title, String body) {
    return post('firebase/sendNotificationToAllUser', {
      'title': title,
      'body': body,
    });
  }
}
