import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            icon: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.logout_outlined),
            ),
            onPressed: () async {
              // Sign out the user
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, '/');

              print('User successfully signed out');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person, size: 30),
              title: const Text('Profile', style: TextStyle(fontSize: 20)),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Profile Page
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.email, size: 30),
              title: const Text('Change Email', style: TextStyle(fontSize: 20)),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Change Email Page
                print('Email cannot be changed');
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock, size: 30),
              title:
                  const Text('Change Password', style: TextStyle(fontSize: 20)),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Change Password Page
                Navigator.pushNamed(context, '/password');
              },
            ),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              'Notifications Settings',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text('Enable Notifications',
                  style: TextStyle(fontSize: 20)),
              value: true,
              onChanged: (bool value) {
                // Handle notification settings change
              },
              secondary: const Icon(Icons.notifications, size: 30),
            ),
            SwitchListTile(
              title: const Text('Email Notifications',
                  style: TextStyle(fontSize: 20)),
              value: false,
              onChanged: (bool value) {
                // Handle email notification settings change
              },
              secondary: const Icon(Icons.email, size: 30),
            ),
            SwitchListTile(
              title: const Text('Push Notifications',
                  style: TextStyle(fontSize: 20)),
              value: true,
              onChanged: (bool value) {
                // Handle push notification settings change
              },
              secondary: const Icon(Icons.phone_android, size: 30),
            ),
            SwitchListTile(
              title: const Text('Theme', style: TextStyle(fontSize: 20)),
              value: false,
              onChanged: (bool value) {
                // Handle push notification settings change
              },
              secondary: const Icon(Icons.dark_mode, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
