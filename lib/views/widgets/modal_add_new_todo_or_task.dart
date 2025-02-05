import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/providers/auth_provider.dart';

class ModalAddNewTodo extends ConsumerStatefulWidget {
  const ModalAddNewTodo(
    this.type, {
    super.key,
    required this.onAdd,
  });
  final Function(String title, String userId) onAdd;
  final String type;

  @override
  ConsumerState<ModalAddNewTodo> createState() => _ModalAddNewTodoState();
}

class _ModalAddNewTodoState extends ConsumerState<ModalAddNewTodo> {
  final TextEditingController _todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Container(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add New ${widget.type}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown[400],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _todoController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter title';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Enter ${widget.type.toLowerCase()} title',
                labelText: widget.type,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(
                  Icons.note_add_outlined,
                  color: Colors.brown[400],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[400],
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onAdd(_todoController.text.trim(), user!.id ?? "");
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
