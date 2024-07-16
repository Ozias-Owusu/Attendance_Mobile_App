// // import 'dart:convert';
// //
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // class ViewsPage extends StatelessWidget {
// //   const ViewsPage({super.key});
// //
// //   Map<String, dynamic> convertTimestampToString(Map<String, dynamic> record) {
// //     record['timestamp'] =
// //         (record['timestamp'] as Timestamp).toDate().toIso8601String();
// //     return record;
// //   }
// //
// //   Map<String, dynamic> convertStringToTimestamp(Map<String, dynamic> record) {
// //     record['timestamp'] =
// //         Timestamp.fromDate(DateTime.parse(record['timestamp']));
// //     return record;
// //   }
// //
// //   Future<void> _saveRecordsToSharedPreferences(
// //       List<Map<String, dynamic>> records) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     List<Map<String, dynamic>> convertedRecords =
// //         records.map(convertTimestampToString).toList();
// //     String jsonString = jsonEncode(convertedRecords);
// //     print('Saving records to SharedPreferences: $jsonString');
// //     await prefs.setString('userRecords', jsonString);
// //   }
// //
// //   Future<List<Map<String, dynamic>>> _loadRecordsFromSharedPreferences() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? jsonString = prefs.getString('userRecords');
// //     print('Loaded records from SharedPreferences: $jsonString');
// //     if (jsonString == null) {
// //       return [];
// //     } else {
// //       List<dynamic> jsonList = jsonDecode(jsonString);
// //       return jsonList
// //           .map((item) =>
// //               convertStringToTimestamp(Map<String, dynamic>.from(item)))
// //           .toList();
// //     }
// //   }
// //
// //   Future<List<Map<String, dynamic>>> _fetchUserRecords(String email) async {
// //     DateTime now = DateTime.now();
// //     int currentMonth = now.month;
// //     int currentYear = now.year;
// //     String currentDayNumber =
// //         DateFormat('d').format(now); // Get the day number of the month
// //
// //     try {
// //       print('Fetching records for email: $email');
// //
// //       // Fetch records from the four collections
// //       final yesInsideRecordsSnapshot = FirebaseFirestore.instance
// //           .collection('Records')
// //           .doc('Starting_time')
// //           .collection(
// //               '$currentDayNumber-$currentMonth-$currentYear {yes_Inside}')
// //           .where('userEmail', isEqualTo: email)
// //           .get();
// //
// //       final yesOutsideRecordsSnapshot = FirebaseFirestore.instance
// //           .collection('Records')
// //           .doc('Starting_time')
// //           .collection(
// //               '$currentDayNumber-$currentMonth-$currentYear {yes_Outside}')
// //           .where('userEmail', isEqualTo: email)
// //           .get();
// //
// //       final noRecordsSnapshot = FirebaseFirestore.instance
// //           .collection('Records')
// //           .doc('Starting_time')
// //           .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
// //           .where('userEmail', isEqualTo: email)
// //           .get();
// //
// //       final noOptionSelectedRecordsSnapshot = FirebaseFirestore.instance
// //           .collection('Records')
// //           .doc('Starting_time')
// //           .collection(
// //               '$currentDayNumber-$currentMonth-$currentYear {no_option_selected}')
// //           .where('userEmail', isEqualTo: email)
// //           .get();
// //
// //       // Wait for all the queries to complete and combine the results
// //       final snapshots = await Future.wait([
// //         yesInsideRecordsSnapshot,
// //         yesOutsideRecordsSnapshot,
// //         noRecordsSnapshot,
// //         noOptionSelectedRecordsSnapshot,
// //       ]);
// //
// //       print('Snapshots retrieved: ${snapshots.length}');
// //       snapshots.forEach((snapshot) {
// //         print('Snapshot size: ${snapshot.size}');
// //       });
// //
// //       // Combine the records from all the snapshots
// //       final allRecords = <Map<String, dynamic>>[
// //         for (final snapshot in snapshots)
// //           ...snapshot.docs.map((doc) {
// //             final data = doc.data() as Map<String, dynamic>;
// //             print('Document data: $data');
// //             data['date'] = DateFormat('d-M-yyyy')
// //                 .format((doc['timestamp'] as Timestamp).toDate());
// //             data['dayOfWeek'] = DateFormat('EEEE')
// //                 .format((doc['timestamp'] as Timestamp).toDate());
// //             return data;
// //           }),
// //       ];
// //
// //       print('All records: $allRecords');
// //
// //       return allRecords;
// //     } catch (e) {
// //       print('Error fetching records: $e');
// //       return [];
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     User? user = FirebaseAuth.instance.currentUser;
// //     String? email = user?.email;
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('User Records'),
// //       ),
// //       body: email == null
// //           ? const Center(child: Text('No user signed in'))
// //           : FutureBuilder<List<Map<String, dynamic>>>(
// //               future: _loadRecordsFromSharedPreferences()
// //                   .then((cachedRecords) async {
// //                 final currentRecords = await _fetchUserRecords(email!);
// //                 final combinedRecords = [...cachedRecords, ...currentRecords];
// //
// //                 // Save the combined records back to SharedPreferences
// //                 await _saveRecordsToSharedPreferences(combinedRecords);
// //
// //                 return combinedRecords;
// //               }),
// //               builder: (context, snapshot) {
// //                 if (snapshot.connectionState == ConnectionState.waiting) {
// //                   return const Center(child: CircularProgressIndicator());
// //                 } else if (snapshot.hasError) {
// //                   return Center(child: Text('Error: ${snapshot.error}'));
// //                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //                   return const Center(child: Text('No records found'));
// //                 } else {
// //                   List<Map<String, dynamic>> records = snapshot.data!;
// //                   Map<String, List<Map<String, dynamic>>> groupedRecords = {};
// //
// //                   for (var record in records) {
// //                     String dateKey = '${record['dayOfWeek']} ${record['date']}';
// //                     if (groupedRecords[dateKey] == null) {
// //                       groupedRecords[dateKey] = [];
// //                     }
// //                     groupedRecords[dateKey]!.add(record);
// //                   }
// //
// //                   return ListView.builder(
// //                     itemCount: groupedRecords.keys.length,
// //                     itemBuilder: (context, index) {
// //                       String dateKey = groupedRecords.keys.elementAt(index);
// //                       List<Map<String, dynamic>> dateRecords =
// //                           groupedRecords[dateKey]!;
// //
// //                       return Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Padding(
// //                             padding: const EdgeInsets.all(8.0),
// //                             child: Text(
// //                               dateKey,
// //                               style: const TextStyle(
// //                                   fontSize: 18, fontWeight: FontWeight.bold),
// //                             ),
// //                           ),
// //                           ...dateRecords.map((record) {
// //                             return ListTile(
// //                               title: Text('User: ${record['userName']}'),
// //                               subtitle: Column(
// //                                 crossAxisAlignment: CrossAxisAlignment.start,
// //                                 children: [
// //                                   Text('Email: ${record['userEmail']}'),
// //                                   Text('Status: ${record['action']}'),
// //                                   Text('Time: ${record['timestamp']}'),
// //                                 ],
// //                               ),
// //                             );
// //                           }).toList(),
// //                         ],
// //                       );
// //                     },
// //                   );
// //                 }
// //               },
// //             ),
// //     );
// //   }
// // }
//
// import 'dart:convert';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ViewsPage extends StatefulWidget {
//   const ViewsPage({super.key});
//
//   @override
//   State<ViewsPage> createState() => _ViewsPageState();
// }
//
// class _ViewsPageState extends State<ViewsPage> {
//   Map<String, dynamic> convertTimestampToString(Map<String, dynamic> record) {
//     record['timestamp'] =
//         (record['timestamp'] as Timestamp).toDate().toIso8601String();
//     return record;
//   }
//
//   Map<String, dynamic> convertStringToTimestamp(Map<String, dynamic> record) {
//     record['timestamp'] =
//         Timestamp.fromDate(DateTime.parse(record['timestamp']));
//     return record;
//   }
//
//   Future<void> _saveRecordsToSharedPreferences(
//       List<Map<String, dynamic>> records) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     // Check if records already exist in SharedPreferences
//     String? existingRecords = prefs.getString('firstStorage');
//     if (existingRecords != null) {
//       // Optionally, you can add a check here to avoid saving duplicates
//       // For simplicity, assuming you want to overwrite existing records
//       await prefs.remove('firstStorage');
//     }
//
//     List<Map<String, dynamic>> convertedRecords =
//         records.map(convertTimestampToString).toList();
//     String jsonString = jsonEncode(convertedRecords);
//     print('Saving records to SharedPreferences: $jsonString');
//     await prefs.setString('firstStorage', jsonString);
//   }
//
//   Future<List<Map<String, dynamic>>> _loadRecordsFromSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? jsonString = prefs.getString('firstStorage');
//     print('Loaded records from SharedPreferences: $jsonString');
//     if (jsonString == null) {
//       return [];
//     } else {
//       List<dynamic> jsonList = jsonDecode(jsonString);
//       return jsonList
//           .map((item) =>
//               convertStringToTimestamp(Map<String, dynamic>.from(item)))
//           .toList();
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> _fetchUserRecords(String email) async {
//     DateTime now = DateTime.now();
//     DateTime startDate =
//         now.subtract(const Duration(days: 7)); // Adjust the range as needed
//     List<Map<String, dynamic>> allRecords = [];
//
//     for (int i = 0; i <= 7; i++) {
//       DateTime currentDate = startDate.add(Duration(days: i));
//       int currentMonth = currentDate.month;
//       int currentYear = currentDate.year;
//       String currentDayNumber = DateFormat('d')
//           .format(currentDate); // Get the day number of the month
//
//       try {
//         print(
//             'Fetching records for email: $email on $currentDayNumber-$currentMonth-$currentYear');
//
//         final yesInsideRecordsSnapshot = FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {yes_Inside}')
//             .where('userEmail', isEqualTo: email)
//             .get();
//
//         final yesOutsideRecordsSnapshot = FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {yes_Outside}')
//             .where('userEmail', isEqualTo: email)
//             .get();
//
//         final noRecordsSnapshot = FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
//             .where('userEmail', isEqualTo: email)
//             .get();
//
//         final noOptionSelectedRecordsSnapshot = FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {no_option_selected}')
//             .where('userEmail', isEqualTo: email)
//             .get();
//
//         final snapshots = await Future.wait([
//           yesInsideRecordsSnapshot,
//           yesOutsideRecordsSnapshot,
//           noRecordsSnapshot,
//           noOptionSelectedRecordsSnapshot,
//         ]);
//
//         print(
//             'Snapshots retrieved for $currentDayNumber-$currentMonth-$currentYear: ${snapshots.length}');
//         snapshots.forEach((snapshot) {
//           print('Snapshot size: ${snapshot.size}');
//         });
//
//         allRecords.addAll([
//           for (final snapshot in snapshots)
//             ...snapshot.docs.map((doc) {
//               final data = doc.data() as Map<String, dynamic>;
//               print('Document data: $data');
//               data['date'] = DateFormat('d-M-yyyy')
//                   .format((doc['timestamp'] as Timestamp).toDate());
//               data['dayOfWeek'] = DateFormat('EEEE')
//                   .format((doc['timestamp'] as Timestamp).toDate());
//               return data;
//             }),
//         ]);
//       } catch (e) {
//         print(
//             'Error fetching records for $currentDayNumber-$currentMonth-$currentYear: $e');
//       }
//     }
//
//     print('All records: $allRecords');
//     return allRecords;
//   }
//
//   Future<void> _clearRecords() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('storage');
//     setState(() {
//       // Update UI state as needed after clearing SharedPreferences
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     User? user = FirebaseAuth.instance.currentUser;
//     String? email = user?.email;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Records'),
//       ),
//       body: email == null
//           ? const Center(child: Text('No user signed in'))
//           : FutureBuilder<List<Map<String, dynamic>>>(
//               future: _loadRecordsFromSharedPreferences()
//                   .then((cachedRecords) async {
//                 final currentRecords = await _fetchUserRecords(email!);
//                 final combinedRecords = [...cachedRecords, ...currentRecords];
//
//                 // Save the combined records back to SharedPreferences
//                 await _saveRecordsToSharedPreferences(combinedRecords);
//
//                 return combinedRecords;
//               }),
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
//                   return ListView.builder(
//                     itemCount: groupedRecords.keys.length,
//                     itemBuilder: (context, index) {
//                       String dateKey = groupedRecords.keys.elementAt(index);
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
//                               title: Text('User: ${record['userName']}'),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Email: ${record['userEmail']}'),
//                                   Text('Status: ${record['action']}'),
//                                   Text('Time: ${record['timestamp']}'),
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
//         child: Icon(Icons.clear),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewsPage extends StatefulWidget {
  const ViewsPage({super.key});

  @override
  State<ViewsPage> createState() => _ViewsPageState();
}

