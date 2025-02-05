import 'package:todo_list_riverpod/services/api_service.dart';

class AuthApi extends ApiService {
  Future<Map<String, dynamic>> login(String email, String password, String fcmToken) async {
    final response = await post('auth/login', {
      'email': email,
      'password': password,
      'FCMToken': fcmToken,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    final response = await post('auth/register', {
      'name': name,
      'email': email,
      'password': password,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await post('auth/refresh-token', {
      'refreshToken': refreshToken,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> logout(String email) async {
    final response = await post('auth/logout', {
      'email': email,
    });
    return response.data;
  }
}
