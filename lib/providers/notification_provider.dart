import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/models/notification.dart';
import 'package:todo_list_riverpod/repositories/notification_repository.dart';
import 'package:todo_list_riverpod/services/notification_api.dart';
import 'package:todo_list_riverpod/viewmodels/notification_viewmodel.dart';

final notificationProvider = StateProvider<Notification?>((ref) => null);

final listNotificationProvider = StateProvider<List<Notification>>((ref) => []);

final notificationApiProvider = Provider((ref) {
  return NotificationApi();
});

final notificationRepositoryProvider = Provider((ref) {
  final apiService = ref.read(notificationApiProvider);
  return NotificationRepository(apiService);
});

final notificationViewmodelProvider = Provider((ref) {
  final repository = ref.read(notificationRepositoryProvider);
  return NotificationViewmodel(repository, ref);
});