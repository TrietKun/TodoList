import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/providers/friend_provider.dart';
import 'package:todo_list_riverpod/viewmodels/chat_viewModel.dart';

final chatViewModelProvider = Provider((ref) {
  return ChatViewmodel(ref, ref.read(friendRepositoryProvider));
});
