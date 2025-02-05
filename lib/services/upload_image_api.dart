import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:todo_list_riverpod/services/api_service.dart';

class UploadImageApi extends ApiService {
  Future<String?> uploadImage(File file) async {
    try {
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(file.path,
            filename: file.path.split('/').last),
      });

      Response response = await Dio().post(
          "${dotenv.env['BASE_URL']!}/upload/uploadImage",
          data: formData);
      if (response.statusCode == 200) {
        print("Upload success: ${response.data}");
        return response.data["url"];
      } else {
        print("Upload failed: ${response.data}");
        return null;
      }
    } catch (e) {
      print("Upload image error: $e");
      return null;
    }
  }
}
