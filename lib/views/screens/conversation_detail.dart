import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/providers/auth_provider.dart';
import 'package:todo_list_riverpod/providers/friend_provider.dart';
import 'package:todo_list_riverpod/viewmodels/friend_viewmodel.dart';

class ConversationDetail extends ConsumerWidget {
  const ConversationDetail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendViewModel = ref.watch(friendViewModelProvider);
    final user = ref.watch(userProvider);
    final friend = ref.watch(friendProvider);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Container(
              decoration: BoxDecoration(
                color: Colors.brown[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
          backgroundColor: Colors.brown[400],
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 16),
          width: double.infinity,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                'https://avatar.iran.liara.run/public',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 16),
              Text(
                friend!.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                friend.email,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              renderBlockButton(
                context,
                friend.conversation.conversationStatus,
                user!.id ?? "",
                friend.id,
                friendViewModel,
              ),
              const SizedBox(
                height: 16,
              ),
              friend.conversation.conversationStatus == 'friend'
                  ? ElevatedButton(
                      onPressed: () {
                        friendViewModel.unfriend(
                          context,
                          user.id ?? "",
                          friend.id,
                          'unfriend',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[400],
                        minimumSize: const Size(200, 40),
                      ),
                      child: const Text(
                        'Unfriend',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ));
  }
}
