import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'noifications_service_new.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _saveUserDetails();
    _initializeWorkManager();
    NotificationService.showNotification(
        'Attendance Notice', 'Are you at work?');
  }

  String? _userName;
  String? _userEmail;
  String? _userPassword;

  Future<void> _saveUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName');
      _userEmail = prefs.getString('userEmail');
      _userPassword = prefs.getString('userPassword');
    });
  }

  Future<void> _initializeWorkManager() async {
    Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
    Workmanager().registerPeriodicTask(
      'dailyNotification',
      'dailyNotificationTask',
      frequency: const Duration(hours: 24),
      initialDelay: const Duration(minutes: 1),
      inputData: {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
      splashColor: Colors.purple,
      onPressed: () {
        Navigator.pushNamed(context, '/views');
      },
      child: const Column(
        children: [
          SizedBox(
            height: 3,
          ),
          Icon(Icons.remove_red_eye),
          SizedBox(
            height: 3,
          ),
          Text('Views')
        ],
      ),
    ));
  }
}
