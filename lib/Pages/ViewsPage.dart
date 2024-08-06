// import 'dart:convert'; // Import this to handle JSON encoding and decoding
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:month_picker_dialog/month_picker_dialog.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ViewsPage extends StatefulWidget {
//   const ViewsPage({super.key});
//   @override
//   State<ViewsPage> createState() => _ViewsPageState();
// }
//
// class _ViewsPageState extends State<ViewsPage> {
//   late Stream<List<Map<String, dynamic>>> _recordsStream;
//   DateTime _selectedDate = DateTime.now();
//   String? _email;
//   @override
//   void initState() {
//     super.initState();
//     _loadEmailFromPrefs();
//     _loadRecordsFromPrefs();
//   }
//
//   Future<void> _loadEmailFromPrefs() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _email = prefs.getString('userEmail');
//       _recordsStream = _createRecordsStream();
//     });
//   }
//
//   Map<String, dynamic> _convertRecordToJson(Map<String, dynamic> record) {
//     if (record['timestamp'] is Timestamp) {
//       record['timestamp'] =
//           (record['timestamp'] as Timestamp).toDate().toIso8601String();
//     }
//     return record;
//   }
//
//   Map<String, dynamic> _convertJsonToRecord(Map<String, dynamic> record) {
//     if (record['timestamp'] is String) {
//       record['timestamp'] =
//           Timestamp.fromDate(DateTime.parse(record['timestamp']));
//     }
//     return record;
//   }
//
//   Future<void> _saveRecordsToPrefs(List<Map<String, dynamic>> records) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     // Convert each record to JSON format
//     List<Map<String, dynamic>> jsonRecords =
//         records.map(_convertRecordToJson).toList();
//     String recordsJson = jsonEncode(jsonRecords); // Convert to JSON string
//     await prefs.setString('userRecords', recordsJson); // Save JSON to prefs
//   }
//
//   Future<List<Map<String, dynamic>>> _loadRecordsFromPrefs() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? recordsJson = prefs.getString('userRecords');
//     if (recordsJson != null) {
//       List<dynamic> jsonList = jsonDecode(recordsJson);
//       // Convert JSON back to records
//       return jsonList
//           .map((item) => _convertJsonToRecord(item as Map<String, dynamic>))
//           .toList();
//     }
//     return [];
//   }
//
//   Stream<List<Map<String, dynamic>>> _createRecordsStream() async* {
//     if (_email == null) {
//       yield [];
//       return;
//     }
//
//     List<Stream<QuerySnapshot<Map<String, dynamic>>>> streams = [];
//
//     DateTime now = _selectedDate;
//     DateTime startDate = DateTime(now.year, now.month, 1);
//     DateTime endDate =
//         DateTime(now.year, now.month + 1, 1).subtract(const Duration(days: 1));
//
//     for (int i = 0; i <= endDate.day; i++) {
//       DateTime currentDate = startDate.add(Duration(days: i));
//       int currentMonth = currentDate.month;
//       int currentYear = currentDate.year;
//       String currentDayNumber = DateFormat('d').format(currentDate);
//
//       streams.addAll([
//         FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {yes_Inside}')
//             .where('userEmail', isEqualTo: _email)
//             .snapshots(),
//         FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {yes_Outside}')
//             .where('userEmail', isEqualTo: _email)
//             .snapshots(),
//         FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
//             .where('userEmail', isEqualTo: _email)
//             .snapshots(),
//         FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {Checked In}')
//             .where('userEmail', isEqualTo: _email)
//             .snapshots(),
//         FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {no_option_selected}')
//             .where('userEmail', isEqualTo: _email)
//             .snapshots(),
//       ]);
//     }
//     for (int i = 0; i <= endDate.day; i++) {
//       DateTime currentDate = startDate.add(Duration(days: i));
//       int currentMonth = currentDate.month;
//       int currentYear = currentDate.year;
//       String currentDayNumber = DateFormat('d').format(currentDate);
//
//       streams.addAll([
//         FirebaseFirestore.instance
//             .collection('ClosingRecords')
//             .doc('Closing_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {yes_Closed')
//             .where('userEmail', isEqualTo: _email)
//             .snapshots(),
//         FirebaseFirestore.instance
//             .collection('ClosingRecords')
//             .doc('Closing_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear no_Closed')
//             .where('userEmail', isEqualTo: _email)
//             .snapshots(),
//         FirebaseFirestore.instance
//             .collection('ClosingRecords')
//             .doc('Closing_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear no_option_selected_Closed')
//             .where('userEmail', isEqualTo: _email)
//             .snapshots(),
//       ]);
//     }
//     yield* CombineLatestStream.list(streams).map((snapshots) {
//       List<Map<String, dynamic>> allRecords = [];
//       for (var snapshot in snapshots) {
//         allRecords.addAll(snapshot.docs.map((doc) {
//           final data = doc.data();
//           Timestamp timestamp = data['timestamp'] as Timestamp;
//           DateTime dateTime = timestamp.toDate();
//
//           data['date'] = DateFormat('dd-MM-yyyy').format(dateTime);
//           data['time'] = DateFormat('HH:mm').format(dateTime); // Remove seconds
//           data['dayOfWeek'] = DateFormat('EEEE').format(dateTime);
//           data.remove('userName'); // Clear userName
//           data.remove('userEmail'); // Clear userEmail
//           print("Fetched record: $data"); // Debugging print statement
//
//           return data;
//         }).toList());
//       }
//       print(
//           "Total records fetched: ${allRecords.length}"); // Debugging print statement
//
//       // Save fetched records to SharedPreferences
//       _saveRecordsToPrefs(allRecords);
//
//       return allRecords;
//     });
//   }
//
//   Future<void> _clearRecords() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('userRecords');
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Records'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.calendar_today),
//             onPressed: () {
//               showMonthPicker(
//                 context: context,
//                 initialDate: _selectedDate,
//                 firstDate: DateTime(DateTime.now().year - 5),
//                 lastDate: DateTime(DateTime.now().year + 5),
//               ).then((date) {
//                 if (date != null) {
//                   setState(() {
//                     _selectedDate = date;
//                     _recordsStream = _createRecordsStream();
//                   });
//                 }
//               });
//             },
//           ),
//         ],
//       ),
//       body: _email == null
//           ? const Center(child: CircularProgressIndicator())
//           : StreamBuilder<List<Map<String, dynamic>>>(
//               stream: _recordsStream,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('No records found'));
//                 } else {
//                   List<Map<String, dynamic>> records = snapshot.data!;
//                   Map<String, List<Map<String, dynamic>>> groupedRecords = {};
//
//                   for (var record in records) {
//                     String dateKey = '${record['dayOfWeek']} ${record['date']}';
//                     if (groupedRecords[dateKey] == null) {
//                       groupedRecords[dateKey] = [];
//                     }
//                     groupedRecords[dateKey]!.add(record);
//                   }
//
//                   List<String> sortedKeys = groupedRecords.keys.toList();
//                   sortedKeys.sort((a, b) {
//                     DateTime dateA = DateFormat('EEEE dd-MM-yyyy').parse(a);
//                     DateTime dateB = DateFormat('EEEE dd-MM-yyyy').parse(b);
//                     return dateB.compareTo(dateA); // Sort in descending order
//                   });
//
//                   return ListView.builder(
//                     itemCount: sortedKeys.length,
//                     itemBuilder: (context, index) {
//                       String dateKey = sortedKeys[index];
//                       List<Map<String, dynamic>> dateRecords =
//                           groupedRecords[dateKey]!;
//
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               dateKey,
//                               style: const TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           ...dateRecords.map((record) {
//                             return ListTile(
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Status: ${record['action']}'),
//                                   Text('Date: ${record['date']}'),
//                                   Text('Time: ${record['time']}'),
//                                   if (record.containsKey('source'))
//                                     Text('Source: ${record['source']}'),
//                                 ],
//                               ),
//                             );
//                           }).toList(),
//                         ],
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _clearRecords,
//         tooltip: 'Clear Records',
//         child: const Icon(Icons.clear),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewsPage extends StatefulWidget {
  const ViewsPage({super.key});

  @override
  State<ViewsPage> createState() => _ViewsPageState();
}

