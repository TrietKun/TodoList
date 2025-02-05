import 'package:todo_list_riverpod/models/conversation.dart';
import 'package:todo_list_riverpod/models/message.dart';
import 'package:todo_list_riverpod/models/message_ws.dart';
import 'package:todo_list_riverpod/services/api_service.dart';

class ConversationApi extends ApiService {
  Future<Conversation> getAllNotificationByUserId(String id) async {
    final response = await get('messages/getAllNotificationOfUser/$id');
    return Conversation.fromJson(response.data);
  }

  Future<Conversation> getConversation(String userId, String friendId) async {
    final response = await get('messages/getConversation/$userId/$friendId');
    return Conversation.fromJson(response.data);
  }

  Future<List<Message>> getMessages(
      String conversationId, int page, int limit) async {
    final response = await get(
        'messages/getMessagesByConversationId/$conversationId/$page/$limit');
    return (response.data as List).map((e) => Message.fromJson(e)).toList();
  }

  Future<MessageWs> sendMessage(dynamic message) async {
    final response = await post('messages/sendMessageToUser', message);
    print('responseapi: $response');
    return MessageWs.fromJson(response.data);
  }
}
