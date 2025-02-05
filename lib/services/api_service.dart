import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "http://192.168.100.235:3000/api/"),
  );

  Future<Response> get(String path) async => await _dio.get(path);
  Future<Response> post(String path, Map<String, dynamic> data) async =>
      await _dio.post(path, data: data);
  Future<Response> put(String path, Map<String, dynamic> data) async =>
      await _dio.put(path, data: data);
  Future<Response> delete(String path, String token) async => await _dio
      .delete(path, options: Options(headers: {'Authorization': token}));
}
