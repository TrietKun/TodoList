import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/models/friend.dart';
import 'package:todo_list_riverpod/providers/auth_provider.dart';
import 'package:todo_list_riverpod/providers/friend_provider.dart';
import 'package:todo_list_riverpod/views/widgets/badge_message.dart';

class ItemListFriend extends ConsumerStatefulWidget {
  const ItemListFriend({
    super.key,
    required this.friend,
    required this.onTap,
  });

  final Friend friend;
  final Function(Friend friend) onTap;

  @override
  ConsumerState<ItemListFriend> createState() => _ItemListFriendState();
}

class _ItemListFriendState extends ConsumerState<ItemListFriend> {
  var unreadMessages = 3;
  @override
  Widget build(BuildContext context) {
    final friendViewModel = ref.watch(friendViewModelProvider);
    final user = ref.watch(userProvider);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white30,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              widget.onTap(widget.friend);
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(
                  widget.friend.name.toUpperCase().substring(0, 1),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                widget.friend.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        widget.friend.status == "online"
                            ? Icons.circle
                            : Icons.circle_outlined,
                        color: widget.friend.status == "online"
                            ? Colors.green
                            : Colors.grey,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.friend.status == "online" ? "Online" : "Offline",
                        style: TextStyle(
                          color: widget.friend.status == "online"
                              ? Colors.green
                              : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: unreadMessages > 0
                  ? BadgeMessage(
                      count: unreadMessages,
                    )
                  : null,
            ),
          ),
          friendViewModel.renderFriendStatus(
              context,
              widget.friend.conversation.conversationStatus,
              user!.id ?? "",
              widget.friend.id),
        ],
      ),
    );
  }
}
