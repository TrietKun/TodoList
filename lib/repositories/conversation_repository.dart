import 'package:todo_list_riverpod/models/conversation.dart';
import 'package:todo_list_riverpod/models/message.dart';
import 'package:todo_list_riverpod/models/message_ws.dart';
import 'package:todo_list_riverpod/services/conversation_api.dart';

class ConversationRepository {
  final ConversationApi conversationApi;

  ConversationRepository(this.conversationApi);

  Future<Conversation> getConversationById(
      String userId, String friendId) async {
    return conversationApi.getConversation(userId, friendId);
  }

  Future<List<Message>> getMessages(String conversationId, int page, int limit) async {
    return conversationApi.getMessages(conversationId, page, limit);
  }

  Future<MessageWs> sendMessage(dynamic message) async {
    var respone = await conversationApi.sendMessage(message);
    return respone;
  }
}
