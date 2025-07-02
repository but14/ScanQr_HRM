import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  // Sample data representing the history of scans (time and date)
  final List<Map<String, String>> historyData = [
    {'time': '12:30 PM', 'date': '02/07/2025'},
    {'time': '01:45 PM', 'date': '02/07/2025'},
    {'time': '03:00 PM', 'date': '02/07/2025'},
    {'time': '04:30 PM', 'date': '02/07/2025'},
    {'time': '05:00 PM', 'date': '02/07/2025'},
    {'time': '09:00 AM', 'date': '03/07/2025'},
    {'time': '10:15 AM', 'date': '03/07/2025'},
    {'time': '11:30 AM', 'date': '03/07/2025'},
    {'time': '01:00 PM', 'date': '03/07/2025'},
    {'time': '02:30 PM', 'date': '03/07/2025'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử Quét'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: historyData.length, // The number of items in the list
          itemBuilder: (context, index) {
            final scanData =
                historyData[index]; // Get the scan data for each item
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.history, color: Colors.blue),
                title: Text('Thời gian: ${scanData['time']}'),
                subtitle: Text('Ngày: ${scanData['date']}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Handle tap for more details or to show specific history data
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
