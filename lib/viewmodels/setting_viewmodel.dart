import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:todo_list_riverpod/providers/auth_provider.dart';
import 'package:todo_list_riverpod/repositories/upload_repository.dart';
import 'package:todo_list_riverpod/repositories/user_repository.dart';

class SettingViewModel extends StateNotifier<bool> {
  final Ref ref;
  final picker = ImagePicker();
  final UploadRepository uploadRepository;
  final UserRepository userRepository;
  bool isLoading = false;

  SettingViewModel(this.ref, this.uploadRepository, this.userRepository)
      : super(false);

  // Mở thư viện ảnh và upload lên Cloudinary
  void openGallery(BuildContext context) async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      showDialog(
        context: context,
        barrierDismissible: false, // Không cho phép đóng hộp thoại khi tải
        builder: (context) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: LoadingAnimationWidget.inkDrop(
                color: Colors.brown[400] ?? Colors.brown,
                size: 50,
              ),
            ),
          );
        },
      );
      if (image != null) {
        String? uploadedUrl = await uploadToCloudinary(File(image.path));
        if (uploadedUrl != null) {
          print("Upload ảnh thành công: $uploadedUrl");
          updateUserInfo(uploadedUrl);
        }
      }
    } catch (e) {
      print("Lỗi chọn ảnh: $e");
    } finally {
      isLoading = false;
      Navigator.of(context).pop();
    }
  }

  // Hàm upload ảnh lên Cloudinary
  Future<String?> uploadToCloudinary(File file) async {
    try {
      return await uploadRepository.uploadImage(file);
    } catch (e) {
      print("Lỗi upload ảnh: $e");
      return null;
    }
  }

  // Cập nhật thông tin người dùng
  void updateUserInfo(String avatar) {
    try {
      var currentUser = ref.read(userProvider);
      userRepository.updateAvatar(currentUser!.id!, avatar);

      ref.read(userProvider.notifier).state =
          currentUser.copyWith(avatar: avatar);
    } catch (e) {
      print("Lỗi cập nhật avatar: $e");
    }
  }
}
