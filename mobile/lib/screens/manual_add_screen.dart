import 'package:flutter/material.dart';

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
  final TextEditingController managerIdController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final ocrData = widget.ocrData;
    nameController.text = widget.ocrData['full_name'] ?? '';
    dobController.text = widget.ocrData['date_of_birth'] ?? '';
    genderController.text = widget.ocrData['gender'] ?? '';
    nationalityController.text = widget.ocrData['nationality'] ?? '';
    idNumberController.text = widget.ocrData['id_number'] ?? '';
    placeOfOriginController.text = widget.ocrData['place_of_origin'] ?? '';
    placeOfResidenceController.text =
        widget.ocrData['place_of_residence'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm nhân sự thủ công'),
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
              _buildTextField(genderController, 'Giới tính', Icons.wc),
              _buildTextField(nationalityController, 'Quốc tịch', Icons.flag),
              _buildTextField(
                  idNumberController, 'Số CCCD/Mã nhân sự', Icons.badge),
              _buildDateField(dateOfIssueController, 'Ngày cấp', Icons.event),
              _buildTextField(
                  placeOfOriginController, 'Nguyên quán', Icons.home),
              _buildTextField(placeOfResidenceController, 'Nơi thường trú',
                  Icons.location_city),
              _buildTextField(
                  managerIdController, 'Mã quản lý', Icons.supervisor_account),
              _buildTextField(
                  scanNotesController, 'Ghi chú quét', Icons.note_alt),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Lưu thông tin'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã lưu thành công!')),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Nhập $label' : null,
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
                "\${picked.day.toString().padLeft(2, '0')}/\${picked.month.toString().padLeft(2, '0')}/\${picked.year}";
          }
        },
        validator: (value) =>
            value == null || value.isEmpty ? 'Nhập $label' : null,
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
    scanNotesController.dispose();
    managerIdController.dispose();
    super.dispose();
  }
}
