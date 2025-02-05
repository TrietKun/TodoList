# Todo List Riverpod

## Giới thiệu

**Todo List Riverpod** là một ứng dụng Flutter giúp người dùng quản lý công việc hằng ngày. Ứng dụng sử dụng Riverpod để quản lý trạng thái, Firebase để thông báo và Cloudinary để lưu trữ hình ảnh. Ngoài ra, WebSocket được sử dụng để cập nhật trạng thái công việc theo thời gian thực.

## Công nghệ sử dụng

- **Flutter**: Framework chính để xây dựng ứng dụng di động.
- **Riverpod**: Quản lý trạng thái hiệu quả và linh hoạt.
- **Firebase**: Dịch vụ để đẩy thông báo
- **Cloudinary**: Lưu trữ và tối ưu hóa hình ảnh.
- **WebSocket**: Cập nhật dữ liệu theo thời gian thực.

## Cài đặt và chạy dự án

### Yêu cầu hệ thống
- Flutter phiên bản mới nhất.
- Dart SDK.
- Android Studio/Xcode (tuỳ hệ điều hành).

### Cách tải về và cài đặt

1. Clone repository:
   ```sh
   git clone https://github.com/your_username/todo_list_riverpod.git
   cd todo_list_riverpod
   ```

2. Cài đặt các dependencies:
   ```sh
   flutter pub get
   ```

3. Cấu hình Firebase:
   - Thêm tệp cấu hình `google-services.json` vào `android/app/`.
   - Thêm `GoogleService-Info.plist` vào `ios/Runner/`.

4. Chạy ứng dụng:
   ```sh
   flutter run
   ```



## Các màn hình trong ứng dụng

| Màn hình | Hình ảnh |
|----------|------------------------------------------------|
| **Màn hình đăng nhập** | <img src="https://github.com/user-attachments/assets/cb4e8ed2-178f-4191-867b-8b8e925e3177" width="200">  |
| **Màn hình danh sách công việc** | <img src="https://github.com/user-attachments/assets/0a231372-24da-4681-bb74-cbfabeeba1dd" width="200"> |
| **Màn hình danh sách bạn bè** | <img src="https://github.com/user-attachments/assets/7589d3cc-4d6d-4c92-a196-1816ee8ce068" width="200"> |
| **Màn hình của quản lí ( chỉ dành cho role admin )** | <img src="https://github.com/user-attachments/assets/6f55f281-4dfd-40d6-a3e9-51c68859ae31" width="200">|
| **Màn hình cài đặt** | <img src="https://github.com/user-attachments/assets/07d2c52a-f9b0-4b22-b4f6-86d69eb32b2b" width="200"> |
| **Màn hình danh sách thông báo** | <img src="https://github.com/user-attachments/assets/8f7baa6d-fa00-4a21-b733-93ebe08d819b" width="200"> |
| **Màn hình tìm bạn bè** | <img src="https://github.com/user-attachments/assets/63a3fa63-75d1-48bb-bd78-e3655d109ce7" width="200"> |
| **Màn hình chức năng chat** | <img src="https://github.com/user-attachments/assets/7be6c73d-a745-466a-a7ab-185903fcc30a" width="200">|

---

## Đóng góp
Mọi ý kiến đóng góp hoặc báo lỗi xin vui lòng mở một issue hoặc gửi pull request trên GitHub.

## License
Dự án này sử dụng giấy phép [MIT](https://opensource.org/licenses/MIT).
