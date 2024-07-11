import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewsPage extends StatelessWidget {
  const ViewsPage({super.key});

  Future<List<Map<String, dynamic>>> _fetchUserRecords(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Records')
        .where('email', isEqualTo: email)
        .get();

    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
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
                  title: Text('Day: ${record['day']}'),
                  subtitle: Text(
                      'Date: ${record['date']} \nTimestamp: ${record['timestamp']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
