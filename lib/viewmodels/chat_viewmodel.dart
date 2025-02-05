import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/providers/auth_provider.dart';
import 'package:todo_list_riverpod/providers/friend_provider.dart';
import 'package:todo_list_riverpod/repositories/friend_repository.dart';
import 'package:todo_list_riverpod/viewmodels/friend_viewmodel.dart';

class ChatViewmodel extends FriendViewmodel {
  ChatViewmodel(this.ref, this._repository) : super(_repository, ref);
  final FriendRepository _repository;
  final Ref ref;

  Widget renderConversationStatus(
      BuildContext context, String status, String userId, String friendId) {
    switch (status) {
      case 'pending':
        return Text(
          'Friend request sent',
          style: TextStyle(color: Colors.brown[400]),
        );
      case 'blocked':
        return const Text(
          'You have been blocked',
          style: TextStyle(color: Colors.red),
        );
      case 'block':
        return const Text(
          'You have blocked this user',
          style: TextStyle(color: Colors.red),
        );
      case 'requested':
        return Row(
          children: [
            Text(
              'Not friends yet, be friends now',
              style: TextStyle(color: Colors.brown[400]),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[400],
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                onTap: () {
                  _repository.acceptFriend(
                    ref.read(userProvider)!.id ?? '',
                    ref.read(friendProvider)!.id,
                  );
                },
                child: const Row(
                  children: [
                    Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      case 'unfriend':
        return Row(
          children: [
            Text(
              'You are not friends yet',
              style: TextStyle(color: Colors.brown[400]),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[400],
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                onTap: () {
                  addFriend(context, userId, friendId);
                },
                child: const Row(
                  children: [
                    Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }
}
