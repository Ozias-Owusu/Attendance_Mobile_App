// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:workmanager/workmanager.dart';
//
// showNotification() async {
//   // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('mipmap/ic_launcher');
//
//   const InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);
//
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//       onDidReceiveNotificationResponse: (notificationResponse) {
//     print('object');
//     if (notificationResponse.actionId == 'Yes') {
//       // Handle "Yes" button click
//       print('Yes clicked');
//     } else if (notificationResponse.actionId == 'No') {
//       // Handle "No" button click
//       print('No clicked');
//     }
//   });
//   flutterLocalNotificationsPlugin.show(
//     0,
//     'Title',
//     'body',
//     const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'channelId',
//         'channelName',
//         // try and import a new icon
//         icon: "mipmap/ic_launcher", //add app icon here
//         importance: Importance.high,
//         playSound: true,
//         actions: <AndroidNotificationAction>[
//           AndroidNotificationAction('Yes', 'Yes', titleColor: Colors.green),
//           AndroidNotificationAction(
//             'No',
//             'No',
//             titleColor: Colors.red,
//           ),
//         ],
//       ),
//     ),
//   );
//   print('Notifications Displayed');
// }
//
// @pragma(
//     'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     try {
//       print('started');
//       print(
//           "Native called background task: $task"); //simpleTask will be emitted here.
//       FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//           FlutterLocalNotificationsPlugin();
//       const AndroidInitializationSettings initializationSettingsAndroid =
//           AndroidInitializationSettings('mipmap/ic_launcher');
//       const InitializationSettings initializationSettings =
//           InitializationSettings(android: initializationSettingsAndroid);
//       await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//           onDidReceiveNotificationResponse: (notificationResponse) {
//         print('object');
//         if (notificationResponse.actionId == 'Yes') {
//           // Handle "Yes" button click
//           print('Yes clicked');
//         } else if (notificationResponse.actionId == 'No') {
//           // Handle "No" button click
//           print('No clicked');
//         }
//       });
//       flutterLocalNotificationsPlugin.show(
//         0,
//         'Attendance Notice!!',
//         'Are you at work?',
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'channelId',
//             'channelName',
//             icon: "mipmap/ic_launcher", //add app icon here
//             importance: Importance.high,
//             actions: <AndroidNotificationAction>[
//               AndroidNotificationAction('Yes', 'Yes', titleColor: Colors.green),
//               AndroidNotificationAction(
//                 'No',
//                 'No',
//                 titleColor: Colors.red,
//               ),
//             ],
//           ),
//         ),
//       );
//       print('ended');
//       return Future.value(true);
//     } catch (e) {
//       print(e);
//       return Future.value(false);
//     }
//   });
// }
//
// Future<void> requestNotificationPermissions() async {
//   PermissionStatus status = await Permission.notification.status;
//
//   if (status.isDenied || status.isPermanentlyDenied) {
//     status = await Permission.notification.request();
//
//     if (status.isGranted) {
//       print("Notification permission granted.");
//     } else {
//       print('Notification permission not granted.');
//       // user denied the permission
//     }
//   }
// }
//
// void schdeduleNotification() {
//   Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
//   Workmanager().registerPeriodicTask(
//     "First Notification",
//     "Scheduled Notifications",
//     tag: 'Scheduled Task',
//     frequency: const Duration(minutes: 15),
//     initialDelay: const Duration(seconds: 4),
//   );
// }
//
// class NotificationScheduler extends StatefulWidget {
//   const NotificationScheduler({super.key});
//
//   @override
//   State<NotificationScheduler> createState() => _NotificationSchedulerState();
// }
//
// class _NotificationSchedulerState extends State<NotificationScheduler> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: [
//             ElevatedButton(
//                 onPressed: () {
//                   schdeduleNotification();
//                 },
//                 child: const Text('Schedule notifications'))
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _showNotificationWithActions() async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'channelId',
    'channelName',
    icon: "mipmap/ic_launcher",
    actions: <AndroidNotificationAction>[
      AndroidNotificationAction('id_1', 'Yes', titleColor: Colors.green),
      AndroidNotificationAction('id_2', 'No', titleColor: Colors.red),
    ],
  );
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      0, 'Attendance Notice!!', 'Are you at work?', notificationDetails,
      payload: 'item x');
}

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      print('started');
      print("Native called background task: $task");
      await _showNotificationWithActions();
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
      print('Notification permission not granted.');
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
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('mipmap/ic_launcher'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                schdeduleNotification();
                flutterLocalNotificationsPlugin.initialize(
                  const InitializationSettings(
                    android:
                        AndroidInitializationSettings('mipmap/ic_launcher'),
                  ),
                  onDidReceiveNotificationResponse:
                      (NotificationResponse response) {
                    if (response.actionId == 'Yes') {
                      print('Yes clicked');
                    } else if (response.actionId == 'No') {
                      print('No clicked');
                    }
                  },
                );
              },
              child: const Text('Schedule notifications'),
            )
          ],
        ),
      ),
    );
  }
}
