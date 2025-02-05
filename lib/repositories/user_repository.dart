import 'package:todo_list_riverpod/models/user.dart';
import 'package:todo_list_riverpod/services/api_service.dart';

class UserRepository {
  final ApiService _apiService;
  UserRepository(this._apiService);

  Future<List<User>> getAllUser() async {
    final response = await _apiService.get('users');
    return (response.data as List).map((e) => User.fromJson(e)).toList();
  }

  Future<User> getUserByEmail(String email) async {
    final response = await _apiService.get('users/getUserByEmail/$email');
    return User.fromJson(response.data);
  }

  Future<User> updateAvatar(String id, String avatar) async {
    print('id: $id, avatar: $avatar');
    final response =
        await _apiService.put('users/updateAvatar/$id', {'avatar': avatar});
    return User.fromJson(response.data);
  }
}
