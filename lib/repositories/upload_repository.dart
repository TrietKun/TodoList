import 'dart:io';

import 'package:todo_list_riverpod/services/upload_image_api.dart';

class UploadRepository {
  final UploadImageApi _uploadImageApi;
  UploadRepository(this._uploadImageApi);
  Future<String?> uploadImage(File file) async {
    return await _uploadImageApi.uploadImage(file);
  }
}