class _ViewsPageState extends State<ViewsPage> {
  // Map<String, dynamic> convertTimestampToString(Map<String, dynamic> record) {
  //   record['timestamp'] =
  //       (record['timestamp'] as Timestamp).toDate().toIso8601String();
  //   return record;
  // }

  Map<String, dynamic> convertStringToTimestamp(Map<String, dynamic> record) {
    record['timestamp'] =
        Timestamp.fromDate(DateTime.parse(record['timestamp']));
    return record;
  }

  Future<void> _saveRecordsToSharedPreferences(
      List<Map<String, dynamic>> records) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if records already exist in SharedPreferences
    String? existingRecords = prefs.getString('userRecords');
    if (existingRecords != null) {
      // Optionally, you can add a check here to avoid saving duplicates
      // For simplicity, assuming you want to overwrite existing records
      await prefs.remove('userRecords');
    }

    // Convert timestamps to string format for storage
    List<Map<String, dynamic>> convertedRecords =
        records.map(convertTimestampToString).toList();

    String jsonString = jsonEncode(convertedRecords);
    print('Saving records to SharedPreferences: $jsonString');
    await prefs.setString('userRecords', jsonString);
  }

  Map<String, dynamic> convertTimestampToString(Map<String, dynamic> record) {
    // Ensure 'timestamp' field is converted to string format
    record['timestamp'] =
        (record['timestamp'] as Timestamp).toDate().toIso8601String();
    return record;
  }

  Future<List<Map<String, dynamic>>> _loadRecordsFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('userRecords');
    print('Loaded records from SharedPreferences: $jsonString');
    if (jsonString == null) {
      return [];
    } else {
      List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((item) =>
              convertStringToTimestamp(Map<String, dynamic>.from(item)))
          .toList();
    }
  }

  Future<List<Map<String, dynamic>>> _fetchUserRecords(String email) async {
    DateTime now = DateTime.now();
    DateTime startDate =
        now.subtract(const Duration(days: 7)); // Adjust the range as needed
    List<Map<String, dynamic>> allRecords = [];

    for (int i = 0; i <= 7; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      int currentMonth = currentDate.month;
      int currentYear = currentDate.year;
      String currentDayNumber = DateFormat('d')
          .format(currentDate); // Get the day number of the month

      try {
        print(
            'Fetching records for email: $email on $currentDayNumber-$currentMonth-$currentYear');

        final yesInsideRecordsSnapshot = FirebaseFirestore.instance
            .collection('Records')
            .doc('Starting_time')
            .collection(
                '$currentDayNumber-$currentMonth-$currentYear {yes_Inside}')
            .where('userEmail', isEqualTo: email)
            .get();

        final yesOutsideRecordsSnapshot = FirebaseFirestore.instance
            .collection('Records')
            .doc('Starting_time')
            .collection(
                '$currentDayNumber-$currentMonth-$currentYear {yes_Outside}')
            .where('userEmail', isEqualTo: email)
            .get();

        final noRecordsSnapshot = FirebaseFirestore.instance
            .collection('Records')
            .doc('Starting_time')
            .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
            .where('userEmail', isEqualTo: email)
            .get();

        final noOptionSelectedRecordsSnapshot = FirebaseFirestore.instance
            .collection('Records')
            .doc('Starting_time')
            .collection(
                '$currentDayNumber-$currentMonth-$currentYear {no_option_selected}')
            .where('userEmail', isEqualTo: email)
            .get();

        final snapshots = await Future.wait([
          yesInsideRecordsSnapshot,
          yesOutsideRecordsSnapshot,
          noRecordsSnapshot,
          noOptionSelectedRecordsSnapshot,
        ]);

        print(
            'Snapshots retrieved for $currentDayNumber-$currentMonth-$currentYear: ${snapshots.length}');
        snapshots.forEach((snapshot) {
          print('Snapshot size: ${snapshot.size}');
        });

        allRecords.addAll([
          for (final snapshot in snapshots)
            ...snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              print('Document data: $data');
              data['date'] = DateFormat('d-M-yyyy')
                  .format((doc['timestamp'] as Timestamp).toDate());
              data['dayOfWeek'] = DateFormat('EEEE')
                  .format((doc['timestamp'] as Timestamp).toDate());
              return data;
            }),
        ]);
      } catch (e) {
        print(
            'Error fetching records for $currentDayNumber-$currentMonth-$currentYear: $e');
      }
    }

    print('All records: $allRecords');
    return allRecords;
  }

  Future<void> _clearRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userRecords');
    setState(() {
      // Update UI state as needed after clearing SharedPreferences
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Records'),
      ),
      body: email == null
          ? const Center(child: Text('No user signed in'))
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: _loadRecordsFromSharedPreferences()
                  .then((cachedRecords) async {
                final currentRecords = await _fetchUserRecords(email!);

                // Remove duplicates by checking ids
                Set cachedIds = cachedRecords
                    .map((record) => record['userRecords'])
                    .toSet();
                List<Map<String, dynamic>> combinedRecords = [
                  ...cachedRecords,
                  ...currentRecords
                      .where((record) =>
                          !cachedIds.contains(record['userRecords']))
                      .toList()
                ];

                // Save the combined records back to SharedPreferences
                await _saveRecordsToSharedPreferences(combinedRecords);

                return combinedRecords;
              }),
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
                    String dateKey = '${record['dayOfWeek']} ${record['date']}';
                    if (groupedRecords[dateKey] == null) {
                      groupedRecords[dateKey] = [];
                    }
                    groupedRecords[dateKey]!.add(record);
                  }

                  return ListView.builder(
                    itemCount: groupedRecords.keys.length,
                    itemBuilder: (context, index) {
                      String dateKey = groupedRecords.keys.elementAt(index);
                      List<Map<String, dynamic>> dateRecords =
                          groupedRecords[dateKey]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              dateKey,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ...dateRecords.map((record) {
                            return ListTile(
                              title: Text('User: ${record['userName']}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Email: ${record['userEmail']}'),
                                  Text('Status: ${record['action']}'),
                                  Text('Time: ${record['timestamp']}'),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    },
                  );
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearRecords,
        tooltip: 'Clear Records',
        child: Icon(Icons.clear),
      ),
    );
  }
}
