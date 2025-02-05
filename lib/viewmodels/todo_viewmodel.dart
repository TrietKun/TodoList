import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/models/task.dart';
import 'package:todo_list_riverpod/providers/todo_provider.dart';
import 'package:todo_list_riverpod/views/widgets/modal_add_new_todo_or_task.dart';
import '../models/todo.dart';
import '../repositories/todo_repository.dart';

class TodoViewModel extends StateNotifier<List<Todo>> {
  final TodoRepository _repository;
  final Ref ref;

  TodoViewModel(this._repository, this.ref) : super([]);

  Future<void> fetchTodos(String id) async {
    try {
      await _repository.fetchTodos(id).then((value) => {
            ref.read(todoProvider.notifier).state = value,
          });
    } catch (e) {
      print("Error fetching todos: $e");
    }
  }

  Future<void> addTodo(String todo, String userId) async {
    final todos = ref.read(todoProvider);

    try {
      await _repository.createTodo(todo, userId).then((value) {
        ref.read(todoProvider.notifier).state = [
          ...todos,
          Todo(
            id: value.id,
            title: todo,
            tasks: [],
          ),
        ];
      });

      print("Danh sách Todos sau khi thêm: ${ref.read(todoProvider)}");
    } catch (e) {
      print("Error adding todo: $e");
    }
  }

  Future<void> removeTodo(String id, String userId) async {
    print("Removing todo with id: $id");
    try {
      await _repository.deleteTodo(id, userId).then((value) {
        // Lấy danh sách todos hiện tại từ todoProvider
        final todos = ref.read(todoProvider);

        // Lọc ra những Todo có ID khác với ID của Todo cần xóa
        final newTodos = todos.where((todo) => todo.id != id).toList();

        // Cập nhật danh sách todos mới
        ref.read(todoProvider.notifier).state = newTodos;
      });
    } catch (e) {
      print("Error removing todo: $e");
    }
  }

  Future<void> addTask(String task, String userId, String todoId) async {
    final todos = ref.read(todoProvider);

    try {
      await _repository.createTask(task, todoId).then((value) {
        final newTodos = todos.map((todo) {
          if (todo.id == todoId) {
            return Todo(
              id: todo.id,
              title: todo.title,
              tasks: [
                ...todo.tasks,
                Task(
                  id: value.id,
                  title: task,
                  isCompleted: false,
                  todoId: todoId,
                ),
              ],
            );
          }
          return todo;
        }).toList();

        ref.read(todoProvider.notifier).state = newTodos;
      });
      print("Danh sách Todos sau khi thêm Task: ${ref.read(todoProvider)}");
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  Future<void> removeTask(
      String id, String userId, String todoId, String token) async {
    try {
      // Chờ cho deleteTask hoàn tất trước khi tiếp tục
      await _repository.deleteTask(id, token).then((value) {
        final todos = ref.read(todoProvider);

        // Cập nhật lại danh sách todo sau khi xóa task
        final newTodos = todos.map((todo) {
          if (todo.id == todoId) {
            final newTasks = todo.tasks.where((task) => task.id != id).toList();
            return Todo(
              id: todo.id,
              title: todo.title,
              tasks: newTasks,
            );
          }
          return todo;
        }).toList();

        // Cập nhật lại state với danh sách mới
        ref.read(todoProvider.notifier).state = newTodos;
      });
    } catch (e) {
      print("Error removing task: $e");
    }
  }

  void openModalAddNewTodo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ModalAddNewTodo(onAdd: (
          String todo,
          String userId,
        ) {
          addTodo(
            todo,
            userId,
          );
        }, "Todo"),
      ),
    );
  }

  void openModelAddNewTask(BuildContext context, String todoId) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ModalAddNewTodo(onAdd: (
          String task,
          String userId,
        ) {
          addTask(
            task,
            userId,
            todoId,
          );
        }, "Task"),
      ),
    );
  }
}
