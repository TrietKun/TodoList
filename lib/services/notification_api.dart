import 'package:todo_list_riverpod/models/notification.dart';
import 'package:todo_list_riverpod/services/api_service.dart';

class NotificationApi extends ApiService {
  Future<List<Notification>> getAllNotificationByUserId(
      String id, int page, int limit) async {
    final response =
        await get('notifications/getAllNotificationOfUser/$id/$page/$limit');
    return (response.data as List)
        .map((e) => Notification.fromJson(e))
        .toList();
  }
}
