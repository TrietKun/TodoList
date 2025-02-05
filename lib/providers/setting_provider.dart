import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/providers/user_provider.dart';
import 'package:todo_list_riverpod/repositories/upload_repository.dart';
import 'package:todo_list_riverpod/services/upload_image_api.dart';
import 'package:todo_list_riverpod/viewmodels/setting_viewmodel.dart';

final uploadImageApiProvider = Provider<UploadImageApi>((ref) {
  return UploadImageApi();
});

final uploadrepositoryProvider = Provider<UploadRepository>((ref) {
  return UploadRepository(ref.read(uploadImageApiProvider));
});

final settingViewModelProvider =
    StateNotifierProvider<SettingViewModel, bool>((ref) {
  return SettingViewModel(ref, ref.read(uploadrepositoryProvider), ref.read(userRepositoryProvider));
});
