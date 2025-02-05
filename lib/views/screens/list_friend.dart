import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/providers/auth_provider.dart';
import 'package:todo_list_riverpod/providers/friend_provider.dart';
import 'package:todo_list_riverpod/views/screens/chat.dart';
import 'package:todo_list_riverpod/views/widgets/item_list_friend.dart';

class ListFriend extends ConsumerStatefulWidget {
  const ListFriend({super.key});

  @override
  ConsumerState<ListFriend> createState() => _ListFriendState();
}

class _ListFriendState extends ConsumerState<ListFriend> {
  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(friendViewModelProvider).fetchFriends(user!.id ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    final listFriend = ref.watch(listFriendProvider);
    if (listFriend.isEmpty) {
      return const Center(
        child: Text(
          'You don\'t have any friends yet! =)))))',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: listFriend.length,
      itemBuilder: (context, index) {
        final friend = listFriend[index];
        return ItemListFriend(
          friend: friend,
          onTap: (friend) {
            ref.read(friendProvider.notifier).state = friend;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Chat()),
            );
          },
        );
      },
    );
  }
}