class _ViewsPageState extends State<ViewsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final BehaviorSubject<List<Map<String, dynamic>>> _recordsSubject =
      BehaviorSubject.seeded([]);
  final BehaviorSubject<List<Map<String, dynamic>>> _closingRecordsSubject =
      BehaviorSubject.seeded([]);
  DateTime _selectedDate = DateTime.now();
  String? _email;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadEmailFromPrefs();
  }

  Future<void> _loadEmailFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('userEmail');
      if (_email != null) {
        _initializeStreams();
      }
    });
  }

  void _initializeStreams() {
    _createRecordsStream('Records', 'Starting_time').listen((records) {
      _recordsSubject.add(records);
    });
    _createRecordsStream('ClosingRecords', 'Closing_time').listen((records) {
      _closingRecordsSubject.add(records);
    });
  }

  Stream<List<Map<String, dynamic>>> _createRecordsStream(
      String collection, String document) async* {
    if (_email == null) {
      yield [];
      return;
    }

    List<Stream<QuerySnapshot<Map<String, dynamic>>>> streams = [];
    DateTime now = _selectedDate;
    DateTime startDate = DateTime(now.year, now.month, 1);
    DateTime endDate =
        DateTime(now.year, now.month + 1, 1).subtract(const Duration(days: 1));

    for (int i = 0; i <= endDate.day; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      int currentMonth = currentDate.month;
      int currentYear = currentDate.year;
      String currentDayNumber = DateFormat('d').format(currentDate);

      if (collection == 'Records') {
        streams.addAll([
          FirebaseFirestore.instance
              .collection(collection)
              .doc(document)
              .collection(
                  '$currentDayNumber-$currentMonth-$currentYear {yes_Inside}')
              .where('userEmail', isEqualTo: _email)
              .snapshots(),
          FirebaseFirestore.instance
              .collection(collection)
              .doc(document)
              .collection(
                  '$currentDayNumber-$currentMonth-$currentYear {yes_Outside}')
              .where('userEmail', isEqualTo: _email)
              .snapshots(),
          FirebaseFirestore.instance
              .collection(collection)
              .doc(document)
              .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
              .where('userEmail', isEqualTo: _email)
              .snapshots(),
          FirebaseFirestore.instance
              .collection(collection)
              .doc(document)
              .collection(
                  '$currentDayNumber-$currentMonth-$currentYear {Checked In}')
              .where('userEmail', isEqualTo: _email)
              .snapshots(),
          FirebaseFirestore.instance
              .collection(collection)
              .doc(document)
              .collection(
                  '$currentDayNumber-$currentMonth-$currentYear {no_option_selected}')
              .where('userEmail', isEqualTo: _email)
              .snapshots(),
        ]);
      } else if (collection == 'ClosingRecords') {
        streams.addAll([
          FirebaseFirestore.instance
              .collection(collection)
              .doc(document)
              .collection(
                  '$currentDayNumber-$currentMonth-$currentYear {yes_Closed}')
              .where('userEmail', isEqualTo: _email)
              .snapshots(),
          FirebaseFirestore.instance
              .collection(collection)
              .doc(document)
              .collection(
                  '$currentDayNumber-$currentMonth-$currentYear no_Closed')
              .where('userEmail', isEqualTo: _email)
              .snapshots(),
          FirebaseFirestore.instance
              .collection(collection)
              .doc(document)
              .collection(
                  '$currentDayNumber-$currentMonth-$currentYear no_option_selected_Closed')
              .where('userEmail', isEqualTo: _email)
              .snapshots(),
        ]);
      }
    }

    yield* CombineLatestStream.list(streams).map((snapshots) {
      List<Map<String, dynamic>> allRecords = [];
      for (var snapshot in snapshots) {
        allRecords.addAll(snapshot.docs.map((doc) {
          final data = doc.data();
          Timestamp timestamp = data['timestamp'] as Timestamp;
          DateTime dateTime = timestamp.toDate();

          data['date'] = DateFormat('dd-MM-yyyy').format(dateTime);
          data['time'] = DateFormat('HH:mm').format(dateTime);
          data['dayOfWeek'] = DateFormat('EEEE').format(dateTime);
          data.remove('userName');
          data.remove('userEmail');
          return data;
        }).toList());
      }
      _saveRecordsToPrefs(allRecords);
      return allRecords;
    });
  }

  Future<void> _saveRecordsToPrefs(List<Map<String, dynamic>> records) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonRecords =
        records.map(_convertRecordToJson).toList();
    String recordsJson = jsonEncode(jsonRecords);
    await prefs.setString('userRecords', recordsJson);
  }

  Future<List<Map<String, dynamic>>> _loadRecordsFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? recordsJson = prefs.getString('userRecords');
    if (recordsJson != null) {
      List<dynamic> jsonList = jsonDecode(recordsJson);
      return jsonList
          .map((item) => _convertJsonToRecord(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Map<String, dynamic> _convertRecordToJson(Map<String, dynamic> record) {
    if (record['timestamp'] is Timestamp) {
      record['timestamp'] =
          (record['timestamp'] as Timestamp).toDate().toIso8601String();
    }
    return record;
  }

  Map<String, dynamic> _convertJsonToRecord(Map<String, dynamic> record) {
    if (record['timestamp'] is String) {
      record['timestamp'] =
          Timestamp.fromDate(DateTime.parse(record['timestamp']));
    }
    return record;
  }

  Future<void> _clearRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userRecords');
    setState(() {});
  }

  @override
  void dispose() {
    _recordsSubject.close();
    _closingRecordsSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Records'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              showMonthPicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(DateTime.now().year - 5),
                lastDate: DateTime(DateTime.now().year + 5),
              ).then((date) {
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                    if (_email != null) {
                      _initializeStreams();
                    }
                  });
                }
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Records'),
            Tab(text: 'Closing Records'),
          ],
        ),
      ),
      body: _email == null
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildRecordsList(_recordsSubject.stream),
                _buildRecordsList(_closingRecordsSubject.stream),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearRecords,
        tooltip: 'Clear Records',
        child: const Icon(Icons.clear),
      ),
    );
  }

  Widget _buildRecordsList(Stream<List<Map<String, dynamic>>>? recordsStream) {
    if (recordsStream == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: recordsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No records found'));
        } else {
          List<Map<String, dynamic>> records = snapshot.data!;
          Map<String, List<Map<String, dynamic>>> groupedRecords = {};

          for (var record in records) {
            String dayOfWeek = record['dayOfWeek'] ?? 'Unknown Day';
            String date = record['date'] ?? 'Unknown Date';
            String dateKey = '$dayOfWeek $date';

            if (groupedRecords[dateKey] == null) {
              groupedRecords[dateKey] = [];
            }
            groupedRecords[dateKey]!.add(record);
          }

          List<String> sortedKeys = groupedRecords.keys.toList()
            ..sort((a, b) {
              try {
                DateFormat dateFormat = DateFormat('EEEE dd-MM-yyyy');
                DateTime dateA = dateFormat.parse(a);
                DateTime dateB = dateFormat.parse(b);
                return dateB.compareTo(dateA);
              } catch (e) {
                return 0;
              }
            });

          return ListView.builder(
            itemCount: sortedKeys.length,
            itemBuilder: (context, index) {
              String dateKey = sortedKeys[index];
              List<Map<String, dynamic>> dayRecords =
                  groupedRecords[dateKey] ?? [];

              return ExpansionTile(
                title: Text(
                  dateKey,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: dayRecords.map((record) {
                  String status = record['action'] ?? 'Unknown action';
                  String time = record['time'] ?? 'Unknown Time';

                  return ListTile(
                    title: Text(status),
                    subtitle: Text(time),
                  );
                }).toList(),
              );
            },
          );
        }
      },
    );
  }
}
