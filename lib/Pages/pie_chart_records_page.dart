// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'package:intl/intl.dart';
//
// class RecordsPage extends StatefulWidget {
//   final String section;
//
//   RecordsPage({super.key, required this.section, required List records});
//
//   @override
//   _RecordsPageState createState() => _RecordsPageState();
// }
//
// class _RecordsPageState extends State<RecordsPage> {
//   List<Map<String, dynamic>> records = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadRecordsFromSharedPreferences().then((loadedRecords) {
//       print('Loaded Records: $loadedRecords'); // Debug print
//       setState(() {
//         records = _filterRecordsBySection(loadedRecords, widget.section);
//         print('Filtered Records: $records'); // Debug print
//         isLoading = false;
//       });
//     }).catchError((error) {
//       print('Error loading records: $error');
//       setState(() {
//         isLoading = false; // Stop loading indicator even if there's an error
//       });
//     });
//   }
//
//   Future<List<Map<String, dynamic>>> _loadRecordsFromSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? jsonString = prefs.getString('userRecords');
//     print('Stored Records JSON: $jsonString'); // Debug print
//     if (jsonString == null) {
//       return []; // No records found
//     } else {
//       List<dynamic> jsonList = jsonDecode(jsonString);
//       return jsonList.map((item) => Map<String, dynamic>.from(item)).toList();
//     }
//   }
//
//   List<Map<String, dynamic>> _filterRecordsBySection(
//       List<Map<String, dynamic>> records, String section) {
//     switch (section) {
//       case 'Yes (Inside)':
//         return records
//             .where((record) => record['action'] == 'Yes I am at work')
//             .toList();
//       case 'Yes (Outside)':
//         return records
//             .where((record) => record['action'] == 'No I am not at work (Outside)')
//             .toList();
//       case 'No':
//         return records
//             .where((record) => record['action'] == 'No I am not at work')
//             .toList();
//       default:
//         print('Unknown section: $section'); // Debug print
//         return [];
//     }
//   }
//
//   String _getDayOfWeek(String? dateString) {
//     if (dateString == null) return 'No Date';
//     DateTime date = DateFormat('yyyy-MM-dd').parse(dateString);
//     return DateFormat('EEEE').format(date); // EEEE gives the full day name
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Records for ${widget.section}'),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : records.isEmpty
//           ? Center(child: Text('No records found for ${widget.section}.'))
//           : ListView.builder(
//         itemCount: records.length,
//         itemBuilder: (context, index) {
//           var record = records[index];
//           String? date = record['date'];
//           String dayOfWeek = _getDayOfWeek(date);
//           return ListTile(
//             title: Text('Record ${index + 1}'),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (date != null) Text(dayOfWeek),
//               ],
//             ),
//             trailing: Text(date ?? 'No Date'),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecordsPage extends StatefulWidget {
  final String section;
  final List<Map<String, dynamic>> records;

  RecordsPage({super.key, required this.section, required this.records});

  @override
  _RecordsPageState createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  late List<Map<String, dynamic>> filteredRecords;

  Future<List<Map<String, dynamic>>> _fetchRecordsFromFirestore() async {
    try {
      // Get the current date
      DateTime now = DateTime.now();
      // Determine the first and last day of the current month
      DateTime startOfMonth = DateTime(now.year, now.month, 1);
      DateTime endOfMonth = DateTime(now.year, now.month + 1, 0); // 0th day of the next month is the last day of the current month

      // Convert dates to string format for Firestore query
      String startDateString = DateFormat('yyyy-MM-dd').format(startOfMonth);
      String endDateString = DateFormat('yyyy-MM-dd').format(endOfMonth);

      // Fetch records for the current month
      final snapshot = await FirebaseFirestore.instance
          .collection('Records')
          .where('date', isGreaterThanOrEqualTo: startDateString)
          .where('date', isLessThanOrEqualTo: endDateString)
          .get();

      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error fetching records: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRecordsFromFirestore();
    filteredRecords = _filterRecordsBySection(widget.records, widget.section);
  }

  List<Map<String, dynamic>> _filterRecordsBySection(
      List<Map<String, dynamic>> records, String section) {
    switch (section) {
      case 'Yes (Inside)':
        return records
            .where((record) => record['action'] == 'Yes I am at work')
            .toList();
      case 'Yes (Outside)':
        return records
            .where((record) => record['action'] == 'No I am not at work (Outside)')
            .toList();
      case 'No':
        return records
            .where((record) => record['action'] == 'No I am not at work')
            .toList();
      default:
        return [];
    }
  }

  String _getDayOfWeek(String? dateString) {
    if (dateString == null) return 'No Date';
    try {
      DateTime date = DateFormat('dd-MM-yyyy').parse(dateString);
      return DateFormat('EEEE').format(date); // EEEE gives the full day name
    } catch (e) {
      return 'Invalid Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Records for ${widget.section}'),
      ),
      body: filteredRecords.isEmpty
          ? Center(child: Text('No records found for ${widget.section}.'))
          : ListView.builder(
        itemCount: filteredRecords.length,
        itemBuilder: (context, index) {
          var record = filteredRecords[index];
          return ListTile(
            title: Text('Date: ${record['date'] ?? 'No Date'}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Day: ${_getDayOfWeek(record['date'])}'),
                Text('Time: ${record['time'] ?? 'No Time'}'),
                if (record.containsKey('source'))
                  Text('Source: ${record['source'] ?? 'Unknown'}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
