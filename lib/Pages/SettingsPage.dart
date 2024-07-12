import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool _notificationsEnabled = true;
  bool _darkTheme = false;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _confirmToggleNotifications(bool value) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Notifications'),
          content: Text(value
              ? 'Do you want to enable notifications?'
              : 'Do you want to disable notifications?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (confirmed ?? false) {
      setState(() {
        _notificationsEnabled = value;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
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
                // Navigate to Email Page
                _showSnackBar('Email cannot be changed');
                print('Email cannot be changed');
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock, size: 30),
              title:
                  const Text('Change Password', style: TextStyle(fontSize: 20)),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Password Page
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
              value: _notificationsEnabled,
              onChanged: (bool value) {
                //  notification settings change
                _confirmToggleNotifications(value);
              },
              secondary: const Icon(Icons.notifications, size: 30),
            ),

            SwitchListTile(
              title: const Text('Theme', style: TextStyle(fontSize: 20)),
              value: _darkTheme,
              onChanged: (bool value) {
                // push notification settings change

              },
              secondary: const Icon(Icons.dark_mode, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
