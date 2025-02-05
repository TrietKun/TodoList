import 'package:todo_list_riverpod/models/notification.dart';
import 'package:todo_list_riverpod/services/notification_api.dart';

class NotificationRepository {
  final NotificationApi _apiService;

  NotificationRepository(this._apiService);

  Future<List<Notification>> getAllNotificationByUserId(String id, int page, int limit) async {
    return _apiService.getAllNotificationByUserId(id, page, limit);
  }
}
