import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/providers/friend_provider.dart';
import 'package:todo_list_riverpod/repositories/friend_repository.dart';
import 'package:todo_list_riverpod/views/widgets/model_notify.dart';

class FriendViewmodel {
  final FriendRepository _repository;
  final Ref ref;

  FriendViewmodel(this._repository, this.ref);

  Future<void> fetchFriends(String id) async {
    try {
      await _repository.getAllFriendByUserId(id).then((value) => {
            ref.read(listFriendProvider.notifier).state = value,
          });
    } catch (e) {
      print("Error fetching friends: $e");
    }
  }

  Future<void> addFriend(BuildContext context, userId, String friendId) async {
    try {
      await _repository.addFriend(userId, friendId).then((value) {
        final currentList = ref.read(listFriendProvider);
        ref.read(friendProvider.notifier).state = value;
        if (currentList.any((element) =>
            element.conversation.participants.contains(friendId))) {
          final updatedList = currentList.map((element) {
            if (element.conversation.participants.contains(friendId)) {
              element.conversation.conversationStatus = 'pending';
            }
            return element;
          }).toList();
          ref.read(listFriendProvider.notifier).state = updatedList;
        } else {
          ref.read(listFriendProvider.notifier).state = [
            ...currentList,
            value,
          ];
        }
        showDialog(
            context: context,
            builder: (context) {
              return const ModelNotify(
                title: 'Request Sent',
                message: 'Your friend request has been sent',
                type: 'success',
              );
            });
      });
    } on DioException catch (e) {
      print("Error adding friend: $e");
    } catch (e) {
      print("Error adding friend: $e");
    }
  }

  Future<void> acceptFriend(String userId, String friendId) async {
    try {
      await _repository.acceptFriend(userId, friendId).then((value) {
        print('value accept friend: $value');
        final currentList = ref.read(listFriendProvider);

        final updatedList = currentList.map((element) {
          if (element.conversation.participants.contains(friendId)) {
            element.conversation.conversationStatus = 'friend';
          }
          return element;
        }).toList();

        ref.read(listFriendProvider.notifier).state = updatedList;
      });
    } on DioException catch (e) {
      print("Error accepting friend: $e");
    } catch (e) {
      print("Error accepting friend: $e");
    }
  }

  Future<void> unfriend(
      BuildContext context, userId, String friendId, String type) async {
    print('type: $type');
    try {
      await _repository.unfriend(userId, friendId).then((value) {
        final currentList = ref.read(listFriendProvider);
        ref.read(friendProvider.notifier).state = value;

        final updatedList = currentList.map((element) {
          if (element.conversation.participants.contains(friendId)) {
            element.conversation.conversationStatus = 'unfriend';
          }
          return element;
        }).toList();

        ref.read(listFriendProvider.notifier).state = updatedList;
        showDialog(
            context: context,
            builder: (context) {
              return ModelNotify(
                title: 'Unfriended',
                message: 'You have unfriended this user',
                type: type,
              );
            });
      });
    } on DioException catch (e) {
      print("Error unfriending: $e");
    } catch (e) {
      print("Error unfriending: $e");
    }
  }

  Future<void> blockFriend(String userId, String friendId) async {
    try {
      await _repository.blockFriend(userId, friendId).then((value) {
        final currentList = ref.read(listFriendProvider);

        final updatedList = currentList.map((element) {
          if (element.conversation.participants.contains(friendId)) {
            element.conversation.conversationStatus = 'block';
          }
          return element;
        }).toList();

        ref.read(listFriendProvider.notifier).state = updatedList;
        ref.read(friendProvider.notifier).state = value;
      });
    } on DioException catch (e) {
      print("Error blocking friend: $e");
    } catch (e) {
      print("Error blocking friend: $e");
    }
  }

  Future<void> unBlockFriend(String userId, String friendId) async {
    try {
      await _repository.unblockFriend(userId, friendId).then((value) {
        final currentList = ref.read(listFriendProvider);

        final updatedList = currentList.map((element) {
          if (element.conversation.participants.contains(friendId)) {
            element.conversation.conversationStatus = 'unfriend';
          }
          return element;
        }).toList();

        ref.read(listFriendProvider.notifier).state = updatedList;
        ref.read(friendProvider.notifier).state = value;
      });
    } on DioException catch (e) {
      print("Error unblocking friend: $e");
    } catch (e) {
      print("Error unblocking friend: $e");
    }
  }

  Widget renderFriendStatus(
      BuildContext context, String status, String userId, String friendId) {
    print('status: $status userId: $userId friendId: $friendId');
    switch (status) {
      case 'blocked':
        return const Text(
          'You have been blocked',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        );
      case 'block':
        return const Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    'You have blocked this user',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.block,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        );
      case 'requested':
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[400],
                  ),
                  onPressed: () {
                    acceptFriend(userId, friendId);
                  },
                  child: const Text(
                    'Accept',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[300],
                  ),
                  onPressed: () {
                    unfriend(context, userId, friendId, 'decline');
                  },
                  child: const Text('Decline',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ),
          ],
        );
      case 'pending':
        return Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[300],
                  ),
                  onPressed: () {
                    unfriend(context, userId, friendId, 'cancel');
                  },
                  child: const Text('Cancel Request',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
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

Widget renderBlockButton(BuildContext context, String status, String userId,
    String friendId, FriendViewmodel friendViewModel) {
  switch (status) {
    case 'blocked':
      return const SizedBox();
    case 'block':
      return ElevatedButton(
        onPressed: () {
          friendViewModel.unBlockFriend(userId, friendId);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[400],
          minimumSize: const Size(200, 40),
        ),
        child: const Text(
          'Unblock',
          style: TextStyle(color: Colors.white),
        ),
      );
    default:
      return ElevatedButton(
        onPressed: () {
          friendViewModel.blockFriend(userId, friendId);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[400],
          minimumSize: const Size(200, 40),
        ),
        child: const Text(
          'Block',
          style: TextStyle(color: Colors.white),
        ),
      );
  }
}
