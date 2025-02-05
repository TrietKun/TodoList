import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todo_list_riverpod/models/friend.dart';
import 'package:todo_list_riverpod/models/message_ws.dart';
import 'package:todo_list_riverpod/providers/conversation_provider.dart';
import 'package:todo_list_riverpod/providers/friend_provider.dart';
import 'package:todo_list_riverpod/providers/notification_provider.dart';
import 'package:todo_list_riverpod/services/ws_api.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/notification.dart' as notification_custom;
import '../models/message.dart' as message_custom;

class WebsoketViewmodel {
  final WsApi wsApi = WsApi();
  late final Ref ref;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late WebSocketChannel channel;
  MessageWs? message;

  WebsoketViewmodel({required this.ref});

  void _showNotification(notification_custom.Notification notification) async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      if (!status.isGranted) {}
      notifyAndroid(notification);
    }
    if (Platform.isIOS) {
      final bool? permissionGranted = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      if (permissionGranted ?? false) {
        notifyIOS(notification);
      } else {}
    }
  }

  void notifyAndroid(notification_custom.Notification notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '1',
      'Thông báo',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.message,
      platformChannelSpecifics,
      payload: jsonEncode(message!.toJson()),
    );
  }

  void notifyIOS(notification_custom.Notification message) async {
    DarwinNotificationDetails iOSPlatformChannelSpecifics =
        const DarwinNotificationDetails(
      presentAlert: true, // Đảm bảo thông báo có hiển thị
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message.title,
      message.message,
      platformChannelSpecifics,
      payload: jsonEncode(message.toJson()),
    );
  }

  Future<void> connect(String userId, BuildContext context) async {
    wsApi.connect(userId);

    listen((msg) {
      message = msg;
      handleMessageWsReceive(context, message!);
    });
  }

  Future<void> sendMessage(MessageWs message) async {
    wsApi.sendMessage(message.message);
  }

  void listen(Function(MessageWs) onMessage) {
    wsApi.listen((msg) {
      try {
        final decodedData = jsonDecode(msg) as Map<String, dynamic>;
        final messageWs = MessageWs.fromJson(decodedData);
        onMessage(messageWs);
      } catch (e) {
        throw Exception(e);
      }
    });
  }

  void disconnect() {
    wsApi.disconnect();
  }

  void handleMessageWsReceive(BuildContext context, MessageWs message) {
    switch (message.typeMessage) {
      case 'message':
        ref.read(conversationViewmodelProvider).handlereceiveMessage(
            message_custom.Message.fromJson(message.message));
        break;
      case 'notification':
        final newNotification =
            notification_custom.Notification.fromJson(message.message);
        ref.read(listNotificationProvider.notifier).state.add(newNotification);
        _showNotification(newNotification);
        break;
      case 'notification_update_friend':
        final currentList = ref.read(listFriendProvider);
        final updatedList = currentList.map((element) {
          if (element.conversation.participants
              .contains(message.message['userId'])) {
            element.conversation.conversationStatus = message.message['status'];
          }
          return element;
        }).toList();
        ref.read(listFriendProvider.notifier).state = updatedList;
        //update friend status cua conversation trong friendprovider copywith
        final currentFriend = ref.read(friendProvider);
        final updatedFriend = currentFriend!.copyWith(
            conversation: currentFriend.conversation
                .copyWith(conversationStatus: message.message['status']));
        ref.read(friendProvider.notifier).state = updatedFriend;
        break;
      case 'notification_add_friend':
        final currentList = ref.read(listFriendProvider);

        if (currentList
            .any((element) => element.id == message.message['userId'])) {
          final updatedList = currentList.map((element) {
            if (element.id == message.message['userId']) {
              element.conversation.conversationStatus =
                  message.message['status'];
            }
            return element;
          }).toList();
          ref.read(listFriendProvider.notifier).state = updatedList;
        } else {
          final newFriend = Friend.fromJson(message.message['friend']);
          newFriend.conversation.conversationStatus = 'requested';
          final updatedList = [...currentList, newFriend];
          ref.read(listFriendProvider.notifier).state = updatedList;
        }
        break;

      default:
    }
  }
}
