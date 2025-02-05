import 'package:todo_list_riverpod/models/task.dart';
import 'package:todo_list_riverpod/services/todo_api.dart';

import '../models/todo.dart';

class TodoRepository {
  final TodoApi _todoApi;

  TodoRepository(this._todoApi);

  Future<List<Todo>> fetchTodos(String id) async {
    final response = await _todoApi.get('/todos/getTodoByIdUser/$id');
    return (response.data as List).map((json) => Todo.fromJson(json)).toList();
  }

  Future<Todo> createTodo(String title, String userId) async {
    final response =
        await _todoApi.post('/todos', {'title': title, 'userId': userId});
    return Todo.fromJson(response.data);
  }

  Future<void> deleteTodo(String id, String token) async {
    await _todoApi.delete('/todos/$id', token);
  }

  Future<Task> createTask(String title, String todoId) async {
    final respone = await _todoApi
        .post('/todos/createTask', {'title': title, 'todoId': todoId});
    return Task.fromJson(respone.data);
  }

  Future<void> deleteTask(String id, String token) async {
    await _todoApi.delete('/todos/deleteTask/$id', token);
  }
}
