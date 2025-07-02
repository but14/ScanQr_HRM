import 'package:flutter/material.dart';
import 'package:mobile/screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Sóng xanh phía trên
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 250,
              color: Colors.blue,
            ),
          ),
          // Nội dung đăng nhập
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  const Text(
                    'Đăng nhập',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      letterSpacing: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),
                  // Email
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.email_outlined, color: Colors.blue),
                      labelText: 'Tài khoản truy cập',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Password
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.vpn_key_outlined, color: Colors.blue),
                      labelText: 'Mật khẩu',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 36),
                  // Nút Login
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ));
                      },
                      child: const Text(
                        'ĐĂNG NHẬP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Forget Password
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: TextButton(
                  //     onPressed: () {
                  //       // Xử lý quên mật khẩu
                  //     },
                  //     child: const Text(
                  //       'Quên mật khẩu?',
                  //       style: TextStyle(color: Colors.blue),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 12, bottom: 8),
              child: Text(
                '© Khối CNTT & Chuyển đổi số 1.0',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom clipper cho sóng xanh
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 60);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
