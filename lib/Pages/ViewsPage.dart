import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewsPage extends StatelessWidget {
  const ViewsPage({super.key});

  Map<String, dynamic> convertTimestampToString(Map<String, dynamic> record) {
    record['timestamp'] =
        (record['timestamp'] as Timestamp).toDate().toIso8601String();
    return record;
  }

  Map<String, dynamic> convertStringToTimestamp(Map<String, dynamic> record) {
    record['timestamp'] = DateTime.parse(record['timestamp']);
    return record;
  }

  Future<void> _saveRecordsToSharedPreferences(
      List<Map<String, dynamic>> records) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> convertedRecords =
        records.map(convertTimestampToString).toList();
    String jsonString = jsonEncode(convertedRecords);
    print('Saving records to SharedPreferences: $jsonString');
    await prefs.setString('userRecords', jsonString);
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
    int currentMonth = now.month;
    int currentYear = now.year;
    // String currentDay =
    // DateFormat('EEEE').format(now); // Get the day of the week
    String currentDayNumber =
        DateFormat('d').format(now); // Get the day number of the month

    try {
      print('Fetching records for email: $email');

      // Fetch records from the four collections
      final Future<QuerySnapshot> yesInsideRecordsSnapshot = FirebaseFirestore
          .instance
          .collection('Records')
          .doc('Starting_time')
          .collection(
              '$currentDayNumber-$currentMonth-$currentYear {yes_Inside}')
          .where('userEmail', isEqualTo: email)
          .get();

      final Future<QuerySnapshot> yesOutsideRecordsSnapshot = FirebaseFirestore
          .instance
          .collection('Records')
          .doc('Starting_time')
          .collection(
              '$currentDayNumber-$currentMonth-$currentYear {yes_Outside}')
          .where('userEmail', isEqualTo: email)
          .get();

      final Future<QuerySnapshot> noRecordsSnapshot = FirebaseFirestore.instance
          .collection('Records')
          .doc('Starting_time')
          .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
          .where('userEmail', isEqualTo: email)
          .get();

      final Future<QuerySnapshot> noOptionSelectedRecordsSnapshot =
          FirebaseFirestore.instance
              .collection('Records')
              .doc('Starting_time')
              .collection(
                  '$currentDayNumber-$currentMonth-$currentYear {no_option_selected}')
              .where('userEmail', isEqualTo: email)
              .get();

      // Wait for all the queries to complete and combine the results
      final List<QuerySnapshot> snapshots = await Future.wait([
        yesInsideRecordsSnapshot,
        yesOutsideRecordsSnapshot,
        noRecordsSnapshot,
        noOptionSelectedRecordsSnapshot,
      ]);

      print('Snapshots retrieved: ${snapshots.length}');
      snapshots.forEach((snapshot) {
        print('Snapshot size: ${snapshot.size}');
      });

      // Combine the records from all the snapshots
      final List<Map<String, dynamic>> allRecords = [
        for (final snapshot in snapshots)
          ...snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            print('Document data: $data');
            data['date'] =
                DateFormat('d-M-yyyy').format(doc['timestamp'].toDate());
            data['dayOfWeek'] =
                DateFormat('EEEE').format(doc['timestamp'].toDate());
            return data;
          }),
      ];

      print('All records: $allRecords');

      // Save records to SharedPreferences
      await _saveRecordsToSharedPreferences(allRecords);

      return allRecords;
    } catch (e) {
      print('Error fetching records: $e');
      return [];
    }
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
                if (cachedRecords.isNotEmpty) {
                  print('Displaying cached records');
                  return cachedRecords;
                } else {
                  print('No cached records found, fetching from Firestore');
                  return await _fetchUserRecords(email);
                }
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
    );
  }
}
