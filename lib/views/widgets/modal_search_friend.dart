import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/providers/auth_provider.dart';
import 'package:todo_list_riverpod/providers/friend_provider.dart';
import 'package:todo_list_riverpod/providers/user_provider.dart';

class ModalSearchFriend extends ConsumerStatefulWidget {
  ModalSearchFriend(
      {super.key,
      required this.emailController,
      required this.searchUserByEmail});
  final TextEditingController emailController;
  final Function(String) searchUserByEmail;

  @override
  ConsumerState<ModalSearchFriend> createState() => _ModalSearchFriendState();
}

class _ModalSearchFriendState extends ConsumerState<ModalSearchFriend> {
  bool isFirstSearch = true;
  @override
  Widget build(BuildContext context) {
    final userSearch = ref.watch(userSearchProvider);
    final firendViewModel = ref.read(friendViewModelProvider);
    final user = ref.watch(userProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Search Friend',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.brown[400],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: widget.emailController,
            decoration: InputDecoration(
              hintText: 'Enter email',
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Colors.brown[400],
              ),
            ),
          ),
          const SizedBox(height: 16),
          userSearch != null
              ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.brown[400],
                            child: Text(
                              userSearch.name![0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userSearch.name ?? '',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown[400],
                                ),
                              ),
                              Text(
                                userSearch.email ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.brown[400],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(userSearchProvider.notifier).state = null;
                          isFirstSearch = true;
                          firendViewModel.addFriend(
                              context, user!.id!, userSearch.id!);
                          widget.emailController.clear();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown[400],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.only(bottom: 16),
                  child: Text(
                    textAlign: TextAlign.center,
                    isFirstSearch ? 'Enter email to search' : 'User not found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.brown[400],
                    ),
                  ),
                ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isFirstSearch = false;
              });
              widget.searchUserByEmail(widget.emailController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown[400],
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Search',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
