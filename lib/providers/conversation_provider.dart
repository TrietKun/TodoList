import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/models/conversation.dart';
import 'package:todo_list_riverpod/models/message.dart';
import 'package:todo_list_riverpod/repositories/conversation_repository.dart';
import 'package:todo_list_riverpod/services/conversation_api.dart';
import 'package:todo_list_riverpod/viewmodels/conversation_viewmodel.dart';

final conversationprovider = StateProvider<Conversation?>((ref) => null);

final listConversation = StateProvider<List<Conversation>>((ref) => []);

final conversationApiProvider = Provider((ref) {
  return ConversationApi();
});

final listMessageProvider = StateProvider<List<Message>>((ref) => []);

final conversationRepositoryProvider = Provider((ref) {
  final apiService = ref.read(conversationApiProvider);
  return ConversationRepository(apiService);
});

final conversationViewmodelProvider = Provider((ref) {
  final repository = ref.read(conversationRepositoryProvider);
  return ConversationViewmodel(repository, ref);
});