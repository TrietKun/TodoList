import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/models/todo.dart';
import 'package:todo_list_riverpod/providers/auth_provider.dart';
import 'package:todo_list_riverpod/providers/todo_provider.dart';

class ItemListTodo extends ConsumerStatefulWidget {
  const ItemListTodo({super.key, required this.todo});
  final Todo todo;

  @override
  ConsumerState<ItemListTodo> createState() => _ItemListTodoState();
}

class _ItemListTodoState extends ConsumerState<ItemListTodo> {
  @override
  Widget build(BuildContext context) {
    final todoViewModel = ref.read(todoViewModelProvider);
    final accessToken = ref.read(accessTokenProvider);
    final user = ref.read(userProvider);

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.todo.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 18.0,
                        ),
                  ),
                  const SizedBox(height: 12.0),
                  if (widget.todo.tasks.isNotEmpty) ...[
                    ...widget.todo.tasks.map((e) {
                      return Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.brown,
                              width: 2.0,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                title: Text(
                                  e.title,
                                  style: TextStyle(
                                    color: e.isCompleted
                                        ? Colors.green
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                value: e.isCompleted,
                                activeColor: Colors.brown[400],
                                onChanged: (value) {
                                  setState(() {
                                    final index = widget.todo.tasks.indexOf(e);
                                    widget.todo.tasks[index] =
                                        e.copyWith(isCompleted: value!);
                                  });
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                if (user?.id != null) {
                                  todoViewModel.removeTask(
                                    e.id,
                                    user!.id!,
                                    widget.todo.id,
                                    accessToken,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ] else ...[
                    const Text(
                      'No tasks available',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                  Container(
                    padding: const EdgeInsets.only(top: 8.0),
                    decoration: const BoxDecoration(
                        border: Border(
                      top: BorderSide(
                        color: Colors.brown,
                        width: 2.0,
                      ),
                    )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.brown,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon:
                                    const Icon(Icons.add, color: Colors.white),
                                onPressed: () {
                                  todoViewModel.openModelAddNewTask(
                                      context, widget.todo.id);
                                },
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                                onPressed: () {
                                  todoViewModel.removeTodo(
                                    widget.todo.id,
                                    accessToken,
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
