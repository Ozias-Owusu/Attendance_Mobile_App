import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewsPage extends StatelessWidget {
  const ViewsPage({super.key});

  Future<List<Map<String, dynamic>>> _fetchUserRecords(String email) async {
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;
    String currentDay =
        DateFormat('EEEE').format(now); // Get the day of the week
    try {
      print('Fetching records for email: $email');
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Records')
          .doc('Starting_time')
          .collection('$currentMonth-$currentYear-$currentDay')
          .doc('yes-$currentDay')
          .collection('Yes')
          .where('userEmail', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No records found for email: $email');
      } else {
        print('Records fetched successfully for email: $email');
      }

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
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
              future: _fetchUserRecords(email),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No records found'));
                } else {
                  List<Map<String, dynamic>> records = snapshot.data!;
                  return ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      var record = records[index];
                      return ListTile(
                        title: Text('User: ${record['userName']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email: ${record['userEmail']}'),
                            Text('Time: ${record['timestamp'].toDate()}'),
                            Text('Day of Week: ${record['dayOfWeek']}'),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
    );
  }
}
