import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/models/friend.dart';
import 'package:todo_list_riverpod/repositories/friend_repository.dart';
import 'package:todo_list_riverpod/services/friend_api.dart';
import 'package:todo_list_riverpod/viewmodels/friend_viewmodel.dart';

final listFriendProvider = StateProvider<List<Friend>>((ref) => []);

final friendProvider = StateProvider<Friend?>((ref) => null);

final friendApiProvider = Provider((ref) {
  return FriendApi();
});

final friendRepositoryProvider = Provider((ref) {
  final apiService = ref.read(friendApiProvider);
  return FriendRepository(apiService);
});

final friendViewModelProvider = Provider((ref) {
  final friendRepository = ref.read(friendRepositoryProvider);
  return FriendViewmodel(friendRepository, ref);
});
