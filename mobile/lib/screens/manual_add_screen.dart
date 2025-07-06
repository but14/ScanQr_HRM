import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/screens/home_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';

class ManualAddScreen extends StatefulWidget {
  final Map<String, String> ocrData;

  const ManualAddScreen({super.key, this.ocrData = const {}});

  @override
  State<ManualAddScreen> createState() => _ManualAddScreenState();
}

class _ManualAddScreenState extends State<ManualAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController idNumberController = TextEditingController();
  final TextEditingController dateOfIssueController = TextEditingController();
  final TextEditingController placeOfOriginController = TextEditingController();
  final TextEditingController placeOfResidenceController =
      TextEditingController();
  final TextEditingController scanNotesController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  String managerIdFromToken = '';
  String selectedGender = 'Nam';

  @override
  void initState() {
    super.initState();
    _loadManagerIdFromPrefs();

    final ocrData = widget.ocrData;
    nameController.text = ocrData['full_name'] ?? '';
    dobController.text = ocrData['date_of_birth'] ?? '';
    genderController.text = ocrData['gender'] ?? 'Nam';
    nationalityController.text = ocrData['nationality'] ?? 'Việt Nam';
    idNumberController.text = ocrData['id_number'] ?? '';
    placeOfOriginController.text = ocrData['place_of_origin'] ?? '';
    placeOfResidenceController.text = ocrData['place_of_residence'] ?? '';
  }

  Future<void> _loadManagerIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final managerId = prefs.getString('managerId'); // 👈 Đọc lại từ storage

    setState(() {
      managerIdFromToken = managerId ?? '';
      print('✅ Manager ID từ SharedPreferences: $managerIdFromToken');
    });
  }

  String formatDate(String date) {
    try {
      final inputFormat = DateFormat('dd/MM/yyyy');
      final outputFormat = DateFormat('yyyy-MM-dd');
      final dateTime = inputFormat.parse(date);
      return outputFormat.format(dateTime);
    } catch (e) {
      print("Lỗi khi chuyển đổi ngày: $e");
      return date;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, String> formData = {
        'full_name': nameController.text,
        'date_of_birth': formatDate(dobController.text),
        'gender': selectedGender,
        'nationality': nationalityController.text,
        'id_number': idNumberController.text,
        'date_of_issue': dateOfIssueController.text,
        'place_of_origin': placeOfOriginController.text,
        'place_of_residence': placeOfResidenceController.text,
        'phone_number': phoneNumberController.text,
        'manager_id': managerIdFromToken,
        'scan_notes': scanNotesController.text,
      };

      print('Form data: $formData');

      try {
        final response = await http.post(
          Uri.parse('https://corehr.igroup.com.vn/api/scan/scan-cccd'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(formData),
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Thành công'),
                content: const Text('Thông tin đã được lưu thành công!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          throw Exception('Lỗi: ${response.body}');
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã có lỗi xảy ra: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm nhân sự'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(nameController, 'Họ và tên', Icons.person),
              _buildDateField(dobController, 'Ngày sinh', Icons.cake),
              _buildGenderField(),
              _buildTextField(nationalityController, 'Quốc tịch', Icons.flag),
              _buildTextField(
                  idNumberController, 'Số CCCD/Mã nhân sự', Icons.badge),
              _buildTextField(
                  placeOfOriginController, 'Nguyên quán', Icons.home),
              _buildTextField(placeOfResidenceController, 'Nơi thường trú',
                  Icons.location_city),
              _buildTextField(phoneNumberController,
                  'Số điện thoại (không bắt buộc)', Icons.phone,
                  required: false),
              // ✅ Đã ẩn input Mã quản lý
              const SizedBox(height: 28),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Lưu thông tin'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool required = true, bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: required
            ? (value) => value == null || value.isEmpty ? 'Nhập $label' : null
            : null,
      ),
    );
  }

  Widget _buildDateField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            controller.text =
                "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
          }
        },
        validator: (value) =>
            value == null || value.isEmpty ? 'Nhập $label' : null,
      ),
    );
  }

  Widget _buildGenderField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        decoration: const InputDecoration(
          labelText: 'Giới tính',
          prefixIcon: Icon(Icons.wc),
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {
            selectedGender = value!;
          });
        },
        items: ['Nam', 'Nữ']
            .map((gender) => DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                ))
            .toList(),
        validator: (value) =>
            value == null || value.isEmpty ? 'Chọn giới tính' : null,
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    genderController.dispose();
    nationalityController.dispose();
    idNumberController.dispose();
    dateOfIssueController.dispose();
    placeOfOriginController.dispose();
    placeOfResidenceController.dispose();
    phoneNumberController.dispose();
    scanNotesController.dispose();
    super.dispose();
  }
}
