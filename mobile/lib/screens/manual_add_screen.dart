import 'package:flutter/material.dart';

class ManualAddScreen extends StatefulWidget {
  const ManualAddScreen({super.key});

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
              const SizedBox(height: 12),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nhập họ tên' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: dobController,
                decoration: const InputDecoration(
                  labelText: 'Ngày sinh',
                  prefixIcon: Icon(Icons.cake),
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(1990, 1, 1),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    dobController.text =
                        "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                  }
                },
                readOnly: true,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nhập ngày sinh' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: genderController,
                decoration: const InputDecoration(
                  labelText: 'Giới tính',
                  prefixIcon: Icon(Icons.wc),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nhập giới tính' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nationalityController,
                decoration: const InputDecoration(
                  labelText: 'Quốc tịch',
                  prefixIcon: Icon(Icons.flag),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nhập quốc tịch' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: idNumberController,
                decoration: const InputDecoration(
                  labelText: 'Số CCCD/Mã nhân sự',
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Nhập số CCCD/mã nhân sự'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: dateOfIssueController,
                decoration: const InputDecoration(
                  labelText: 'Ngày cấp',
                  prefixIcon: Icon(Icons.event),
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2020, 1, 1),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    dateOfIssueController.text =
                        "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                  }
                },
                readOnly: true,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nhập ngày cấp' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: placeOfOriginController,
                decoration: const InputDecoration(
                  labelText: 'Nguyên quán',
                  prefixIcon: Icon(Icons.home),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nhập nguyên quán' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: placeOfResidenceController,
                decoration: const InputDecoration(
                  labelText: 'Nơi thường trú',
                  prefixIcon: Icon(Icons.location_city),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Nhập nơi thường trú'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: managerIdController,
                decoration: const InputDecoration(
                  labelText: 'Mã quản lý',
                  prefixIcon: Icon(Icons.supervisor_account),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nhập mã quản lý' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: scanNotesController,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú quét',
                  prefixIcon: Icon(Icons.note_alt),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nhập ghi chú quét' : null,
              ),
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
                    // TODO: Xử lý lưu thông tin nhân sự thủ công
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
}
