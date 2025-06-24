import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Xử lý đăng nhập ở đây
          },
          child: const Text('Đăng nhập'),
        ),
      ),
    );
  }
}