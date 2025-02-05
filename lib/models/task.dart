import 'package:json_annotation/json_annotation.dart';
part 'task.g.dart';

@JsonSerializable()
class Task {
  String todoId;
  String id;
  String title;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.todoId,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  Task copyWith({required bool isCompleted}) {
    return Task(
      id: id,
      title: title,
      isCompleted: isCompleted,
      todoId: todoId,
    );
  }
}
