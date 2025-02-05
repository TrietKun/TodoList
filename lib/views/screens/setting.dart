import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/providers/auth_provider.dart';
import 'package:todo_list_riverpod/providers/setting_provider.dart';

class Setting extends ConsumerStatefulWidget {
  const Setting({super.key});

  @override
  ConsumerState<Setting> createState() => _SettingState();
}

class _SettingState extends ConsumerState<Setting> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final loginViewModel = ref.read(loginViewModelProvider);
    final settingViewModel = ref.read(settingViewModelProvider.notifier);

    if (_nameController.text.isEmpty && user != null) {
      _nameController.text = user.name ?? ''; // Hiển thị tên người dùng nếu có
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        backgroundColor: Colors.brown[400], // Màu sắc bắt mắt
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(user!.avatar ?? ''),
                ),
              ),
              // nút thay đổi avatar
              Container(
                decoration: BoxDecoration(
                  color: Colors.brown[400],
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                      style: BorderStyle.solid),
                ),
                width: double.infinity,
                height: 60,
                child: Center(
                  child: InkWell(
                    onTap: () {
                      settingViewModel.openGallery(context);
                    },
                    child: const Text(
                      'Change Avatar',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.brown[400],
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                      style: BorderStyle.solid),
                ),
                width: double.infinity,
                height: 60,
                child: Center(
                  child: InkWell(
                    onTap: () {
                      if (user.email != null) {
                        loginViewModel.signOut(context, user.email!);
                      }
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
