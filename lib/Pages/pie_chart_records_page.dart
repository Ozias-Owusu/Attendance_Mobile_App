// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// class RecordsPage extends StatefulWidget {
//   final String section;
//   final List<Map<String, dynamic>> records;
//
//   const RecordsPage({super.key, required this.section, required this.records});
//
//   @override
//   _RecordsPageState createState() => _RecordsPageState();
// }
//
// class _RecordsPageState extends State<RecordsPage> {
//   late List<Map<String, dynamic>> filteredRecords;
//
//   Future<List<Map<String, dynamic>>> _fetchRecordsFromFirestore() async {
//     try {
//       // Get the current date
//       DateTime now = DateTime.now();
//       // Determine the first and last day of the current month
//       DateTime startOfMonth = DateTime(now.year, now.month, 1);
//       DateTime endOfMonth = DateTime(now.year, now.month + 1,
//           0); // 0th day of the next month is the last day of the current month
//
//       // Convert dates to string format for Firestore query
//       String startDateString = DateFormat('yyyy-MM-dd').format(startOfMonth);
//       String endDateString = DateFormat('yyyy-MM-dd').format(endOfMonth);
//
//       // Fetch records for the current month
//       final snapshot = await FirebaseFirestore.instance
//           .collection('Records')
//           .where('date', isGreaterThanOrEqualTo: startDateString)
//           .where('date', isLessThanOrEqualTo: endDateString)
//           .get();
//
//       return snapshot.docs
//           .map((doc) => doc.data() as Map<String, dynamic>)
//           .toList();
//     } catch (e) {
//       print('Error fetching records: $e');
//       return [];
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchRecordsFromFirestore();
//     filteredRecords = _filterRecordsBySection(widget.records, widget.section);
//   }
//
//   List<Map<String, dynamic>> _filterRecordsBySection(
//       List<Map<String, dynamic>> records, String section) {
//     switch (section) {
//       case 'Checked In':
//         return records
//             .where((record) => record['action'] == 'Checked In')
//             .toList();
//       case 'Not Checked In(Outside)':
//         return records
//             .where((record) => record['action'] == 'Not Checked In(Outside)')
//             .toList();
//       case 'Not Checked In':
//         return records
//             .where((record) => record['action'] == 'Not Checked In')
//             .toList();
//       default:
//         return [];
//     }
//   }
//
//   String _getDayOfWeek(String? dateString) {
//     if (dateString == null) return 'No Date';
//     try {
//       DateTime date = DateFormat('dd-MM-yyyy').parse(dateString);
//       return DateFormat('EEEE').format(date); // EEEE gives the full day name
//     } catch (e) {
//       return 'Invalid Date';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Records for ${widget.section}'),
//       ),
//       body: filteredRecords.isEmpty
//           ? Center(child: Text('No records found for ${widget.section}.'))
//           : ListView.builder(
//               itemCount: filteredRecords.length,
//               itemBuilder: (context, index) {
//                 var record = filteredRecords[index];
//                 return ListTile(
//                   title: Text('Date: ${record['date'] ?? 'No Date'}'),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Day: ${_getDayOfWeek(record['date'])}'),
//                       Text('Time: ${record['time'] ?? 'No Time'}'),
//                       if (record.containsKey('source'))
//                         Text('Source: ${record['source'] ?? 'Unknown'}'),
//                     ],
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class RecordsPage extends StatefulWidget {
//   final String section;
//   final List<Map<String, dynamic>> records;
//
//   const RecordsPage({super.key, required this.section, required this.records});
//
//   @override
//   _RecordsPageState createState() => _RecordsPageState();
// }
//
// class _RecordsPageState extends State<RecordsPage> {
//   late List<Map<String, dynamic>> filteredRecords;
//
//   Future<List<Map<String, dynamic>>> _fetchRecordsFromFirestore() async {
//     try {
//       // Get the current date
//       DateTime now = DateTime.now();
//       // Determine the first and last day of the current month
//       DateTime startOfMonth = DateTime(now.year, now.month, 1);
//       DateTime endOfMonth = DateTime(now.year, now.month + 1,
//           0); // 0th day of the next month is the last day of the current month
//
//       // Convert dates to string format for Firestore query
//       String startDateString = DateFormat('yyyy-MM-dd').format(startOfMonth);
//       String endDateString = DateFormat('yyyy-MM-dd').format(endOfMonth);
//
//       // Fetch records for the current month
//       final snapshot = await FirebaseFirestore.instance
//           .collection('Records')
//           .where('date', isGreaterThanOrEqualTo: startDateString)
//           .where('date', isLessThanOrEqualTo: endDateString)
//           .get();
//
//       return snapshot.docs
//           .map((doc) => doc.data() as Map<String, dynamic>)
//           .toList();
//     } catch (e) {
//       print('Error fetching records: $e');
//       return [];
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchRecordsFromFirestore();
//     filteredRecords = _filterRecordsBySection(widget.records, widget.section);
//   }
//
//   List<Map<String, dynamic>> _filterRecordsBySection(
//       List<Map<String, dynamic>> records, String section) {
//     List<Map<String, dynamic>> filtered = [];
//     switch (section) {
//       case 'Checked In':
//         filtered = records
//             .where((record) => record['action'] == 'Checked In')
//             .toList();
//         break;
//       case 'Not Checked In(Outside)':
//         filtered = records
//             .where((record) => record['action'] == 'Not Checked In(Outside)')
//             .toList();
//         break;
//       case 'Not Checked In':
//         filtered = records
//             .where((record) => record['action'] == 'Not Checked In')
//             .toList();
//         break;
//       default:
//         filtered = [];
//         break;
//     }
//     filtered.sort((a, b) => b['date'].compareTo(a['date']));
//     return filtered;
//   }
//
//   String _getDayOfWeek(String? dateString) {
//     if (dateString == null) return 'No Date';
//     try {
//       DateTime date = DateFormat('dd-MM-yyyy').parse(dateString);
//       return DateFormat('EEEE').format(date); // EEEE gives the full day name
//     } catch (e) {
//       return 'Invalid Date';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Records for ${widget.section}'),
//       ),
//       body: filteredRecords.isEmpty
//           ? Center(child: Text('No records found for ${widget.section}.'))
//           : ListView.builder(
//               itemCount: filteredRecords.length,
//               itemBuilder: (context, index) {
//                 var record = filteredRecords[index];
//                 return ListTile(
//                   title: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Date: ${record['date'] ?? 'No Date'}'),
//                       Text('Time: ${record['time'] ?? 'No Time'}'),
//                     ],
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Day: ${_getDayOfWeek(record['date'])}'),
//                       if (record.containsKey('source'))
//                         Text('Source: ${record['source'] ?? 'Unknown'}'),
//                     ],
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecordsPage extends StatefulWidget {
  final String section;
  final List<Map<String, dynamic>> records;

  const RecordsPage({super.key, required this.section, required this.records});

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
      DateTime endOfMonth = DateTime(now.year, now.month + 1,
          0); // 0th day of the next month is the last day of the current month

      // Convert dates to string format for Firestore query
      String startDateString = DateFormat('yyyy-MM-dd').format(startOfMonth);
      String endDateString = DateFormat('yyyy-MM-dd').format(endOfMonth);

      // Fetch records for the current month
      final snapshot = await FirebaseFirestore.instance
          .collection('Records')
          .where('date', isGreaterThanOrEqualTo: startDateString)
          .where('date', isLessThanOrEqualTo: endDateString)
          .get();

      return snapshot.docs
          .map((doc) => {
                ...doc.data(),
                'id': doc.id,
              } as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching records: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRecordsFromFirestore().then((fetchedRecords) {
      setState(() {
        filteredRecords =
            _filterRecordsBySection(fetchedRecords, widget.section);
      });
    });
  }

  List<Map<String, dynamic>> _filterRecordsBySection(
      List<Map<String, dynamic>> records, String section) {
    List<Map<String, dynamic>> filtered = [];
    switch (section) {
      case 'Checked In':
        filtered = records
            .where((record) => record['action'] == 'Checked In')
            .toList();
        break;
      case 'Not Checked In(Outside)':
        filtered = records
            .where((record) => record['action'] == 'Not Checked In(Outside)')
            .toList();
        break;
      case 'Not Checked In':
        filtered = records
            .where((record) => record['action'] == 'Not Checked In')
            .toList();
        break;
      default:
        filtered = [];
        break;
    }
    filtered.sort((a, b) {
      DateTime dateA = DateFormat('dd-MM-yyyy').parse(a['date']);
      DateTime dateB = DateFormat('dd-MM-yyyy').parse(b['date']);
      return dateB.compareTo(dateA);
    });
    return filtered;
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
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${record['date'] ?? 'No Date'}'),
                      Text('Time: ${record['time'] ?? 'No Time'}'),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Day: ${_getDayOfWeek(record['date'])}'),
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
