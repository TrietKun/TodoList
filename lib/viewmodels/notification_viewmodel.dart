import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:todo_list_riverpod/providers/notification_provider.dart';
import 'package:todo_list_riverpod/repositories/notification_repository.dart';

class NotificationViewmodel {
  final NotificationRepository _repository;
  final Ref ref;
  int limit = 10;
  int page = 1;
  bool isFetched = false;
  bool isLoading = false;
  bool isRefresh = false;

  NotificationViewmodel(this._repository, this.ref);

  Future<void> init(BuildContext context, String id) async {
    page = 1;
    isRefresh = true;
    await fetchNotifications(context, id).then((value) => {
          isFetched = true,
        });
  }

  Future<void> fetchNotifications(BuildContext context, String id) async {
    if (isLoading) return; // Nếu đang tải thì không thực hiện thêm

    if (isRefresh) {
      ref.read(listNotificationProvider.notifier).state = [];
      isRefresh = false;
    }

    isLoading = true; // Đánh dấu trạng thái đang tải

    showDialog(
      context: context,
      barrierDismissible: false, // Không cho phép đóng hộp thoại khi tải
      builder: (context) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: LoadingAnimationWidget.inkDrop(
              color: Colors.brown[400] ?? Colors.brown,
              size: 50,
            ),
          ),
        );
      },
    );

    try {
      await Future.delayed(const Duration(seconds: 1));

      final newNotifications =
          await _repository.getAllNotificationByUserId(id, page, limit);

      ref.read(listNotificationProvider.notifier).update((state) {
        return [...state, ...newNotifications];
      });

      page++;
    } on DioException catch (e) {
      print("Error fetching notifications: $e");
    } catch (e) {
      print("Error fetching notifications: $e");
    } finally {
      isLoading = false; // Kết thúc tải

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  String formatDateTime(DateTime createdAt) {
    //neu < 1 ngay thi hien thi gio
    final now = DateTime.now().toIso8601String();
    final diff = DateTime.parse(now).difference(createdAt);
    if (diff.inDays == 0) {
      return "Today at ${createdAt.hour}:${createdAt.minute}";
    } else if (diff.inDays == 1) {
      return "Yesterday at ${createdAt.hour}:${createdAt.minute}";
    } else {
      return "${createdAt.day}/${createdAt.month}/${createdAt.year}";
    }
  }
}
