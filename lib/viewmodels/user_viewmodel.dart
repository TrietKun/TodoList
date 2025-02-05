import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/providers/user_provider.dart';
import 'package:todo_list_riverpod/repositories/user_repository.dart';
import 'package:todo_list_riverpod/views/widgets/modal_search_friend.dart';

class UserViewmodel {
  final UserRepository _userRepository;
  final Ref ref;
  bool isFetched = false;
  final TextEditingController emailController = TextEditingController();

  UserViewmodel(this._userRepository, this.ref);

  Future<void> fetchUsers() async {
    try {
      if (!isFetched) {
        await _userRepository.getAllUser().then((value) => {
              ref.read(listUserProvider.notifier).state = value,
              isFetched = true,
            });
        isFetched = true;
      }
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  Future<void> searchUserByEmail(String email) async {
    try {
      await _userRepository.getUserByEmail(email).then((value) => {
            print("User found: ${value}"),
            emailController.text = '',
            ref.read(userSearchProvider.notifier).state = value,
          });
    } on Exception {
      print("User not found");
      ref.read(userSearchProvider.notifier).state = null;
    } catch (e) {
      print("Error fetching user by email: $e");
    }
  }

  void openModelSearchFriend(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ModalSearchFriend(
          emailController: emailController,
          searchUserByEmail: searchUserByEmail,
        ),
      ),
    );
  }
}
