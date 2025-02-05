import 'package:todo_list_riverpod/models/user.dart';
import 'package:todo_list_riverpod/services/api_service.dart';

class UserApi extends ApiService {
  Future<List<User>> getAllUser() async {
    final response = await get('users');
    return (response.data as List).map((e) => User.fromJson(e)).toList();
  }
  Future<User> getUserByEmail(String email) async {
    final response = await get('users/getUserByEmail/$email');
    return User.fromJson(response.data);
  }
  Future<User> updateAvatar(String id, String avatar) async {
    final response = await put('users/updateAvatar/$id', {'avatar': avatar});
    return User.fromJson(response.data);
  }
}