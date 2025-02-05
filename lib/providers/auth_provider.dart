import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_riverpod/models/user.dart';
import 'package:todo_list_riverpod/repositories/auth_repository.dart';
import 'package:todo_list_riverpod/viewmodels/auth_viewmodel.dart';

final accessTokenProvider = StateProvider<String>((ref) => ''); // Khởi tạo với giá trị rỗng

var refreshTokenProvider = StateProvider<String>((ref) => ''); // Lưu trữ token

final userProvider = StateProvider<User?>((ref) => null); // Lưu trữ user

final loadingProvider = StateProvider<bool>((ref) => false); // Lưu trữ trạng thái loading

final errorProvider = StateProvider<String?>((ref) => null); // Lưu trữ lỗi

final AuthRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
}); // Provider cho AuthRepository

final loginViewModelProvider = Provider((ref) {
  final authRepository = ref.read(AuthRepositoryProvider);
  return LoginViewModel(authRepository, ref);
}); // Provider cho LoginViewModel