import 'package:json_annotation/json_annotation.dart';
import 'package:todo_list_riverpod/models/task.dart';
part 'todo.g.dart';

@JsonSerializable()
class Todo {
  final String id;
  final String title;
  final List<Task> tasks;
  Todo({
    required this.id,
    required this.title,
    required this.tasks,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['_id'],
      title: json['title'],
      tasks: (json['tasks'] as List)
          .map((task) => Task.fromJson(task))
          .toList(),  
    );
  }

  Map<String, dynamic> toJson() => _$TodoToJson(this);

  @override
  String toString() {
    return 'Todo{id: $id, title: $title, tasks: $tasks}';
  }
}
