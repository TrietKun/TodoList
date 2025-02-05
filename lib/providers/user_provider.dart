import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/models/user.dart';
import 'package:todo_list_riverpod/providers/todo_provider.dart';
import 'package:todo_list_riverpod/repositories/user_repository.dart';
import 'package:todo_list_riverpod/viewmodels/user_viewmodel.dart';

final listUserProvider = StateProvider<List<User>>((ref) => []);

final userSearchProvider = StateProvider<User?>((ref) => null);

final fcmToken = StateProvider<String>((ref) => '');

final userRepositoryProvider = Provider((ref) {
  final apiService = ref.read(apiServiceProvider);
  return UserRepository(apiService);
});

final userViewModelProvider  = Provider((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return UserViewmodel(userRepository,ref);
});