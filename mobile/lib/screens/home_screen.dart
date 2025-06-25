import 'package:flutter/material.dart';
import 'package:mobile/screens/qr_scan_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Sóng xanh phía trên
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 220,
              color: Colors.blue,
            ),
          ),
          // Nội dung trang chủ
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 32),
                // Icon QR và tên hệ thống
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.qr_code_2_rounded, size: 40, color: Colors.blue),
                    SizedBox(width: 12),
                    Text(
                      'Quét QR nhân sự',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Các nút chức năng
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Nút quét QR
                        SizedBox(
                          width: 220,
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 2,
                            ),
                            icon: const Icon(Icons.qr_code_scanner,
                                color: Colors.white),
                            label: const Text(
                              'Quét mã QR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                letterSpacing: 1.1,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const QRScanScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Nút xem lịch sử quét
                        SizedBox(
                          width: 220,
                          height: 50,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              side: const BorderSide(color: Colors.blue),
                            ),
                            icon: const Icon(Icons.history, color: Colors.blue),
                            label: const Text(
                              'Lịch sử quét',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                letterSpacing: 1.1,
                              ),
                            ),
                            onPressed: () {
                              // TODO: Điều hướng tới màn hình lịch sử quét
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom clipper cho sóng xanh (dùng chung với splash/login)
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
