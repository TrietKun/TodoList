import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/models/todo.dart';
import 'package:todo_list_riverpod/services/todo_api.dart';
import '../repositories/todo_repository.dart';
import '../viewmodels/todo_viewmodel.dart';
import '../services/api_service.dart';

// Provider cho ApiService
final apiServiceProvider = Provider((ref) => ApiService());

final apiServiceTodoProvider = Provider((ref) => TodoApi());

// Provider cho Todo
final todoProvider = StateProvider<List<Todo>>((ref) => []);

// Provider cho TodoRepository
final todoRepositoryProvider = Provider((ref) {
  final apiService = ref.read(apiServiceTodoProvider);
  return TodoRepository(apiService);
});

// Provider cho TodoViewModel
final todoViewModelProvider = Provider((ref) {
  final todoRepository = ref.read(todoRepositoryProvider);
  return TodoViewModel(todoRepository, ref);
});
