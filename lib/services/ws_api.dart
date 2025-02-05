import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WsApi {
  late WebSocketChannel _channel;
  String baseUrl = "ws://192.168.100.235:8080";

  /// Kết nối đến WebSocket
  void connect(String userId) {
    _channel = WebSocketChannel.connect(
      Uri.parse('$baseUrl?userId=$userId'),
    );
  }

  /// Gửi tin nhắn qua WebSocket
  void sendMessage(String message) {
    _channel.sink.add(message);
  }

  /// Lắng nghe tin nhắn từ WebSocket
  void listen(void Function(dynamic message) onMessage) {
    _channel.stream.listen(
      onMessage,
      onError: (error) => print("WebSocket error: $error"),
      onDone: () => print("WebSocket connection closed."),
    );
  }

  /// Đóng kết nối WebSocket
  void disconnect() {
    _channel.sink.close(status.normalClosure);
  }
}
