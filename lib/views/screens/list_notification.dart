import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/providers/auth_provider.dart';
import 'package:todo_list_riverpod/providers/notification_provider.dart';

class ListNotification extends ConsumerStatefulWidget {
  const ListNotification({super.key});

  @override
  ConsumerState<ListNotification> createState() => _ListNotificationState();
}

class _ListNotificationState extends ConsumerState<ListNotification> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationViewmodelProvider).init(context, user!.id ?? "");
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        ref.read(notificationViewmodelProvider).fetchNotifications(
              context,
              user!.id ?? "",
            );
      }
      if (_scrollController.position.pixels == 0) {
        ref.read(notificationViewmodelProvider).init(context, user!.id ?? "");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final listNotification = ref.watch(listNotificationProvider);
    final notificationViewmodel = ref.read(notificationViewmodelProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: const Text('Notifications'),
      ),
      body: Center(
        child: listNotification.isEmpty
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications,
                    size: 100,
                    color: Colors.brown,
                  ),
                  Text(
                    'You don\'t have any notifications!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ],
              )
            : NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification.metrics.pixels ==
                          scrollNotification.metrics.maxScrollExtent &&
                      !notificationViewmodel.isLoading) {
                    // Gọi API để tải thêm thông báo
                    final user = ref.read(userProvider);
                    notificationViewmodel.fetchNotifications(
                        context, user!.id ?? "");
                  }
                  return false;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: listNotification.length + 1, // +1 để thêm loader
                  itemBuilder: (context, index) {
                    if (index == listNotification.length) {
                      // Hiển thị loader khi đang tải thêm
                      return notificationViewmodel.isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : const SizedBox.shrink();
                    }

                    final notification = listNotification[index];
                    return Container(
                      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      decoration: BoxDecoration(
                        color: Colors.brown[300],
                        borderRadius: BorderRadius.circular(8),
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[300]!,
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                        title: Text(
                          notification.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          notification.message,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                                notificationViewmodel
                                    .formatDateTime(notification.createdAt),
                                style: const TextStyle(
                                  color: Colors.white,
                                )),
                            const SizedBox(height: 8),
                            if (!notification.read)
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'New',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
