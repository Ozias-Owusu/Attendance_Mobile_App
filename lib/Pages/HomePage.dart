import 'package:attendance_mobile_app/Pages/noifications_service_new.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';



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
                  // Navigator.pushNamed(context, '/');
                  // schdeduleNotification();
                  // NotificationService.showNotification("title", "body");

                  // Workmanager().initialize(
                  //     callbackDispatcher, // The top level function, aka callbackDispatcher
                  //     isInDebugMode: false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
                  // );
                  Workmanager().registerPeriodicTask('uniqueName', 'taskName',
                    tag: 'task',
                    frequency: const Duration(minutes: 15),initialDelay: const Duration(seconds: 5),
                  );
                },
                child: const Text('Log Out')),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  Workmanager().cancelByTag('task');
                  print('Task cancelled');
                },
                child: const Text('Cancel task'),

            ),
          ],
        ),
      ),
    );
  }
}
