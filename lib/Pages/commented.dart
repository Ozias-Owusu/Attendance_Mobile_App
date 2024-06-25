// // import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:timezone/data/latest.dart' as tz;
//
// import 'Pages/AuthPage.dart';
// import 'Pages/HomePage.dart';
// import 'firebase_options.dart';
//
// final navigatorKey = GlobalKey<NavigatorState>();
//
// Future _firebaseBackgroundMessage(RemoteMessage message) async {
//   if (message.notification != null) {
//     print('Notification Received Successfully');
//   }
// }
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // await Firebase.initializeApp(
//   //     options: const FirebaseOptions(
//   //         apiKey: 'AIzaSyCXaqMiWXuVi8H1JP3OZZ1qZM4TiY4gkzo',
//   //         appId: '1:513839870238:android:6a4b2eee7ef54f4c05190f',
//   //         messagingSenderId: '513839870238',
//   //         projectId: 'attendance-web-app-a6aa7'));
//
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//   //   if (message.notification != null) {
//   //     print('background notification tapped');
//   //     navigatorKey.currentState!.pushNamed('/home', arguments: message);
//   //   }
//   // });
//   // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//   //   if (message.notification != null) {
//   //     print('Notification Tapped');
//   //   }
//   // });
//
//   // PushNotifications.init();
//   // FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
//   // tz.initializeTimeZones();
//
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       navigatorKey: navigatorKey,
//       debugShowCheckedModeBanner: false,
//       routes: {
//         '/': (_) => const AuthPage(),
//         '/home': (_) => const HomePage(),
//       },
//       onGenerateRoute: (settings) {
//         if (settings.name == '/') {
//           final value = settings.arguments as int;
//           return MaterialPageRoute(builder: (_) => const AuthPage());
//         }
//         return null;
//       },
//     );
//   }
// }
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   TimeOfDay? _startTime;
//   TimeOfDay? _endTime;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSavedTimes();
//     _initializeNotifications();
//     _fetchAndScheduleNotifications();
//     // _automatedPermissionRequest();
//   }
//
// Future<void> _automatedPermissionRequest() async {
//   WidgetsBinding.instance.addPostFrameCallback((_) async {
//     if (await Permission.scheduleExactAlarm.request().isGranted) {
//       print('SCHEDULE_EXACT_ALARM permission granted');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('SCHEDULE_EXACT_ALARM permission granted'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     } else {
//       print('SCHEDULE_EXACT_ALARM permission denied');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('SCHEDULE_EXACT_ALARM permission denied'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   });
// }
//
// Future<void> _initializeNotifications() async {
//   tz.initializeTimeZones();
//   tz.setLocalLocation(tz.getLocation('Accra/Ghana'));
//
//   const AndroidInitializationSettings initializationSettingsAndroid =
//   AndroidInitializationSettings('@mipmap/ic_launcher');
//
//   const DarwinInitializationSettings initializationSettingsDarwin =
//   DarwinInitializationSettings(
//     requestAlertPermission: false,
//     requestBadgePermission: false,
//     requestSoundPermission: false,
//   );
//
//   const InitializationSettings initializationSettings =
//   InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: initializationSettingsDarwin,
//   );
//
//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse: (NotificationResponse response) {
//       // Handle notification tapped logic here, if needed
//       Navigator.pushNamed(context, '/home');
//     },
//   );
//
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     '0', // id
//     'CHANNEL 1', // name
//     importance: Importance.high,
//   );
//
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//       AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
// }
//
// Future<void> _loadSavedTimes() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   setState(() {
//     String? startTime = prefs.getString('startTime');
//     String? endTime = prefs.getString('endTime');
//
//     if (startTime != null) {
//       _startTime = TimeOfDay(
//         hour: int.parse(startTime.split(":")[0]),
//         minute: int.parse(startTime.split(":")[1]),
//       );
//     }
//     if (endTime != null) {
//       _endTime = TimeOfDay(
//         hour: int.parse(endTime.split(":")[0]),
//         minute: int.parse(endTime.split(":")[1]),
//       );
//     }
//   });
// }
//
// Future<void> _fetchAndScheduleNotifications() async {
//   User? user = FirebaseAuth.instance.currentUser;
//   if (user != null) {
//     // Fetch notification settings from Firestore
//     DocumentSnapshot userDoc = await FirebaseFirestore.instance
//         .collection('notificationsTimer')
//         .doc(user.uid)
//         .get();
//
//     if (userDoc.exists) {
//       var notificationSettings = userDoc.get('notificationsTimer');
//       String startTime = notificationSettings['start'];
//       String endTime = notificationSettings['end'];
//
//       _scheduleNotifications(startTime, endTime);
//     }
//   }
// }
//
// void _scheduleNotifications(String startTime, String endTime) {
//   TimeOfDay start = _parseTime(startTime);
//   TimeOfDay end = _parseTime(endTime);
//
//   // Use the earliest start time and the latest end time
//   if (_startTime != null &&
//       (_startTime!.hour < start.hour ||
//           (_startTime!.hour == start.hour &&
//               _startTime!.minute < start.minute))) {
//     start = _startTime!;
//   }
//
//   if (_endTime != null &&
//       (_endTime!.hour > end.hour ||
//           (_endTime!.hour == end.hour && _endTime!.minute > end.minute))) {
//     end = _endTime!;
//   }
//
//   // Log the times for debugging
//   print('Scheduling notifications between $start and $end');
//
//   // Schedule notifications within the interval
//   for (int minute = start.minute; minute <= end.minute; minute++) {
//     _scheduleNotificationForTime(minute, start.minute);
//   }
// }
//
// TimeOfDay _parseTime(String timeStr) {
//   if (timeStr.isEmpty) {
//     throw const FormatException('Empty time string');
//   }
//
//   List<String> parts = timeStr.split(':');
//   if (parts.length != 2) {
//     throw FormatException('Invalid time format: $timeStr');
//   }
//
//   int hour = int.tryParse(parts[0]) ?? 0;
//   int minute = int.tryParse(parts[1]) ?? 0;
//
//   if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
//     throw FormatException('Invalid time values: $timeStr');
//   }
//
//   return TimeOfDay(hour: hour, minute: minute);
// }
//
// Future<void> _scheduleNotificationForTime(int hour, int minute) async {
//   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//   tz.TZDateTime scheduledDate =
//   tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
//
//   await flutterLocalNotificationsPlugin.zonedSchedule(
//     0, // Use a unique ID for each notification
//     'Hello Try 1',
//     'This is your scheduled notification.',
//     scheduledDate,
//     const NotificationDetails(
//       android: AndroidNotificationDetails(
//         '0',
//         'CHANNEL 1',
//         importance: Importance.max,
//       ),
//     ),
//     androidAllowWhileIdle: true,
//     uiLocalNotificationDateInterpretation:
//     UILocalNotificationDateInterpretation.absoluteTime,
//     matchDateTimeComponents: DateTimeComponents.time,
//   );
//   return;
// final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
// tz.TZDateTime scheduledDate =
//     tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

