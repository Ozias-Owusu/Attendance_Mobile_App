import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    Workmanager().registerOneOffTask("task-identifier", "simpleTask",
        initialDelay: const Duration(minutes: 16));
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

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Workmanager()
                        .initialize(callbackDispatcher, isInDebugMode: false);
                    Workmanager().registerPeriodicTask('uniqueName', 'task',
                        frequency: const Duration(minutes: 15),
                        initialDelay: const Duration(seconds: 5),
                        tag: 'task');
                  },
                  child: const Text('Schedule task')),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Workmanager().cancelByTag('task');
                  },
                  child: const Text('Log cancel')),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          splashColor: Colors.purple,
          onPressed: () {
            Navigator.pushNamed(context, '/views');
          },
          child: const Icon(Icons.remove_red_eye),
        ));
  }
}
