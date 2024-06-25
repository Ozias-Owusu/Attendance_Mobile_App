// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:workmanager/workmanager.dart';
//
// showNotification() async {
//   // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('currency');
//   const InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//       onDidReceiveNotificationResponse: (e) {
//     print('object');
//   });
//   flutterLocalNotificationsPlugin.show(
//       0,
//       'Title',
//       'body',
//       const NotificationDetails(
//           android: AndroidNotificationDetails(
//         'channelId',
//         'channelName',
//         icon: "currency", //add app icon here
//         importance: Importance.high,
//       )));
//   print('ended');
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
//           AndroidInitializationSettings('currency');
//       const InitializationSettings initializationSettings =
//           InitializationSettings(android: initializationSettingsAndroid);
//       await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//           onDidReceiveNotificationResponse: (e) {
//         print('object');
//       });
//       flutterLocalNotificationsPlugin.show(
//           0,
//           'Title',
//           'body',
//           const NotificationDetails(
//               android: AndroidNotificationDetails(
//             'channelId',
//             'channelName',
//             icon: "currency", //add app icon here
//             importance: Importance.high,
//           )));
//       print('ended');
//       return Future.value(true);
//     } catch (e) {
//       print(e);
//       return Future.value(false);
//     }
//   });
// }
//
// class NotificationsApp extends StatefulWidget {
//   const NotificationsApp({super.key});
//
//   @override
//   State<NotificationsApp> createState() => _NotificationsAppState();
// }
//
// class _NotificationsAppState extends State<NotificationsApp> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     showNotification().requestNotificationPermission();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             FilledButton(
//               onPressed: () {
//                 Workmanager().cancelByTag("task");
//                 Workmanager().initialize(
//                     callbackDispatcher, // The top level function, aka callbackDispatcher
//                     isInDebugMode:
//                         false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
//                     );
//                 Workmanager().registerPeriodicTask(
//                   'uniqueName',
//                   'taskName',
//                   tag: 'task',
//                   frequency: const Duration(minutes: 15),
//                   initialDelay: const Duration(seconds: 5),
//                 );
//               },
//               child: const Text('show notification'),
//             ),
//             FilledButton(
//               onPressed: () {
//                 showNotification();
//               },
//               child: const Text('show notification 2'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
