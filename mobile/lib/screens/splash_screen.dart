import 'package:flutter/material.dart';
import 'dart:async';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Sóng xanh phía trên
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 300,
              color: Colors.blue,
            ),
          ),
          // Nội dung splash
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon QR code
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.qr_code_2_rounded,
                    size: 72,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'ScanQR Căn cước công dân',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 12),
                // const Text(
                //   'Hệ thống quản lý nhân sự bằng mã QR',
                //   style: TextStyle(
                //     fontSize: 16,
                //     color: Colors.black54,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                // const Text(
                //   'CÔNG TY CỔ PHẦN I GROUP',
                //   style: TextStyle(
                //     fontSize: 24,
                //     fontWeight: FontWeight.bold,
                //     color: Color.fromARGB(137, 21, 0, 255),
                //   ),
                //   textAlign: TextAlign.center,
                // ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 12, bottom: 8),
              child: Text(
                '© Khối CNTT & Chuyển đổi số',
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

// Custom clipper cho sóng xanh (dùng chung với login)
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