// Log the scheduled date for debugging
// print('Scheduling notification for: $scheduledDate');
//
// if (scheduledDate.isBefore(now)) {
//   scheduledDate = scheduledDate.add(const Duration(minutes: 1));
// }
//
// await flutterLocalNotificationsPlugin.zonedSchedule(
//   0, // Use a unique ID for each notification
//   'Hello Try 1',
//   'This is your scheduled notification.',
//   scheduledDate,
//   const NotificationDetails(
//     android: AndroidNotificationDetails(
//       '0',
//       'CHANNEL 1',
//       importance: Importance.max,
//     ),
//   ),
//   androidAllowWhileIdle: true,
//   uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//   matchDateTimeComponents: DateTimeComponents.time,
// );
// }
//
// String? _userName;
// String? _userEmail;
// String? _userPassword;
//
// Future<void> _saveUserDetails() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   setState(() {
//     _userName = prefs.getString('userName');
//     _userEmail = prefs.getString('userEmail');
//     _userPassword = prefs.getString('userPassword');
//   });
// }
//
// @override
// Widget build(BuildContext context) {
//   final data = ModalRoute.of(context)?.settings.arguments;
//
//   return Scaffold(
//     body: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/');
//               },
//               child: const Text('Log Out')),
//           const SizedBox(
//             height: 10,
//           ),
// ElevatedButton(
//     onPressed: () {
//       Navigator.pushNamed(context, '/pnotification');
//     },
//     child: const Text('Push notification page '))
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class PushNotifications {
//   static final _firebaseMessaging = FirebaseMessaging.instance;
//
//   static Future init() async {
//     await _firebaseMessaging.requestPermission(
//       provisional: true,
//       sound: true,
//       badge: true,
//       alert: true,
//       criticalAlert: true,
//       announcement: true,
//       carPlay: false,
//     );
//     final token = await _firebaseMessaging.getToken();
//     print('Device token is $token');
//   }
// }

// class NotificationPage extends StatefulWidget {
//   const NotificationPage({super.key});
//
//   @override
//   _NotificationPageState createState() => _NotificationPageState();
// }
//
// class _NotificationPageState extends State<NotificationPage> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notification Scheduler'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Center(
//             child: Text(
//               'Notifications From Web',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 20),
//             ),
//           ),
//
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:workmanager/workmanager.dart';
//
// showNotification() async {
//   // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   const AndroidInitializationSettings initializationSettingsAndroid =
//   AndroidInitializationSettings('currency');
//   const InitializationSettings initializationSettings =
//   InitializationSettings(android: initializationSettingsAndroid);
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//       onDidReceiveNotificationResponse: (e) {
//         print('object');
//       });
//   flutterLocalNotificationsPlugin.show(
//       0,
//       'Title',
//       'body',
//       NotificationDetails(
//           android: AndroidNotificationDetails(
//             'channelId',
//             'channelName',
//             icon: "currency", //add app icon here
//             importance: Importance.high,
//           )));
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
//       FlutterLocalNotificationsPlugin();
//       const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('currency');
//       const InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);
//       await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//           onDidReceiveNotificationResponse: (e) {
//             print('object');
//           });
//       flutterLocalNotificationsPlugin.show(
//           0,
//           'Title',
//           'body',
//           NotificationDetails(
//               android: AndroidNotificationDetails(
//                 'channelId',
//                 'channelName',
//                 icon: "currency", //add app icon here
//                 importance: Importance.high,
//               )));
//       print('ended');
//       return Future.value(true);
//     } catch (e) {
//       print(e);
//       return Future.value(false);
//     }
//   });
// }
//
// main() {
//   runApp(const Myapp());
// }

// class Myapp extends StatelessWidget {
//   const Myapp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'NotificationsApp',
//       home: NotificationsApp(),
//     );
//   }
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
//                     false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
//                 );
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
