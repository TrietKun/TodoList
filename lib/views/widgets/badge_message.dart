import 'package:flutter/material.dart';

class BadgeMessage extends StatelessWidget {
  const BadgeMessage({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.0,
      height: 30.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.red,
        // Tạo hình tròn
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Text(
        count > 99 ? "99+" : "$count", // Hiển thị "99+" nếu tin nhắn > 99
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
