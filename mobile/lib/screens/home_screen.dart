import 'package:flutter/material.dart';
import 'package:mobile/screens/history_screen.dart';
import 'package:mobile/screens/manual_add_screen.dart';
import 'package:mobile/screens/qr_scan_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String managerName = '...';

  @override
  void initState() {
    super.initState();
    _loadManagerName();
  }

  Future<void> _loadManagerName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      managerName = prefs.getString('managerName') ?? 'Người dùng';
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
              height: 220,
              color: Colors.blue,
              child: const Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Nhân sự',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          blurRadius: 2,
                          color: Colors.black26,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),

          // Nội dung trang chủ
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.qr_code_2_rounded, size: 40, color: Colors.blue),
                    SizedBox(width: 12),
                    Text(
                      'Nhân sự',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 18, color: Colors.black54),
                    const SizedBox(width: 6),
                    Text(
                      'Hôm nay: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 62),
                Text(
                  'Xin chào, $managerName',
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 50),

                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.4,
                    children: [
                      _HomeCardButton(
                        icon: Icons.qr_code_scanner,
                        label: 'Thêm nhanh',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QRScanScreen(),
                            ),
                          );
                        },
                        color: Colors.blue.shade700,
                      ),
                      _HomeCardButton(
                        icon: Icons.history,
                        label: 'Lịch sử',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HistoryScreen(),
                            ),
                          );
                        },
                        color: Colors.blue.shade800,
                      ),
                      _HomeCardButton(
                        icon: Icons.person_add_alt_1,
                        label: 'Thêm thủ công',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ManualAddScreen(),
                            ),
                          );
                        },
                        color: Colors.deepPurple.shade400,
                      ),
                      _HomeCardButton(
                        icon: Icons.camera_alt,
                        label: 'Chụp hình',
                        onTap: () {
                          // TODO: Xử lý chức năng chụp hình
                        },
                        color: Colors.teal.shade400,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),

          // Footer
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

class _HomeCardButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _HomeCardButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(18),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: SizedBox(
          height: 110,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 36),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
