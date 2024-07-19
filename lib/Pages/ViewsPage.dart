import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewsPage extends StatefulWidget {
  /*
  Format the views well, remove seconds
  Display records on a particular day all under that day , do not create multiple records display for it
  Add a date range  for teh display of records where the user can see the records for the current month only but can have access to the previous months records anytime
  save profile picture in firebase storage instead of shared preferences
  */

  const ViewsPage({super.key});

  @override
  State<ViewsPage> createState() => _ViewsPageState();
}

class _ViewsPageState extends State<ViewsPage> {
  late Stream<List<Map<String, dynamic>>> _recordsStream;

  @override
  void initState() {
    super.initState();
    _recordsStream = _createRecordsStream();
  }

  Map<String, dynamic> convertStringToTimestamp(Map<String, dynamic> record) {
    if (record['timestamp'] is String) {
      record['timestamp'] =
          Timestamp.fromDate(DateTime.parse(record['timestamp']).toUtc());
    }
    return record;
  }

  Map<String, dynamic> convertTimestampToString(Map<String, dynamic> record) {
    if (record['timestamp'] is Timestamp) {
      record['timestamp'] =
          (record['timestamp'] as Timestamp).toDate().toUtc().toIso8601String();
    }
    return record;
  }

  Stream<List<Map<String, dynamic>>> _createRecordsStream() async* {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      yield [];
      return;
    }

    final email = user.email!;
    List<Stream<QuerySnapshot<Map<String, dynamic>>>> streams = [];

    DateTime now = DateTime.now();
    DateTime startDate = now.subtract(const Duration(days: 7));

    for (int i = 0; i <= 7; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      int currentMonth = currentDate.month;
      int currentYear = currentDate.year;
      String currentDayNumber = DateFormat('d').format(currentDate);

      streams.addAll([
        FirebaseFirestore.instance
            .collection('Records')
            .doc('Starting_time')
            .collection(
                '$currentDayNumber-$currentMonth-$currentYear {yes_Inside}')
            .where('userEmail', isEqualTo: email)
            .snapshots(),
        FirebaseFirestore.instance
            .collection('Records')
            .doc('Starting_time')
            .collection(
                '$currentDayNumber-$currentMonth-$currentYear {yes_Outside}')
            .where('userEmail', isEqualTo: email)
            .snapshots(),
        FirebaseFirestore.instance
            .collection('Records')
            .doc('Starting_time')
            .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
            .where('userEmail', isEqualTo: email)
            .snapshots(),
        FirebaseFirestore.instance
            .collection('Records')
            .doc('Starting_time')
            .collection(
                '$currentDayNumber-$currentMonth-$currentYear {no_option_selected}')
            .where('userEmail', isEqualTo: email)
            .snapshots(),
      ]);
    }

    streams.addAll([
      FirebaseFirestore.instance
          .collection('ClosingRecords')
          .doc('Closing_time')
          .collection('yes_Closed')
          .where('userEmail', isEqualTo: email)
          .snapshots(),
      FirebaseFirestore.instance
          .collection('ClosingRecords')
          .doc('Closing_time')
          .collection('no_Closed')
          .where('userEmail', isEqualTo: email)
          .snapshots(),
      FirebaseFirestore.instance
          .collection('ClosingRecords')
          .doc('Closing_time')
          .collection('no_option_selected_Closed')
          .where('userEmail', isEqualTo: email)
          .snapshots(),
    ]);

    yield* CombineLatestStream.list(streams).map((snapshots) {
      List<Map<String, dynamic>> allRecords = [];
      for (var snapshot in snapshots) {
        allRecords.addAll(snapshot.docs.map((doc) {
          final data = doc.data();
          Timestamp timestamp = data['timestamp'] as Timestamp;
          DateTime dateTime = timestamp.toDate();

          data['date'] = DateFormat('dd-MM-yyyy').format(dateTime);
          data['time'] = DateFormat('HH:mm:ss').format(dateTime);
          data['dayOfWeek'] = DateFormat('EEEE').format(dateTime);
          return data;
        }).toList());
      }
      return allRecords;
    });
  }

  Future<void> _clearRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userRecords');
    setState(() {});
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
          : StreamBuilder<List<Map<String, dynamic>>>(
              stream: _recordsStream,
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
                    String dateKey =
                        '${record['dayOfWeek']} ${record['date']} ${record['time']}';
                    if (groupedRecords[dateKey] == null) {
                      groupedRecords[dateKey] = [];
                    }
                    groupedRecords[dateKey]!.add(record);
                  }

                  List<String> sortedKeys = groupedRecords.keys.toList();
                  sortedKeys.sort((a, b) {
                    DateTime dateA =
                        DateFormat('EEEE dd-MM-yyyy HH:mm:ss').parse(a);
                    DateTime dateB =
                        DateFormat('EEEE dd-MM-yyyy HH:mm:ss').parse(b);
                    return dateB.compareTo(dateA); // Sort in descending order
                  });

                  return ListView.builder(
                    itemCount: sortedKeys.length,
                    itemBuilder: (context, index) {
                      String dateKey = sortedKeys[index];
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
                                  Text('Date: ${record['date']}'),
                                  Text('Time: ${record['time']}'),
                                  if (record.containsKey('source'))
                                    Text('Source: ${record['source']}'),
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _clearRecords,
      //   tooltip: 'Clear Records',
      //   child: Icon(Icons.clear),
      // ),
    );
  }
}
