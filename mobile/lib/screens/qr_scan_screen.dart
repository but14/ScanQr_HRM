// main.dart (hoặc QRScanScreen.dart)
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'manual_add_screen.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  final TextRecognizer _textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    requestPermissions().then((_) => _initializeCamera());
  }

  Future<void> requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final storageStatus = await Permission.storage.request();
    if (cameraStatus.isDenied || storageStatus.isDenied) {
      _showResultDialog(
          '❌ Bạn cần cấp quyền CAMERA và STORAGE để sử dụng tính năng này.');
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController =
        CameraController(backCamera, ResolutionPreset.high, enableAudio: false);
    await _cameraController.initialize();
    setState(() => _isCameraInitialized = true);
  }

  Future<void> _captureAndProcessImage() async {
    try {
      final directory = await getTemporaryDirectory();
      final path = p.join(directory.path, '${DateTime.now()}.jpg');
      final imageFile = await _cameraController.takePicture();
      final savedImage = await File(imageFile.path).copy(path);
      final inputImage = InputImage.fromFile(savedImage);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      final data = _parseOCRData(recognizedText.text);
      if (!mounted) return;
      if (data.containsKey('error')) {
        _showResultDialog('❌ ${data['error']}');
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ManualAddScreen(ocrData: data),
            ));
      }
    } catch (e) {
      _showResultDialog('❌ Lỗi xử lý ảnh: $e');
    }
  }

  Map<String, String> _parseOCRData(String rawText) {
    try {
      final data = <String, String>{};
      final lines = rawText.split('\n').map((line) => line.trim()).toList();
      final cccdRegex = RegExp(r'\b\d{12}\b');
      final dateRegex = RegExp(r'\b\d{2}/\d{2}/\d{4}\b');
      final genderRegex =
          RegExp(r'\b(Nam|Nữ|Male|Female)\b', caseSensitive: false);
      final nationalityRegex =
          RegExp(r'Việt Nam|Vietnam', caseSensitive: false);

      for (final line in lines) {
        debugPrint('OCR Line: $line');
      }

      for (final line in lines) {
        final match = cccdRegex.firstMatch(line);
        if (match != null) {
          data['id_number'] = match.group(0)!;
          break;
        }
      }

      for (int i = 0; i < lines.length; i++) {
        final line = lines[i];
        final lower = line.toLowerCase();

        if (lower.contains('full name') && i + 1 < lines.length) {
          data['full_name'] = lines[i + 1];
        }

        if (lower.contains('date of birth')) {
          if (i + 1 < lines.length && dateRegex.hasMatch(lines[i + 1])) {
            data['date_of_birth'] =
                dateRegex.firstMatch(lines[i + 1])!.group(0)!;
          } else if (dateRegex.hasMatch(line)) {
            data['date_of_birth'] = dateRegex.firstMatch(line)!.group(0)!;
          }
        }

        if (lower.contains('sex')) {
          final match = genderRegex.firstMatch(line);
          if (match != null) {
            data['gender'] = match.group(0)!;
          }
        }

        if (lower.contains('nationality')) {
          final match = nationalityRegex.firstMatch(line);
          if (match != null) {
            data['nationality'] = match.group(0)!;
          } else if (i + 1 < lines.length) {
            final nextMatch = nationalityRegex.firstMatch(lines[i + 1]);
            if (nextMatch != null) {
              data['nationality'] = nextMatch.group(0)!;
            }
          }
        }

        if (lower.contains('place of origin') && i + 1 < lines.length) {
          data['place_of_origin'] = lines[i + 1];
        }

        if (lower.contains('place of residence') && i + 1 < lines.length) {
          data['place_of_residence'] = lines[i + 1];
        }
      }

      data.putIfAbsent('nationality', () => 'Việt Nam');

      final requiredFields = [
        'id_number',
        'full_name',
        'date_of_birth',
        'gender',
        'place_of_origin',
        'place_of_residence',
      ];

      for (final field in requiredFields) {
        if (data[field] == null || data[field]!.isEmpty) {
          return {'error': 'Thiếu thông tin: $field'};
        }
      }

      return data;
    } catch (e) {
      return {'error': 'Lỗi phân tích dữ liệu OCR: $e'};
    }
  }

  void _showResultDialog(String result) {
    if (!mounted) return;
    BuildContext ctx = this.context;
    showDialog(
      context: ctx,
      builder: (context) => AlertDialog(
        title: const Text('Kết quả OCR'),
        content: Text(result),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chụp CCCD & OCR')),
      body: _isCameraInitialized
          ? Stack(
              children: [
                CameraPreview(_cameraController),
                Container(color: Colors.black.withOpacity(0.3)),
                Align(
                  alignment: Alignment.center,
                  child: AspectRatio(
                    aspectRatio: 86 / 54,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.greenAccent, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: _captureAndProcessImage,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Chụp & Nhận dạng'),
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
