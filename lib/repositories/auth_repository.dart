import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:todo_list_riverpod/models/user.dart';
import 'package:todo_list_riverpod/providers/auth_provider.dart';
import 'package:todo_list_riverpod/services/auth_api.dart';

// Define a global variable to store the user

class AuthRepository {
  final authApi = AuthApi();
  User? user;

  Future<User> signInWithEmailAndPassword(
      String email, String password,String fcmToken, Ref ref) async {
    try {
      final response = await authApi.login(email, password, fcmToken);

      Map<String, dynamic> decodedToken =
          JwtDecoder.decode(response['accessToken']);
      //lưu access token
      ref.read(accessTokenProvider.notifier).state = response['accessToken'];
      //lưu refresh token
      ref.read(refreshTokenProvider.notifier).state = response['refreshToken'];

      user = User.fromJson(decodedToken['user']);
      return user!;
    } on DioException catch (e) {
      return Future.error(e.response!.data['message']);
    } catch (e) {
      print(e);
      //return lỗi
      return Future.error(e);
    }
  }

  Future<User> signUp(
      String name, String email, String password, Ref ref) async {
    try {
      final value = await authApi.register(name, email, password);
      Map<String, dynamic> decodedToken =
          JwtDecoder.decode(value['accessToken']);
      ref.read(accessTokenProvider.notifier).state = value['accessToken'];
      ref.read(refreshTokenProvider.notifier).state = value['refreshToken'];
      user = User.fromJson(decodedToken['user']);
      return user!;
    } on DioException catch (e) {
      return Future.error(e.response!.data['message']);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> signOut(String email) async {
    try {
      await authApi.logout(email).then((value) {
        print(value);
      });
    } catch (e) {
      print(e);
    }
  }
}
