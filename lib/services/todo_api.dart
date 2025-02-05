import 'package:todo_list_riverpod/services/api_service.dart';

class TodoApi extends ApiService {
  Future<List<dynamic>> fetchTodos(String id) async {
    final response = await get('todos/$id');
    return (response.data as List).map((e) => e).toList();
  }

  Future<void> createTodo(Map<String, dynamic> todo) async {
    await post('todos', todo);
  }

  Future<void> deleteTodo(String id, String token) async {
    await delete('todos/$id', token);
  }

  Future<void> createTask(Map<String, dynamic> task) async {
    await post('todos/createTask', task);
  }

  Future<void> deleteTask(String id, String token) async {
    await delete('todos/deleteTask/$id', token);
  }
}
