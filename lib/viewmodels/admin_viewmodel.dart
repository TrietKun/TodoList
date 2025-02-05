import 'package:todo_list_riverpod/repositories/firebase_notify_repository.dart';

class AdminViewmodel {
  final FirebaseNotifyRepository _firebaseNotifyRepository;

  AdminViewmodel(this._firebaseNotifyRepository);

  Future<void> sendNotificationToAllUser(String title, String body) async {
    return _firebaseNotifyRepository.sendNotificationToAllUser(title, body);
  }
}
