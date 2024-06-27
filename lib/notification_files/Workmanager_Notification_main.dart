import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

showNotification() async {
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (notificationResponse) {
    print('object');
//clicking isn't working , work on it
    //Yes and No buttons are too small
    //save details to firestore
    // add the necessary actions when the buttons are hit
    if (notificationResponse.actionId == 'Yes') {
      print('Yes clicked');
      // Yes action
    } else if (notificationResponse.actionId == 'No') {
      print('No clicked');
      //  No action
      Workmanager().cancelByTag("Scheduled Task");
    }
  });
  flutterLocalNotificationsPlugin.show(
    0,
    'Title',
    'body',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        // try and import a new icon
        icon: "mipmap/ic_launcher", //add app icon here
        importance: Importance.high,
        playSound: true,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction('Yes', 'Yes', titleColor: Colors.green),
          AndroidNotificationAction(
            'No',
            'No',
            titleColor: Colors.red,
          ),
        ],
      ),
    ),
  );
  print('ended');
}

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      print('started');
      print(
          "Native called background task: $task"); //simpleTask will be emitted here.
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('mipmap/ic_launcher');
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: (e) {
        print('object');
      });
      flutterLocalNotificationsPlugin.show(
        0,
        'Attendance Notice!!',
        'Are you at work?',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'channelId',
            'channelName',
            icon: "mipmap/ic_launcher", //add app icon here
            importance: Importance.high,
            actions: <AndroidNotificationAction>[
              AndroidNotificationAction('Yes', 'Yes',
                  titleColor: Colors.green, showsUserInterface: true),
              AndroidNotificationAction('No', 'No',
                  titleColor: Colors.red, showsUserInterface: true),
            ],
          ),
        ),
      );
      print('ended');
      return Future.value(true);
    } catch (e) {
      print(e);
      return Future.value(false);
    }
  });
}

Future<void> requestNotificationPermissions() async {
  PermissionStatus status = await Permission.notification.status;

  if (status.isDenied || status.isPermanentlyDenied) {
    status = await Permission.notification.request();

    if (status.isGranted) {
      print("Notification permission granted.");
    } else {
      print("Notification permission denied.");
      // user denied the permission
    }
  }
}

void schdeduleNotification() {
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  Workmanager().registerPeriodicTask(
    "First Notification",
    "Scheduled Notifications",
    tag: 'Scheduled Task',
    frequency: const Duration(minutes: 15),
    initialDelay: const Duration(seconds: 4),
  );
}

class NotificationScheduler extends StatefulWidget {
  const NotificationScheduler({super.key});

  @override
  State<NotificationScheduler> createState() => _NotificationSchedulerState();
}

class _NotificationSchedulerState extends State<NotificationScheduler> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  schdeduleNotification();
                },
                child: const Text('Schedule notifications'))
          ],
        ),
      ),
    );
  }
}
