import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/models/conversation.dart';
import 'package:todo_list_riverpod/models/message.dart';
import 'package:todo_list_riverpod/providers/conversation_provider.dart';
import 'package:todo_list_riverpod/repositories/conversation_repository.dart';

class ConversationViewmodel {
  final ConversationRepository _conversationRepository;
  late final Ref ref;
  final TextEditingController messageController = TextEditingController();
  bool isFetching = false;
  bool isEmojiPickerVisible = false;
  int page = 1;
  int limit = 10;
  bool isLoading = false;
  bool isLoadMoreOldMessage = false;

  ConversationViewmodel(this._conversationRepository, this.ref);

  Future<void> init(String userId, String friendId) async {
    isLoadMoreOldMessage = false;
    page = 1;
    isFetching = true;
    if (isFetching) {
      ref.read(listMessageProvider.notifier).state = [];
    }
    getConversations(userId, friendId).then((value) {
      getMessages(value.id);
      isFetching = false;
    });
  }

  Future<Conversation> getConversations(String userId, String friendId) async {
    var respone =
        await _conversationRepository.getConversationById(userId, friendId);
    ref.read(conversationprovider.notifier).state = respone;
    return respone;
  }

  Future<List<Message>> getMessages(String conversationId) async {
    if (isLoading) return [];
    isLoading = true;

    try {
      var response = await _conversationRepository.getMessages(
          conversationId, page, limit);

      ref.read(listMessageProvider.notifier).update((state) {
        return [...response, ...state];
      });

      page++;

      return response;
    } catch (e) {
      print("Error fetching messages: $e");
      return [];
    } finally {
      isLoading = false;
      // isLoadMoreOldMessage = false;
    }
  }

  Future<dynamic> sendMessage(String message, String senderId,
      String recipientId, String conversationId) async {
    var previus = ref.read(listMessageProvider.notifier).state;
    var data = Message(
      conversationId: conversationId,
      message: messageController.text,
      sender: senderId,
      recipient: recipientId,
      messageStatus: 'sent',
      messageType: 'text',
      read: false,
      timestamp: DateTime.now().toLocal(),
    );

    ref.read(listMessageProvider.notifier).state = [
      ...previus,
      data,
    ];

    var dataSend = {
      "senderId": senderId,
      "recipientId": recipientId,
      "message": message,
    };

    var respone =
        await _conversationRepository.sendMessage(dataSend).then((value) {
      messageController.clear();
    });
    return respone;
  }

  isSentByMe(Message message, String userId) {
    return message.sender == userId;
  }

  void handlereceiveMessage(Message message) {
    var previus = ref.read(listMessageProvider.notifier).state;
    ref.read(listMessageProvider.notifier).state = [
      ...previus,
      message,
    ];
  }

  //toggle emoji picker
  void toggleEmojiPicker() {
    isEmojiPickerVisible = !isEmojiPickerVisible;
  }
}
