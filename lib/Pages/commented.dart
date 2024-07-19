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

// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:workmanager/workmanager.dart';
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// // Function to initialize notifications
// Future<void> initializeNotifications() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//   AndroidInitializationSettings('mipmap/ic_launcher');
//
//   const InitializationSettings initializationSettings =
//   InitializationSettings(android: initializationSettingsAndroid);
//
//   // Initialize with callback for notification response
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//       onDidReceiveNotificationResponse: (notificationResponse) {
//         print('Notification action clicked');
//         if (notificationResponse.actionId == 'action_yes') {
//           print('Yes clicked');
//           // Handle Yes action
//         } else if (notificationResponse.actionId == 'action_no') {
//           print('No clicked');
//           // Handle No action
//         }
//       });
// }
//
// // Function to show notification with action buttons
// Future<void> showNotification() async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//   AndroidNotificationDetails(
//     'channelId',
//     'channelName',
//     channelDescription: 'Channel description',
//     icon: 'mipmap/ic_launcher',
//     importance: Importance.high,
//     priority: Priority.high,
//     playSound: true,
//     actions: <AndroidNotificationAction>[
//       AndroidNotificationAction(
//         'action_yes',
//         'Yes',
//         titleColor: Colors.green,
//         icon: 'mipmap/ic_launcher', // Optional icon for the action
//       ),
//       AndroidNotificationAction(
//         'action_no',
//         'No',
//         titleColor: Colors.red,
//         icon: 'mipmap/ic_launcher', // Optional icon for the action
//       ),
//     ],
//   );
//
//   const NotificationDetails platformChannelSpecifics = NotificationDetails(
//     android: androidPlatformChannelSpecifics,
//   );
//
//   await flutterLocalNotificationsPlugin.show(
//     0,
//     'Title with Actions',
//     'Body with Action Buttons',
//     platformChannelSpecifics,
//     payload: 'item_id',
//   );
//   print('Notification with buttons ended');
// }
//
// @pragma(
//     'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     try {
//       print('Workmanager task started: $task');
//       await initializeNotifications();
//       await showNotification();
//       print('Workmanager task ended');
//       return Future.value(true);
//     } catch (e) {
//       print('Workmanager error: $e');
//       return Future.value(false);
//     }
//   });
// }
//
// void scheduleNotification() {
//   Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
//   Workmanager().registerPeriodicTask(
//     "task-identifier",
//     "showNotification",
//     frequency: const Duration(minutes: 15), // Minimum allowed by Android
//     initialDelay: const Duration(seconds: 40), // Delay for the first notification
//   );
// }
//
// class NotificationScheduler extends StatefulWidget {
//   const NotificationScheduler({Key? key}) : super(key: key);
//
//   @override
//   State<NotificationScheduler> createState() => _NotificationSchedulerState();
// }
//
// class _NotificationSchedulerState extends State<NotificationScheduler> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Notification Scheduler')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 scheduleNotification();
//               },
//               child: const Text('Schedule notifications'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize notifications and request permissions
//   await initializeNotifications();
//
//   runApp(MaterialApp(home: NotificationScheduler()));
// }

//clicking isn't working , work on it
//Yes and No buttons are too small
//save details to firestore
// add the necessary actions when the buttons are hit
// if (e.actionId == 'Yes') {
// print('Yes clicked');
// Yes action
// } else if (e.actionId != 'Yes') {
// print('No clicked');
//  No action
// Workmanager().cancelByTag("Scheduled Task");
// }

/* Future<void> _showNotificationWithActions() async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    '...',
    '...',
    actions: <AndroidNotificationAction>[
      AndroidNotificationAction('id_1', 'Action 1'),
      AndroidNotificationAction('id_2', 'Action 2'),
      AndroidNotificationAction('id_3', 'Action 3'),
    ],
  );
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      0, '...', '...', notificationDetails);
} */

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:workmanager/workmanager.dart';
//
// import 'noifications_service_new.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   @override
//   void initState() {
//     super.initState();
//     _saveUserDetails();
//     Workmanager().registerOneOffTask("task-identifier", "simpleTask",
//         initialDelay: const Duration(minutes: 16));
//   }
//
//   String? _userName;
//   String? _userEmail;
//   String? _userPassword;
//
//   Future<void> _saveUserDetails() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _userName = prefs.getString('userName');
//       _userEmail = prefs.getString('userEmail');
//       _userPassword = prefs.getString('userPassword');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final data = ModalRoute.of(context)?.settings.arguments;
//
//     return Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                   onPressed: () {
//                     Workmanager()
//                         .initialize(callbackDispatcher, isInDebugMode: false);
//                     Workmanager().registerPeriodicTask('uniqueName', 'task',
//                         frequency: const Duration(minutes: 15),
//                         initialDelay: const Duration(seconds: 5),
//                         tag: 'task');
//                   },
//                   child: const Text('Schedule task')),
//               const SizedBox(
//                 height: 20,
//               ),
//               ElevatedButton(
//                   onPressed: () {
//                     Workmanager().cancelByTag('task');
//                   },
//                   child: const Text('Log cancel')),
//             ],
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           splashColor: Colors.purple,
//           onPressed: () {
//             Navigator.pushNamed(context, '/views');
//           },
//           child: const Column(
//             children: [
//               SizedBox(
//                 height: 3,
//               ),
//               Icon(Icons.remove_red_eye),
//               SizedBox(
//                 height: 3,
//               ),
//               Text('Views')
//             ],
//           ),
//         ));
//   }
// }
//
// static Future<void> showNotification(String title, String body) async {
// const NotificationDetails platformChannelSpecifics = NotificationDetails(
//   // iOS: DarwinNotificationDetails(),
//   android: AndroidNotificationDetails(
//     "channelId",
//     "channelName",
//     importance: Importance.max,
//     priority: Priority.high,
//     icon: "mipmap/ic_launcher",
//     actions: <AndroidNotificationAction>[
//       AndroidNotificationAction('Yes_Button', 'Yes'),
//       AndroidNotificationAction('No_Button', 'No'),
//     ],
//   ),
// );
// await flutterLocalNotificationsPlugin.show(
// 0, title, body, platformChannelSpecifics);
//
// await flutterLocalNotificationsPlugin.zonedSchedule(
// 0,
// 'Attendance Notice!',
// 'Are you at work?',
// _nextInstanceOfEightAM(),
// platformChannelSpecifics,
// androidAllowWhileIdle: true,
// uiLocalNotificationDateInterpretation:
// UILocalNotificationDateInterpretation.absoluteTime,
// matchDateTimeComponents: DateTimeComponents.time,
// );
// }
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class ViewsPage extends StatelessWidget {
//   const ViewsPage({super.key});
//
//   Future<List<Map<String, dynamic>>> _fetchUserRecords(String email) async {
//     DateTime now = DateTime.now();
//     int currentMonth = now.month;
//     int currentYear = now.year;
//     String currentDay =
//         DateFormat('EEEE').format(now); // Get the day of the week
//     String currentDayNumber =
//         DateFormat('d').format(now); // Get the day number of the month
//
//     try {
//       print('Fetching records for email: $email');
//
//       // Fetch records from the four collections
//       final Future<QuerySnapshot> yesInsideRecordsSnapshot = FirebaseFirestore
//           .instance
//           .collection('Records')
//           .doc('Starting_time')
//           .collection(
//               '$currentDayNumber-$currentMonth-$currentYear {yes_Inside-$currentDay}')
//           .where('userEmail', isEqualTo: email)
//           .get();
//
//       final Future<QuerySnapshot> yesOutsideRecordsSnapshot = FirebaseFirestore
//           .instance
//           .collection('Records')
//           .doc('Starting_time')
//           .collection(
//               '$currentDayNumber-$currentMonth-$currentYear {yes_Outside-$currentDay}')
//           .where('userEmail', isEqualTo: email)
//           .get();
//
//       final Future<QuerySnapshot> noRecordsSnapshot = FirebaseFirestore.instance
//           .collection('Records')
//           .doc('Starting_time')
//           .collection(
//               '$currentDayNumber-$currentMonth-$currentYear {no-$currentDay}')
//           .where('userEmail', isEqualTo: email)
//           .get();
//
//       final Future<QuerySnapshot> noOptionSelectedRecordsSnapshot =
//           FirebaseFirestore.instance
//               .collection('Records')
//               .doc('Starting_time')
//               .collection(
//                   '$currentDayNumber-$currentMonth-$currentYear {no_option_selected-$currentDay}')
//               .where('userEmail', isEqualTo: email)
//               .get();
//
//       // Wait for all the queries to complete and combine the results
//       final List<QuerySnapshot> snapshots = await Future.wait([
//         yesInsideRecordsSnapshot,
//         yesOutsideRecordsSnapshot,
//         noRecordsSnapshot,
//         noOptionSelectedRecordsSnapshot,
//       ]);
//
//       // Combine the records from all the snapshots
//       final List<Map<String, dynamic>> allRecords = [
//         for (final snapshot in snapshots)
//           ...snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>),
//       ];
//
//       return allRecords;
//     } catch (e) {
//       print('Error fetching records: $e');
//       return [];
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     User? user = FirebaseAuth.instance.currentUser;
//     String? email = user?.email;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Records'),
//       ),
//       body: email == null
//           ? const Center(child: Text('No user signed in'))
//           : FutureBuilder<List<Map<String, dynamic>>>(
//               future: _fetchUserRecords(email),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('No records found'));
//                 } else {
//                   List<Map<String, dynamic>> records = snapshot.data!;
//                   return ListView.builder(
//                     itemCount: records.length,
//                     itemBuilder: (context, index) {
//                       var record = records[index];
//                       return ListTile(
//                         title: Text('User: ${record['userName']}'),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Email: ${record['userEmail']}'),
//                             Text('Status: ${record['action']}'),
//                             Text('Time: ${record['timestamp'].toDate()}'),
//                             // Text('Day of Week: ${record['dayOfWeek']}'),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//     );
//   }
// }

// import 'dart:convert';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ViewsPage extends StatelessWidget {
//   const ViewsPage({super.key});
//
//   Map<String, dynamic> convertTimestampToString(Map<String, dynamic> record) {
//     record['timestamp'] =
//         (record['timestamp'] as Timestamp).toDate().toIso8601String();
//     return record;
//   }
//
//   Map<String, dynamic> convertStringToTimestamp(Map<String, dynamic> record) {
//     record['timestamp'] = DateTime.parse(record['timestamp']);
//     return record;
//   }
//
//   Future<void> _saveRecordsToSharedPreferences(
//       List<Map<String, dynamic>> records) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<Map<String, dynamic>> convertedRecords =
//         records.map(convertTimestampToString).toList();
//     String jsonString = jsonEncode(convertedRecords);
//     print('Saving records to SharedPreferences: $jsonString');
//     await prefs.setString('userRecords', jsonString);
//   }
//
//   Future<List<Map<String, dynamic>>> _loadRecordsFromSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? jsonString = prefs.getString('userRecords');
//     print('Loaded records from SharedPreferences: $jsonString');
//     if (jsonString == null) {
//       return [];
//     } else {
//       List<dynamic> jsonList = jsonDecode(jsonString);
//       return jsonList
//           .map((item) =>
//               convertStringToTimestamp(Map<String, dynamic>.from(item)))
//           .toList();
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> _fetchUserRecords(String email) async {
//     DateTime now = DateTime.now();
//     int currentMonth = now.month;
//     int currentYear = now.year;
//     String currentDayNumber =
//         DateFormat('d').format(now); // Get the day number of the month
//
//     try {
//       print('Fetching records for email: $email');
//
//       // Fetch records from the four collections
//       final yesInsideRecordsSnapshot = FirebaseFirestore.instance
//           .collection('Records')
//           .doc('Starting_time')
//           .collection(
//               '$currentDayNumber-$currentMonth-$currentYear {yes_Inside}')
//           .where('userEmail', isEqualTo: email)
//           .get();
//
//       final yesOutsideRecordsSnapshot = FirebaseFirestore.instance
//           .collection('Records')
//           .doc('Starting_time')
//           .collection(
//               '$currentDayNumber-$currentMonth-$currentYear {yes_Outside}')
//           .where('userEmail', isEqualTo: email)
//           .get();
//
//       final noRecordsSnapshot = FirebaseFirestore.instance
//           .collection('Records')
//           .doc('Starting_time')
//           .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
//           .where('userEmail', isEqualTo: email)
//           .get();
//
//       final noOptionSelectedRecordsSnapshot = FirebaseFirestore.instance
//           .collection('Records')
//           .doc('Starting_time')
//           .collection(
//               '$currentDayNumber-$currentMonth-$currentYear {no_option_selected}')
//           .where('userEmail', isEqualTo: email)
//           .get();
//
//       // Wait for all the queries to complete and combine the results
//       final snapshots = await Future.wait([
//         yesInsideRecordsSnapshot,
//         yesOutsideRecordsSnapshot,
//         noRecordsSnapshot,
//         noOptionSelectedRecordsSnapshot,
//       ]);
//
//       print('Snapshots retrieved: ${snapshots.length}');
//       snapshots.forEach((snapshot) {
//         print('Snapshot size: ${snapshot.size}');
//       });
//
//       // Combine the records from all the snapshots
//       final allRecords = <Map<String, dynamic>>[
//         for (final snapshot in snapshots)
//           ...snapshot.docs.map((doc) {
//             final data = doc.data() as Map<String, dynamic>;
//             print('Document data: $data');
//             data['date'] =
//                 DateFormat('d-M-yyyy').format(doc['timestamp'].toDate());
//             data['dayOfWeek'] =
//                 DateFormat('EEEE').format(doc['timestamp'].toDate());
//             return data;
//           }),
//       ];
//
//       print('All records: $allRecords');
//
//       // Save records to SharedPreferences
//       await _saveRecordsToSharedPreferences(allRecords);
//
//       return allRecords;
//     } catch (e) {
//       print('Error fetching records: $e');
//       return [];
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     User? user = FirebaseAuth.instance.currentUser;
//     String? email = user?.email;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Records'),
//       ),
//       body: email == null
//           ? const Center(child: Text('No user signed in'))
//           : FutureBuilder<List<Map<String, dynamic>>>(
//               future: _loadRecordsFromSharedPreferences()
//                   .then((cachedRecords) async {
//                 if (cachedRecords.isNotEmpty) {
//                   print('Displaying cached records');
//                   return cachedRecords;
//                 } else {
//                   print('No cached records found, fetching from Firestore');
//                   return await _fetchUserRecords(email);
//                 }
//               }),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('No records found'));
//                 } else {
//                   List<Map<String, dynamic>> records = snapshot.data!;
//                   Map<String, List<Map<String, dynamic>>> groupedRecords = {};
//
//                   for (var record in records) {
//                     String dateKey = '${record['dayOfWeek']} ${record['date']}';
//                     if (groupedRecords[dateKey] == null) {
//                       groupedRecords[dateKey] = [];
//                     }
//                     groupedRecords[dateKey]!.add(record);
//                   }
//
//                   return ListView.builder(
//                     itemCount: groupedRecords.keys.length,
//                     itemBuilder: (context, index) {
//                       String dateKey = groupedRecords.keys.elementAt(index);
//                       List<Map<String, dynamic>> dateRecords =
//                           groupedRecords[dateKey]!;
//
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               dateKey,
//                               style: const TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           ...dateRecords.map((record) {
//                             return ListTile(
//                               title: Text('User: ${record['userName']}'),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Email: ${record['userEmail']}'),
//                                   Text('Status: ${record['action']}'),
//                                   Text('Time: ${record['timestamp']}'),
//                                 ],
//                               ),
//                             );
//                           }).toList(),
//                         ],
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//     );
//   }
// }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:workmanager/workmanager.dart';
//
// import 'noifications_service_new.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int yesInsideCount = 0;
//   int yesOutsideCount = 0;
//   int noCount = 0;
//   bool isLoading = true;
//
//   Position? _currentPosition;
//   String? _currentAddress;
//
//   @override
//   void initState() {
//     super.initState();
//     _saveUserDetails();
//     _initializeWorkManager();
//     NotificationService.showNotification(
//         'Attendance Notice', 'Are you at work?');
//     _getCurrentLocation();
//     fetchRecords();
//   }
//
//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _currentPosition = position;
//     });
//
//     // Use Geocoding to get the address
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(position.latitude, position.longitude);
//     Placemark place = placemarks[0];
//     setState(() {
//       _currentAddress =
//           "${place.locality}, ${place.postalCode}, ${place.country}";
//     });
//   }
//
//   Future<void> fetchRecords() async {
//     try {
//       DateTime now = DateTime.now();
//       int currentMonth = now.month;
//       int currentYear = now.year;
//       String currentDay =
//           DateFormat('EEEE').format(now); // Get the day of the week
//       String currentDayNumber =
//           DateFormat('d').format(now); // Get the day number of the month
//
//       // Fetching records for the current month and year
//       QuerySnapshot yesRecordsSnapshot = await FirebaseFirestore.instance
//           .collection('Records')
//           .doc('Starting_time')
//           .collection(
//               '$currentDayNumber-$currentMonth-$currentYear {yes_Inside-$currentDay}')
//           .get();
//
//       QuerySnapshot yesOutsideRecordsSnapshot = await FirebaseFirestore.instance
//           .collection('Records')
//           .doc('Starting_time')
//           .collection(
//               '$currentDayNumber-$currentMonth-$currentYear {yes_Outside-$currentDay}')
//           .get();
//
//       QuerySnapshot noRecordsSnapshot = await FirebaseFirestore.instance
//           .collection('Records')
//           .doc('Starting_time')
//           .collection(
//               '$currentDayNumber-$currentMonth-$currentYear {no-$currentDay}')
//           .get();
//
//       int tempYesInsideCount = 0;
//       int tempYesOutsideCount = 0;
//       int tempNoCount = 0;
//
// // Processing Yes records
//       for (var doc in yesRecordsSnapshot.docs) {
//         var data = doc.data() as Map<String, dynamic>;
//         switch (data['action']) {
//           case 'Yes I am at work':
//             tempYesInsideCount++;
//             break;
//           case 'No I am not at work (Outside)':
//             tempYesOutsideCount++;
//             break;
//           case 'No I am not at work':
//             tempNoCount++;
//             break;
//           default:
//             // Handle unexpected cases if necessary
//             break;
//         }
//       }
//
// // Processing No records
//       tempNoCount += noRecordsSnapshot.size;
//
//       setState(() {
//         yesInsideCount = tempYesInsideCount;
//         yesOutsideCount = tempYesOutsideCount;
//         noCount = tempNoCount;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error fetching records: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Widget _buildIcon(String title) {
//     IconData iconData;
//     Color color;
//
//     switch (title) {
//       case 'Yes (Inside)':
//         iconData = Icons.check_circle;
//         color = Colors.white;
//         break;
//       case 'Yes (Outside)':
//         iconData = Icons.location_off;
//         color = Colors.white;
//         break;
//       case 'No':
//         iconData = Icons.cancel;
//         color = Colors.white;
//         break;
//       default:
//         iconData = Icons.help;
//         color = Colors.grey;
//     }
//
//     return Icon(iconData, color: color, size: 24);
//   }
//
//   Future<void> _initializeWorkManager() async {
//     Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
//     Workmanager().registerPeriodicTask(
//       'dailyNotification',
//       'dailyNotificationTask',
//       frequency: const Duration(hours: 24),
//       initialDelay: const Duration(minutes: 1),
//       inputData: {},
//     );
//   }
//
//   String? _userName;
//   String? _userEmail;
//   String? _userPassword;
//
//   Future<void> _saveUserDetails() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _userName = prefs.getString('userName');
//       _userEmail = prefs.getString('userEmail');
//       _userPassword = prefs.getString('userPassword');
//     });
//   }
//
//   Widget _buildLegendItem(Color color, String text) {
//     return Row(
//       children: [
//         Container(
//           width: 16,
//           height: 16,
//           color: color,
//         ),
//         const SizedBox(width: 8),
//         Text(text),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings),
//             onPressed: () {
//               Navigator.pushNamed(context, '/settings');
//             },
//           ),
//         ],
//         title: const Text('Home Page'),
//       ),
//       body: isLoading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   if (_currentPosition != null && _currentAddress != null)
//                     Column(
//                       children: [
//                         Text(
//                           'Coordinates: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Location: $_currentAddress',
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                         const SizedBox(height: 16),
//                       ],
//                     ),
//                   Center(
//                     child: Container(
//                       height: 300, // Adjust the height of the container
//                       width: 300,
//                       child: PieChart(
//                         PieChartData(
//                           sections: [
//                             PieChartSectionData(
//                               color: Colors.green,
//                               value: yesInsideCount.toDouble(),
//                               badgeWidget: _buildIcon('Yes (Inside)'),
//                               badgePositionPercentageOffset: 0.7,
//                               radius: 60,
//                             ),
//                             PieChartSectionData(
//                               color: Colors.orange,
//                               value: yesOutsideCount.toDouble(),
//                               badgeWidget: _buildIcon('Yes (Outside)'),
//                               badgePositionPercentageOffset: 0.5,
//                               radius: 50,
//                             ),
//                             PieChartSectionData(
//                               color: Colors.red,
//                               value: noCount.toDouble(),
//                               badgeWidget: _buildIcon('No'),
//                               badgePositionPercentageOffset: 0.5,
//                               radius: 50,
//                             ),
//                           ],
//                           centerSpaceRadius: 50,
//                           sectionsSpace: 2,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   _buildLegendItem(Colors.green, 'Yes (Inside)'),
//                   _buildLegendItem(Colors.orange, 'Yes (Outside)'),
//                   _buildLegendItem(Colors.red, 'No'),
//                 ],
//               ),
//             ),
//       floatingActionButton: FloatingActionButton(
//         splashColor: Colors.purple,
//         onPressed: () {
//           Navigator.pushNamed(context, '/views');
//         },
//         child: const Column(
//           children: [
//             SizedBox(
//               height: 3,
//             ),
//             Icon(Icons.remove_red_eye),
//             SizedBox(
//               height: 3,
//             ),
//             Text('Views')
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ThemeProvider with ChangeNotifier {
//   bool _isDarkTheme = false;
//
//   bool get isDarkTheme => _isDarkTheme;
//
//   void toggleTheme() {
//     _isDarkTheme = !_isDarkTheme;
//     notifyListeners();
//   }
// }
// // void callbackDispatcher() {
// //   Workmanager().executeTask((task, inputData) {
// //     // Your background task code here
// //     return Future.value(true);
// //   });
// // }
// import 'dart:convert';
//
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:workmanager/workmanager.dart';
//
// import 'noifications_service_new.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int yesInsideCount = 0;
//   int yesOutsideCount = 0;
//   int noCount = 0;
//   bool isLoading = true;
//
//   final int _additionalTextIndex = 0;
//
//   Position? _currentPosition;
//   String? _currentAddress;
//
//   List<String> additionalTexts = [
//     'Additional Text 1',
//     'Additional Text 2',
//     'Additional Text 3',
//     'Additional Text 4',
//     'Additional Text 5',
//     'Additional Text 6',
//     'Additional Text 7',
//     'Additional Text 8',
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _saveUserDetails();
//     _initializeWorkManager();
//     NotificationService.showNotification(
//         'Attendance Notice', 'Are you at work?');
//     _getCurrentLocation();
//     _loadRecordsFromSharedPreferences().then((records) {
//       _updateCounts(records);
//       setState(() {
//         isLoading = false;
//       });
//     });
//   }
//
//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _currentPosition = position;
//     });
//
//     // Use Geocoding to get the address
//     List<Placemark> placemarks =
//     await placemarkFromCoordinates(position.latitude, position.longitude);
//     Placemark place = placemarks[0];
//     setState(() {
//       _currentAddress =
//       "${place.locality}, ${place.postalCode}, ${place.country}";
//     });
//   }
//
//   Future<void> _initializeWorkManager() async {
//     Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
//     Workmanager().registerPeriodicTask(
//       'dailyNotification',
//       'dailyNotificationTask',
//       frequency: const Duration(hours: 24),
//       initialDelay: const Duration(minutes: 1),
//       inputData: {},
//     );
//   }
//
//   String? _userName;
//   String? _userEmail;
//   String? _userPassword;
//
//   Future<void> _saveUserDetails() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _userName = prefs.getString('userName');
//       _userEmail = prefs.getString('userEmail');
//       _userPassword = prefs.getString('userPassword');
//     });
//   }
//
//   Future<List<Map<String, dynamic>>> _loadRecordsFromSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? jsonString = prefs.getString('userRecords');
//     if (jsonString == null) {
//       return [];
//     } else {
//       List<dynamic> jsonList = jsonDecode(jsonString);
//       return jsonList.map((item) => Map<String, dynamic>.from(item)).toList();
//     }
//   }
//
//   void _updateCounts(List<Map<String, dynamic>> records) {
//     int tempYesInsideCount = 0;
//     int tempYesOutsideCount = 0;
//     int tempNoCount = 0;
//
//     for (var record in records) {
//       switch (record['action']) {
//         case 'Yes I am at work':
//           tempYesInsideCount++;
//           break;
//         case 'No I am not at work (Outside)':
//           tempYesOutsideCount++;
//           break;
//         case 'No I am not at work':
//           tempNoCount++;
//           break;
//         default:
//         // Handle unexpected cases if necessary
//           break;
//       }
//     }
//
//     setState(() {
//       yesInsideCount = tempYesInsideCount;
//       yesOutsideCount = tempYesOutsideCount;
//       noCount = tempNoCount;
//     });
//   }
//
//   Widget _buildIcon(String title) {
//     IconData iconData;
//     Color color;
//
//     switch (title) {
//       case 'Yes (Inside)':
//         iconData = Icons.check_circle;
//         color = Colors.white;
//         break;
//       case 'Yes (Outside)':
//         iconData = Icons.location_off;
//         color = Colors.white;
//         break;
//       case 'No':
//         iconData = Icons.cancel;
//         color = Colors.white;
//         break;
//       default:
//         iconData = Icons.help;
//         color = Colors.grey;
//     }
//
//     return Icon(iconData, color: color, size: 24);
//   }
//
//   Widget _buildLegendItem(Color color, String text) {
//     return Row(
//       children: [
//         Container(
//           width: 16,
//           height: 16,
//           color: color,
//         ),
//         const SizedBox(width: 8),
//         Text(text),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings),
//             onPressed: () {
//               Navigator.pushNamed(context, '/settings');
//             },
//           ),
//         ],
//         title: const Text('Home Page'),
//       ),
//       body: isLoading
//           ? const Center(
//         child: CircularProgressIndicator(),
//       )
//           : SingleChildScrollView(
//         // Wrap your Column with SingleChildScrollView
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               if (_currentPosition != null && _currentAddress != null)
//                 Column(
//                   children: [
//                     Text(
//                       'Coordinates: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Location: $_currentAddress',
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(height: 16),
//                   ],
//                 ),
//               Center(
//                 child: Container(
//                   height: 300, // Adjust the height of the container
//                   width: 300,
//                   child: PieChart(
//                     PieChartData(
//                       sections: [
//                         PieChartSectionData(
//                           color: Colors.green,
//                           value: yesInsideCount.toDouble(),
//                           badgeWidget: _buildIcon('Yes (Inside)'),
//                           badgePositionPercentageOffset: 0.7,
//                           radius: 60,
//                         ),
//                         PieChartSectionData(
//                           color: Colors.orange,
//                           value: yesOutsideCount.toDouble(),
//                           badgeWidget: _buildIcon('Yes (Outside)'),
//                           badgePositionPercentageOffset: 0.5,
//                           radius: 50,
//                         ),
//                         PieChartSectionData(
//                           color: Colors.red,
//                           value: noCount.toDouble(),
//                           badgeWidget: _buildIcon('No'),
//                           badgePositionPercentageOffset: 0.5,
//                           radius: 50,
//                         ),
//                       ],
//                       centerSpaceRadius: 50,
//                       sectionsSpace: 2,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Column(
//                 children: [
//                   _buildLegendItem(Colors.green, 'Yes (Inside)'),
//                   _buildLegendItem(Colors.orange, 'Yes (Outside)'),
//                   _buildLegendItem(Colors.red, 'No'),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               const Text('CLASSIE'),
//               const SizedBox(height: 16),
//               if (_additionalTextIndex < additionalTexts.length)
//                 Text(additionalTexts[_additionalTextIndex]),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         splashColor: Colors.purple,
//         onPressed: () {
//           Navigator.pushNamed(context, '/views');
//         },
//         child: const Column(
//           children: [
//             SizedBox(
//               height: 3,
//             ),
//             Icon(Icons.remove_red_eye),
//             SizedBox(
//               height: 3,
//             ),
//             Text('Views')
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ThemeProvider with ChangeNotifier {
//   bool _isDarkTheme = false;
//
//   bool get isDarkTheme => _isDarkTheme;
//
//   void toggleTheme() {
//     _isDarkTheme = !_isDarkTheme;
//     notifyListeners();
//   }
// }
//
// // void callbackDispatcher() {
// //   Workmanager().executeTask((task, inputData) {
// //     // Your background task code here
// //     return Future.value(true);
// //   });
// // }

//
// class EightAMNotificationService {
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   static Future<void> onActionReceived(receivedAction) async {
//     // Get the current month and year
//     try {
//       await Firebase.initializeApp();
//
//       // Retrieve the user's name from shared preferences
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? userName = prefs.getString('UserName') ?? 'Unknown User';
//       String? userEmail = prefs.getString('userEmail') ?? 'Unknown Email';
//
//       DateTime now = DateTime.now();
//       int currentMonth = now.month;
//       int currentYear = now.year;
//       String currentDay =
//           DateFormat('EEEE').format(now); // Get the day of the week
//       String currentDayNumber =
//           DateFormat('d').format(now); // Get the day number of the month
//
//       // Check the actionId to determine which button was clicked
//       switch (receivedAction.actionId) {
//         case 'Yes_Button':
//           // Get the user's current position
//           Position position = await Geolocator.getCurrentPosition(
//             desiredAccuracy: LocationAccuracy.high,
//           );
//           // Define the target coordinate and radius
//           double targetLatitude = 5.6129311;
//           double targetLongitude = -0.1823302;
//           double radius = 100; // in meters
//
//           double distance = Geolocator.distanceBetween(
//             position.latitude,
//             position.longitude,
//             targetLatitude,
//             targetLongitude,
//           );
//
//           // Check if the user is within the specified radius
//           if (distance <= radius) {
//             // Save "Yes im at work" with the current time to Firestore
//             await FirebaseFirestore.instance
//                 .collection('Records')
//                 .doc('Starting_time')
//                 .collection(
//                     '$currentDayNumber-$currentMonth-$currentYear {yes_Inside}')
//                 .add({
//               'timestamp': Timestamp.now(),
//               'action': 'Yes I am at work',
//               'dayOfWeek': currentDay,
//               'userEmail': userEmail ?? 'Unknown',
//               'userName': userName ?? 'Unknown',
//             });
//             print('Yes button clicked inside radius');
//           } else {
//             // Save "Yes outside the geolocator radius" with the current user's time to Firestore
//             await FirebaseFirestore.instance
//                 .collection('Records')
//                 .doc('Starting_time')
//                 .collection(
//                     '$currentDayNumber-$currentMonth-$currentYear {yes_Outside}')
//                 .add({
//               'timestamp': Timestamp.now(),
//               'action': 'No I am not at work(Outside)',
//               'dayOfWeek': currentDay,
//               'userEmail': userEmail ?? 'Unknown',
//               'userName': userName ?? 'Unknown',
//             });
//             print('Yes button clicked outside radius');
//           }
//           break;
//         case 'No_Button':
//           // Save "No action" with the current users time to Firestore
//           await FirebaseFirestore.instance
//               .collection('Records')
//               .doc('Starting_time')
//               .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
//               .add({
//             'timestamp': Timestamp.now(),
//             'action': 'No I am not at work',
//             'dayOfWeek': currentDay,
//             'userEmail': userEmail ?? 'Unknown',
//             'userName': userName ?? 'Unknown',
//           });
//           print('No button clicked');
//           // await FirebaseFirestore.instance
//           //     .collection('Records')
//           //     .doc('Starting_time')
//           //     .collection(
//           //         '$currentDayNumber-$currentMonth-$currentYear {no_option_selected-$currentDay}')
//           //     .add({
//           //   'timestamp': Timestamp.now(),
//           //   'action': 'No im not at work',
//           //   'dayOfWeek': currentDay,
//           //   'userEmail': userEmail ?? 'Unknown',
//           //   'userName': userName ?? 'Unknown',
//           // });
//           break;
//         default:
//           print('Other action or notification clicked');
//       }
//     } catch (e) {
//       print('Error in onActionReceive: $e');
//     }
//   }
//
//   static Future<void> onDidReceiveNotificationResponse(
//       NotificationResponse notificationResponse) async {}
//
//   static Future<void> init() async {
//     const AndroidInitializationSettings androidInitializationSettings =
//         AndroidInitializationSettings("mipmap/ic_launcher");
//
//     const DarwinInitializationSettings iOSInitializationSettings =
//         DarwinInitializationSettings();
//
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: androidInitializationSettings,
//       iOS: iOSInitializationSettings,
//     );
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveBackgroundNotificationResponse: onActionReceived,
//         onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
//
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestNotificationsPermission();
//
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestExactAlarmsPermission();
//   }
//
//   static Future<void> scheduleNotificationAtEightAM() async {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduledDate =
//         tz.TZDateTime(tz.local, now.year, now.month, now.day, 8);
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: AndroidNotificationDetails(
//         "channelId",
//         "channelName",
//         importance: Importance.max,
//         priority: Priority.high,
//         icon: "mipmap/ic_launcher",
//         actions: <AndroidNotificationAction>[
//           AndroidNotificationAction('Yes_Button', 'Yes'),
//           AndroidNotificationAction('No_Button', 'No'),
//         ],
//       ),
//     );
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'Attendance Notice!',
//       'Are you at work?',
//       scheduledDate,
//       platformChannelSpecifics,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }
//
//   static tz.TZDateTime _nextInstanceOfEightAM() {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduledDate =
//         tz.TZDateTime(tz.local, now.year, now.month, now.day, 8);
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//     return scheduledDate;
//   }
// }

//
// class FivePMNotificationService {
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   static Future<void> onActionReceived(receivedAction) async {
//     // Get the current month and year
//     try {
//       await Firebase.initializeApp();
//
//       // Retrieve the user's name from shared preferences
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? userName = prefs.getString('UserName') ?? 'Unknown User';
//       String? userEmail = prefs.getString('userEmail') ?? 'Unknown Email';
//
//       DateTime now = DateTime.now();
//       int currentMonth = now.month;
//       int currentYear = now.year;
//       String currentDay =
//           DateFormat('EEEE').format(now); // Get the day of the week
//       String currentDayNumber =
//           DateFormat('d').format(now); // Get the day number of the month
//
//       // Check the actionId to determine which button was clicked
//       switch (receivedAction.actionId) {
//         case 'Yes_Button':
//           // Get the user's current position
//           Position position = await Geolocator.getCurrentPosition(
//             desiredAccuracy: LocationAccuracy.high,
//           );
//           // Define the target coordinate and radius
//           double targetLatitude = 5.6129311;
//           double targetLongitude = -0.1823302;
//           double radius = 100; // in meters
//
//           double distance = Geolocator.distanceBetween(
//             position.latitude,
//             position.longitude,
//             targetLatitude,
//             targetLongitude,
//           );
//
//           // Check if the user is within the specified radius
//           if (distance <= radius) {
//             // Save "Yes im at work" with the current time to Firestore
//             // await FirebaseFirestore.instance
//             //     .collection('Records')
//             //     .doc('Starting_time')
//             //     .collection(
//             //     '$currentDayNumber-$currentMonth-$currentYear {yes_Inside}')
//             //     .add({
//             //   'timestamp': Timestamp.now(),
//             //   'action': 'Yes I am at work',
//             //   'dayOfWeek': currentDay,
//             //   'userEmail': userEmail ?? 'Unknown',
//             //   'userName': userName ?? 'Unknown',
//             // });
//             print('Yes button clicked inside radius');
//           } else {
//             // Save "Yes outside the geolocator radius" with the current user's time to Firestore
//             // await FirebaseFirestore.instance
//             //     .collection('Records')
//             //     .doc('Starting_time')
//             //     .collection(
//             //     '$currentDayNumber-$currentMonth-$currentYear {yes_Outside}')
//             //     .add({
//             //   'timestamp': Timestamp.now(),
//             //   'action': 'No I am not at work(Outside)',
//             //   'dayOfWeek': currentDay,
//             //   'userEmail': userEmail ?? 'Unknown',
//             //   'userName': userName ?? 'Unknown',
//             // });
//             print('Yes button clicked outside radius');
//           }
//           break;
//         case 'No_Button':
//           // Save "No action" with the current users time to Firestore
//           //   await FirebaseFirestore.instance
//           //       .collection('Records')
//           //       .doc('Starting_time')
//           //       .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
//           //       .add({
//           //     'timestamp': Timestamp.now(),
//           //     'action': 'No I am not at work',
//           //     'dayOfWeek': currentDay,
//           //     'userEmail': userEmail ?? 'Unknown',
//           //     'userName': userName ?? 'Unknown',
//           //   });
//           print('No button clicked');
//           // await FirebaseFirestore.instance
//           //     .collection('Records')
//           //     .doc('Starting_time')
//           //     .collection(
//           //         '$currentDayNumber-$currentMonth-$currentYear {no_option_selected-$currentDay}')
//           //     .add({
//           //   'timestamp': Timestamp.now(),
//           //   'action': 'No im not at work',
//           //   'dayOfWeek': currentDay,
//           //   'userEmail': userEmail ?? 'Unknown',
//           //   'userName': userName ?? 'Unknown',
//           // });
//           break;
//         default:
//           print('Other action or notification clicked');
//       }
//     } catch (e) {
//       print('Error in onActionReceive: $e');
//     }
//   }
//
//   static Future<void> onDidReceiveNotificationResponse(
//       NotificationResponse notificationResponse) async {}
//
//   static Future<void> init() async {
//     const AndroidInitializationSettings androidInitializationSettings =
//         AndroidInitializationSettings("mipmap/ic_launcher");
//
//     const DarwinInitializationSettings iOSInitializationSettings =
//         DarwinInitializationSettings();
//
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: androidInitializationSettings,
//       iOS: iOSInitializationSettings,
//     );
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveBackgroundNotificationResponse: onActionReceived,
//         onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
//
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestNotificationsPermission();
//
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestExactAlarmsPermission();
//   }
//
//   static Future<void> scheduleNotificationAtFivePM() async {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduledDate = tz.TZDateTime(
//         tz.local, now.year, now.month, now.day, 17, 30); // 17:00 or 5 PM
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: AndroidNotificationDetails(
//         "channelId_five_pm",
//         "channelName_five_pm",
//         importance: Importance.max,
//         priority: Priority.high,
//         icon: "mipmap/ic_launcher",
//         actions: <AndroidNotificationAction>[
//           AndroidNotificationAction('Yes_Button', 'Yes'),
//           AndroidNotificationAction('No_Button', 'No'),
//         ],
//       ),
//     );
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       1, // Unique ID for 5 PM notification
//       'Attendance Notice ',
//       'Have you closed from work? ',
//       scheduledDate,
//       platformChannelSpecifics,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }
// }
// static Future<void> onActionReceived(receivedAction) async {
//   // Get the current month and year
//   try {
//     await Firebase.initializeApp();
//
//     // Retrieve the user's name from shared preferences
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userName = prefs.getString('UserName') ?? 'Unknown User';
//     String? userEmail = prefs.getString('userEmail') ?? 'Unknown Email';
//
//     DateTime now = DateTime.now();
//     int currentMonth = now.month;
//     int currentYear = now.year;
//     String currentDay =
//         DateFormat('EEEE').format(now); // Get the day of the week
//     String currentDayNumber =
//         DateFormat('d').format(now); // Get the day number of the month
//
//     // Check the actionId to determine which button was clicked
//     switch (receivedAction.actionId) {
//       case 'Yes_Button_Id':
//         Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//         );
//         // Define the target coordinate and radius
//         double targetLatitude = 5.6129311;
//         double targetLongitude = -0.1823302;
//         double radius = 100; // in meters
//
//         double distance = Geolocator.distanceBetween(
//           position.latitude,
//           position.longitude,
//           targetLatitude,
//           targetLongitude,
//         );
//
//         FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//         try {
//           await firestore
//               .collection('Records_Out')
//               .doc('Ending_time')
//               .collection(
//                   '$currentDayNumber-$currentMonth-$currentYear {Yes_Button_Id}')
//               .add({
//             'timestamp': Timestamp.now(),
//             'action': 'Yes I Have closed',
//             'dayOfWeek': currentDay,
//             'userEmail': userEmail ?? 'Unknown',
//             'userName': userName ?? 'Unknown',
//           });
//         } catch (e) {
//           print('Error adding collection: $e');
//         }
//
//         print('Yes button clicked');
//
//         break;
//
//       case 'No_Button_Id':
//         try {
//           // Save "No action" with the current users time to Firestore
//           await FirebaseFirestore.instance
//               .collection('Records_Out')
//               .doc('Ending_time')
//               .collection(
//                   '$currentDayNumber-$currentMonth-$currentYear {No_Button_Id}')
//               .add({
//             'timestamp': Timestamp.now(),
//             'action': 'No I Have not closed',
//             'dayOfWeek': currentDay,
//             'userEmail': userEmail ?? 'Unknown',
//             'userName': userName ?? 'Unknown',
//           });
//         } catch (e) {
//           print('Error :$e');
//         }
//         print('No button clicked');
//         break;
//       default:
//         try {
//           print('Other action or notification clicked');
//         } catch (e) {
//           print('Error:$e');
//         }
//     }
//   } catch (e) {
//     print('Error in onActionReceive: $e');
//   }
// }

//   static Future<void> showNotification(String title, String body) async {
//     tz.TZDateTime _notificationAt8AM() {
//       final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//       tz.TZDateTime scheduledDate =
//           tz.TZDateTime(tz.local, now.year, now.month, now.day, 9, 35);
//       if (scheduledDate.isBefore(now)) {
//         scheduledDate = scheduledDate.add(const Duration(days: 1));
//       }
//       return scheduledDate;
//     }
//
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       // iOS: DarwinNotificationDetails(),
//       android: AndroidNotificationDetails(
//         "channelId",
//         "channelName",
//         importance: Importance.max,
//         priority: Priority.high,
//         icon: "mipmap/ic_launcher",
//         actions: <AndroidNotificationAction>[
//           AndroidNotificationAction('Yes_Button', 'Yes'),
//           AndroidNotificationAction('No_Button', 'No'),
//         ],
//       ),
//     );
//     await flutterLocalNotificationsPlugin.show(
//         0, title, body, platformChannelSpecifics);
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'Attendance Notice!',
//       'Are you at work?',
//       _notificationAt8AM(),
//       platformChannelSpecifics,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }
//
//   static Future<void> showNotificationAt5(String title, String body) async {
//     tz.TZDateTime _notificationAt8AM() {
//       final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//       tz.TZDateTime scheduledDate =
//           tz.TZDateTime(tz.local, now.year, now.month, now.day, 16, 30);
//       if (scheduledDate.isBefore(now)) {
//         scheduledDate = scheduledDate.add(const Duration(days: 1));
//       }
//       return scheduledDate;
//     }
//
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       // iOS: DarwinNotificationDetails(),
//       android: AndroidNotificationDetails(
//         "channelId",
//         "channelName",
//         importance: Importance.max,
//         priority: Priority.high,
//         icon: "mipmap/ic_launcher",
//         actions: <AndroidNotificationAction>[
//           AndroidNotificationAction('Yes_Button', 'Yes'),
//           AndroidNotificationAction('No_Button', 'No'),
//         ],
//       ),
//     );
//     await flutterLocalNotificationsPlugin.show(
//         0, title, body, platformChannelSpecifics);
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'Attendance Notice!',
//       'Have you closed?',
//       _notificationAt8AM(),
//       platformChannelSpecifics,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }
//
//   Future<void> scheduleDailyNotifications() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool? isNotificationScheduled =
//         prefs.getBool('isScheduledNotificationActive') ?? false;
//
//     if (!isNotificationScheduled) {
//       await showNotification('Attendance Notice', 'Are you at work?');
//       await prefs.setBool('isScheduledNotificationActive', true);
//     }
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//             'daily_notification_channel_id', 'Daily Notifications',
//             importance: Importance.max, priority: Priority.max);
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//   }
// }
//   static Future<void> showNotification(String title, String body) async {
//     tz.TZDateTime _notificationAt8AM() {
//       final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//       tz.TZDateTime scheduledDate =
//           tz.TZDateTime(tz.local, now.year, now.month, now.day, 9, 35);
//       if (scheduledDate.isBefore(now)) {
//         scheduledDate = scheduledDate.add(const Duration(days: 1));
//       }
//       return scheduledDate;
//     }
//
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       // iOS: DarwinNotificationDetails(),
//       android: AndroidNotificationDetails(
//         "channelId",
//         "channelName",
//         importance: Importance.max,
//         priority: Priority.high,
//         icon: "mipmap/ic_launcher",
//         actions: <AndroidNotificationAction>[
//           AndroidNotificationAction('Yes_Button', 'Yes'),
//           AndroidNotificationAction('No_Button', 'No'),
//         ],
//       ),
//     );
//     await flutterLocalNotificationsPlugin.show(
//         0, title, body, platformChannelSpecifics);
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'Attendance Notice!',
//       'Are you at work?',
//       _notificationAt8AM(),
//       platformChannelSpecifics,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }
//
//   static Future<void> showNotificationAt5(String title, String body) async {
//     tz.TZDateTime _notificationAt8AM() {
//       final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//       tz.TZDateTime scheduledDate =
//           tz.TZDateTime(tz.local, now.year, now.month, now.day, 16, 30);
//       if (scheduledDate.isBefore(now)) {
//         scheduledDate = scheduledDate.add(const Duration(days: 1));
//       }
//       return scheduledDate;
//     }
//
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       // iOS: DarwinNotificationDetails(),
//       android: AndroidNotificationDetails(
//         "channelId",
//         "channelName",
//         importance: Importance.max,
//         priority: Priority.high,
//         icon: "mipmap/ic_launcher",
//         actions: <AndroidNotificationAction>[
//           AndroidNotificationAction('Yes_Button', 'Yes'),
//           AndroidNotificationAction('No_Button', 'No'),
//         ],
//       ),
//     );
//     await flutterLocalNotificationsPlugin.show(
//         0, title, body, platformChannelSpecifics);
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'Attendance Notice!',
//       'Have you closed?',
//       _notificationAt8AM(),
//       platformChannelSpecifics,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }
//
//   Future<void> scheduleDailyNotifications() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool? isNotificationScheduled =
//         prefs.getBool('isScheduledNotificationActive') ?? false;
//
//     if (!isNotificationScheduled) {
//       await showNotification('Attendance Notice', 'Are you at work?');
//       await prefs.setBool('isScheduledNotificationActive', true);
//     }
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//             'daily_notification_channel_id', 'Daily Notifications',
//             importance: Importance.max, priority: Priority.max);
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//   }
// }
// Check if notifications have been scheduled
// SharedPreferences prefs = await SharedPreferences.getInstance();
// bool notificationsScheduled =
//     prefs.getBool('notificationsScheduled') ?? false;
//
// if (!notificationsScheduled) {
//   await showNotification('title', 'Are you at work?');
//   await showNotificationAt5('title', 'Have you closed?');
//
//   // Set the flag to indicate that notifications have been scheduled
//   await prefs.setBool('notificationsScheduled', true);
// }

// Check the actionId to determine which button was clicked
//   switch (receivedAction.actionId) {
//     case 'Yes_Button':
//       // Get the user's current position
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       // Define the target coordinate and radius
//       double targetLatitude = 5.6129311;
//       double targetLongitude = -0.1823302;
//       double radius = 100; // in meters
//
//       double distance = Geolocator.distanceBetween(
//         position.latitude,
//         position.longitude,
//         targetLatitude,
//         targetLongitude,
//       );
//
//       // Check if the user is within the specified radius
//       if (distance <= radius) {
//         // Save "Yes im at work" with the current time to Firestore
//         await FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {yes_Inside}')
//             .add({
//           'timestamp': Timestamp.now(),
//           'action': 'Yes I am at work',
//           'dayOfWeek': currentDay,
//           'userEmail': userEmail ?? 'Unknown',
//           'userName': userName ?? 'Unknown',
//         });
//         print('Yes button clicked inside radius');
//       } else {
//         // Save "Yes outside the geolocator radius" with the current user's time to Firestore
//         await FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {yes_Outside}')
//             .add({
//           'timestamp': Timestamp.now(),
//           'action': 'No I am not at work(Outside)',
//           'dayOfWeek': currentDay,
//           'userEmail': userEmail ?? 'Unknown',
//           'userName': userName ?? 'Unknown',
//         });
//         print('Yes button clicked outside radius');
//       }
//       break;
//     case 'No_Button':
//       // Save "No action" with the current users time to Firestore
//       await FirebaseFirestore.instance
//           .collection('Records')
//           .doc('Starting_time')
//           .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
//           .add({
//         'timestamp': Timestamp.now(),
//         'action': 'No I am not at work',
//         'dayOfWeek': currentDay,
//         'userEmail': userEmail ?? 'Unknown',
//         'userName': userName ?? 'Unknown',
//       });
//       print('No button clicked');
//       // await FirebaseFirestore.instance
//       //     .collection('Records')
//       //     .doc('Starting_time')
//       //     .collection(
//       //         '$currentDayNumber-$currentMonth-$currentYear {no_option_selected-$currentDay}')
//       //     .add({
//       //   'timestamp': Timestamp.now(),
//       //   'action': 'No im not at work',
//       //   'dayOfWeek': currentDay,
//       //   'userEmail': userEmail ?? 'Unknown',
//       //   'userName': userName ?? 'Unknown',
//       // });
//       break;
//     default:
//       print('Other action or notification clicked');
//   }
// } catch (e) {
//   print('Error in onActionReceive: $e');
// }
// }
// Future<void> _initializeWorkManager() async {
//   // Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
//   Workmanager().registerPeriodicTask(
//     'dailyNotification',
//     'dailyNotificationTask',
//     frequency: const Duration(hours: 24),
//     initialDelay: const Duration(minutes: 1),
//     inputData: {},
//   );
// }

// Future<void> _initializeWorkManager_2() async {
//   // await NotificationService.showNotificationAt5(
//   //     'Attendance Notice!', 'Have you closed? ');
//   await NotificationService_2().scheduleDailyNotifications();
//   // Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
//   Workmanager().registerPeriodicTask(
//     'dailyNotification_2',
//     'dailyNotificationTask_2',
//     frequency: const Duration(hours: 24),
//     initialDelay: const Duration(minutes: 1),
//     inputData: {},
//   );
// }

// Map<String, dynamic> convertTimestampToString(Map<String, dynamic> record) {
//   record['timestamp'] =
//       (record['timestamp'] as Timestamp).toDate().toIso8601String();
//   return record;
// }

// // import 'dart:convert';
// //
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // class ViewsPage extends StatelessWidget {
// //   const ViewsPage({super.key});
// //
// //   Map<String, dynamic> convertTimestampToString(Map<String, dynamic> record) {
// //     record['timestamp'] =
// //         (record['timestamp'] as Timestamp).toDate().toIso8601String();
// //     return record;
// //   }
// //
// //   Map<String, dynamic> convertStringToTimestamp(Map<String, dynamic> record) {
// //     record['timestamp'] =
// //         Timestamp.fromDate(DateTime.parse(record['timestamp']));
// //     return record;
// //   }
// //
// //   Future<void> _saveRecordsToSharedPreferences(
// //       List<Map<String, dynamic>> records) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     List<Map<String, dynamic>> convertedRecords =
// //         records.map(convertTimestampToString).toList();
// //     String jsonString = jsonEncode(convertedRecords);
// //     print('Saving records to SharedPreferences: $jsonString');
// //     await prefs.setString('userRecords', jsonString);
// //   }
// //
// //   Future<List<Map<String, dynamic>>> _loadRecordsFromSharedPreferences() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? jsonString = prefs.getString('userRecords');
// //     print('Loaded records from SharedPreferences: $jsonString');
// //     if (jsonString == null) {
// //       return [];
// //     } else {
// //       List<dynamic> jsonList = jsonDecode(jsonString);
// //       return jsonList
// //           .map((item) =>
// //               convertStringToTimestamp(Map<String, dynamic>.from(item)))
// //           .toList();
// //     }
// //   }
// //
// //   Future<List<Map<String, dynamic>>> _fetchUserRecords(String email) async {
// //     DateTime now = DateTime.now();
// //     int currentMonth = now.month;
// //     int currentYear = now.year;
// //     String currentDayNumber =
// //         DateFormat('d').format(now); // Get the day number of the month
// //
// //     try {
// //       print('Fetching records for email: $email');
// //
// //       // Fetch records from the four collections
// //       final yesInsideRecordsSnapshot = FirebaseFirestore.instance
// //           .collection('Records')
// //           .doc('Starting_time')
// //           .collection(
// //               '$currentDayNumber-$currentMonth-$currentYear {yes_Inside}')
// //           .where('userEmail', isEqualTo: email)
// //           .get();
// //
// //       final yesOutsideRecordsSnapshot = FirebaseFirestore.instance
// //           .collection('Records')
// //           .doc('Starting_time')
// //           .collection(
// //               '$currentDayNumber-$currentMonth-$currentYear {yes_Outside}')
// //           .where('userEmail', isEqualTo: email)
// //           .get();
// //
// //       final noRecordsSnapshot = FirebaseFirestore.instance
// //           .collection('Records')
// //           .doc('Starting_time')
// //           .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
// //           .where('userEmail', isEqualTo: email)
// //           .get();
// //
// //       final noOptionSelectedRecordsSnapshot = FirebaseFirestore.instance
// //           .collection('Records')
// //           .doc('Starting_time')
// //           .collection(
// //               '$currentDayNumber-$currentMonth-$currentYear {no_option_selected}')
// //           .where('userEmail', isEqualTo: email)
// //           .get();
// //
// //       // Wait for all the queries to complete and combine the results
// //       final snapshots = await Future.wait([
// //         yesInsideRecordsSnapshot,
// //         yesOutsideRecordsSnapshot,
// //         noRecordsSnapshot,
// //         noOptionSelectedRecordsSnapshot,
// //       ]);
// //
// //       print('Snapshots retrieved: ${snapshots.length}');
// //       snapshots.forEach((snapshot) {
// //         print('Snapshot size: ${snapshot.size}');
// //       });
// //
// //       // Combine the records from all the snapshots
// //       final allRecords = <Map<String, dynamic>>[
// //         for (final snapshot in snapshots)
// //           ...snapshot.docs.map((doc) {
// //             final data = doc.data() as Map<String, dynamic>;
// //             print('Document data: $data');
// //             data['date'] = DateFormat('d-M-yyyy')
// //                 .format((doc['timestamp'] as Timestamp).toDate());
// //             data['dayOfWeek'] = DateFormat('EEEE')
// //                 .format((doc['timestamp'] as Timestamp).toDate());
// //             return data;
// //           }),
// //       ];
// //
// //       print('All records: $allRecords');
// //
// //       return allRecords;
// //     } catch (e) {
// //       print('Error fetching records: $e');
// //       return [];
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     User? user = FirebaseAuth.instance.currentUser;
// //     String? email = user?.email;
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('User Records'),
// //       ),
// //       body: email == null
// //           ? const Center(child: Text('No user signed in'))
// //           : FutureBuilder<List<Map<String, dynamic>>>(
// //               future: _loadRecordsFromSharedPreferences()
// //                   .then((cachedRecords) async {
// //                 final currentRecords = await _fetchUserRecords(email!);
// //                 final combinedRecords = [...cachedRecords, ...currentRecords];
// //
// //                 // Save the combined records back to SharedPreferences
// //                 await _saveRecordsToSharedPreferences(combinedRecords);
// //
// //                 return combinedRecords;
// //               }),
// //               builder: (context, snapshot) {
// //                 if (snapshot.connectionState == ConnectionState.waiting) {
// //                   return const Center(child: CircularProgressIndicator());
// //                 } else if (snapshot.hasError) {
// //                   return Center(child: Text('Error: ${snapshot.error}'));
// //                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //                   return const Center(child: Text('No records found'));
// //                 } else {
// //                   List<Map<String, dynamic>> records = snapshot.data!;
// //                   Map<String, List<Map<String, dynamic>>> groupedRecords = {};
// //
// //                   for (var record in records) {
// //                     String dateKey = '${record['dayOfWeek']} ${record['date']}';
// //                     if (groupedRecords[dateKey] == null) {
// //                       groupedRecords[dateKey] = [];
// //                     }
// //                     groupedRecords[dateKey]!.add(record);
// //                   }
// //
// //                   return ListView.builder(
// //                     itemCount: groupedRecords.keys.length,
// //                     itemBuilder: (context, index) {
// //                       String dateKey = groupedRecords.keys.elementAt(index);
// //                       List<Map<String, dynamic>> dateRecords =
// //                           groupedRecords[dateKey]!;
// //
// //                       return Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Padding(
// //                             padding: const EdgeInsets.all(8.0),
// //                             child: Text(
// //                               dateKey,
// //                               style: const TextStyle(
// //                                   fontSize: 18, fontWeight: FontWeight.bold),
// //                             ),
// //                           ),
// //                           ...dateRecords.map((record) {
// //                             return ListTile(
// //                               title: Text('User: ${record['userName']}'),
// //                               subtitle: Column(
// //                                 crossAxisAlignment: CrossAxisAlignment.start,
// //                                 children: [
// //                                   Text('Email: ${record['userEmail']}'),
// //                                   Text('Status: ${record['action']}'),
// //                                   Text('Time: ${record['timestamp']}'),
// //                                 ],
// //                               ),
// //                             );
// //                           }).toList(),
// //                         ],
// //                       );
// //                     },
// //                   );
// //                 }
// //               },
// //             ),
// //     );
// //   }
// // }
//
// import 'dart:convert';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ViewsPage extends StatefulWidget {
//   const ViewsPage({super.key});
//
//   @override
//   State<ViewsPage> createState() => _ViewsPageState();
// }
//
// class _ViewsPageState extends State<ViewsPage> {
//   Map<String, dynamic> convertTimestampToString(Map<String, dynamic> record) {
//     record['timestamp'] =
//         (record['timestamp'] as Timestamp).toDate().toIso8601String();
//     return record;
//   }
//
//   Map<String, dynamic> convertStringToTimestamp(Map<String, dynamic> record) {
//     record['timestamp'] =
//         Timestamp.fromDate(DateTime.parse(record['timestamp']));
//     return record;
//   }
//
//   Future<void> _saveRecordsToSharedPreferences(
//       List<Map<String, dynamic>> records) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     // Check if records already exist in SharedPreferences
//     String? existingRecords = prefs.getString('firstStorage');
//     if (existingRecords != null) {
//       // Optionally, you can add a check here to avoid saving duplicates
//       // For simplicity, assuming you want to overwrite existing records
//       await prefs.remove('firstStorage');
//     }
//
//     List<Map<String, dynamic>> convertedRecords =
//         records.map(convertTimestampToString).toList();
//     String jsonString = jsonEncode(convertedRecords);
//     print('Saving records to SharedPreferences: $jsonString');
//     await prefs.setString('firstStorage', jsonString);
//   }
//
//   Future<List<Map<String, dynamic>>> _loadRecordsFromSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? jsonString = prefs.getString('firstStorage');
//     print('Loaded records from SharedPreferences: $jsonString');
//     if (jsonString == null) {
//       return [];
//     } else {
//       List<dynamic> jsonList = jsonDecode(jsonString);
//       return jsonList
//           .map((item) =>
//               convertStringToTimestamp(Map<String, dynamic>.from(item)))
//           .toList();
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> _fetchUserRecords(String email) async {
//     DateTime now = DateTime.now();
//     DateTime startDate =
//         now.subtract(const Duration(days: 7)); // Adjust the range as needed
//     List<Map<String, dynamic>> allRecords = [];
//
//     for (int i = 0; i <= 7; i++) {
//       DateTime currentDate = startDate.add(Duration(days: i));
//       int currentMonth = currentDate.month;
//       int currentYear = currentDate.year;
//       String currentDayNumber = DateFormat('d')
//           .format(currentDate); // Get the day number of the month
//
//       try {
//         print(
//             'Fetching records for email: $email on $currentDayNumber-$currentMonth-$currentYear');
//
//         final yesInsideRecordsSnapshot = FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {yes_Inside}')
//             .where('userEmail', isEqualTo: email)
//             .get();
//
//         final yesOutsideRecordsSnapshot = FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {yes_Outside}')
//             .where('userEmail', isEqualTo: email)
//             .get();
//
//         final noRecordsSnapshot = FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
//             .where('userEmail', isEqualTo: email)
//             .get();
//
//         final noOptionSelectedRecordsSnapshot = FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {no_option_selected}')
//             .where('userEmail', isEqualTo: email)
//             .get();
//
//         final snapshots = await Future.wait([
//           yesInsideRecordsSnapshot,
//           yesOutsideRecordsSnapshot,
//           noRecordsSnapshot,
//           noOptionSelectedRecordsSnapshot,
//         ]);
//
//         print(
//             'Snapshots retrieved for $currentDayNumber-$currentMonth-$currentYear: ${snapshots.length}');
//         snapshots.forEach((snapshot) {
//           print('Snapshot size: ${snapshot.size}');
//         });
//
//         allRecords.addAll([
//           for (final snapshot in snapshots)
//             ...snapshot.docs.map((doc) {
//               final data = doc.data() as Map<String, dynamic>;
//               print('Document data: $data');
//               data['date'] = DateFormat('d-M-yyyy')
//                   .format((doc['timestamp'] as Timestamp).toDate());
//               data['dayOfWeek'] = DateFormat('EEEE')
//                   .format((doc['timestamp'] as Timestamp).toDate());
//               return data;
//             }),
//         ]);
//       } catch (e) {
//         print(
//             'Error fetching records for $currentDayNumber-$currentMonth-$currentYear: $e');
//       }
//     }
//
//     print('All records: $allRecords');
//     return allRecords;
//   }
//
//   Future<void> _clearRecords() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('storage');
//     setState(() {
//       // Update UI state as needed after clearing SharedPreferences
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     User? user = FirebaseAuth.instance.currentUser;
//     String? email = user?.email;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Records'),
//       ),
//       body: email == null
//           ? const Center(child: Text('No user signed in'))
//           : FutureBuilder<List<Map<String, dynamic>>>(
//               future: _loadRecordsFromSharedPreferences()
//                   .then((cachedRecords) async {
//                 final currentRecords = await _fetchUserRecords(email!);
//                 final combinedRecords = [...cachedRecords, ...currentRecords];
//
//                 // Save the combined records back to SharedPreferences
//                 await _saveRecordsToSharedPreferences(combinedRecords);
//
//                 return combinedRecords;
//               }),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('No records found'));
//                 } else {
//                   List<Map<String, dynamic>> records = snapshot.data!;
//                   Map<String, List<Map<String, dynamic>>> groupedRecords = {};
//
//                   for (var record in records) {
//                     String dateKey = '${record['dayOfWeek']} ${record['date']}';
//                     if (groupedRecords[dateKey] == null) {
//                       groupedRecords[dateKey] = [];
//                     }
//                     groupedRecords[dateKey]!.add(record);
//                   }
//
//                   return ListView.builder(
//                     itemCount: groupedRecords.keys.length,
//                     itemBuilder: (context, index) {
//                       String dateKey = groupedRecords.keys.elementAt(index);
//                       List<Map<String, dynamic>> dateRecords =
//                           groupedRecords[dateKey]!;
//
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               dateKey,
//                               style: const TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           ...dateRecords.map((record) {
//                             return ListTile(
//                               title: Text('User: ${record['userName']}'),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Email: ${record['userEmail']}'),
//                                   Text('Status: ${record['action']}'),
//                                   Text('Time: ${record['timestamp']}'),
//                                 ],
//                               ),
//                             );
//                           }).toList(),
//                         ],
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _clearRecords,
//         tooltip: 'Clear Records',
//         child: Icon(Icons.clear),
//       ),
//     );
//   }
// }

// Check the actionId to determine which button was clicked
//   switch (receivedAction.actionId) {
//     case 'Yes_Button':
//       // Get the user's current position
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       // Define the target coordinate and radius
//       double targetLatitude = 5.6129311;
//       double targetLongitude = -0.1823302;
//       double radius = 100; // in meters
//
//       double distance = Geolocator.distanceBetween(
//         position.latitude,
//         position.longitude,
//         targetLatitude,
//         targetLongitude,
//       );
//
//       // Check if the user is within the specified radius
//       if (distance <= radius) {
//         // Save "Yes im at work" with the current time to Firestore
//         await FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {yes_Inside}')
//             .add({
//           'timestamp': Timestamp.now(),
//           'action': 'Yes I am at work',
//           'dayOfWeek': currentDay,
//           'userEmail': userEmail ?? 'Unknown',
//           'userName': userName ?? 'Unknown',
//         });
//         print('Yes button clicked inside radius');
//       } else {
//         // Save "Yes outside the geolocator radius" with the current user's time to Firestore
//         await FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {yes_Outside}')
//             .add({
//           'timestamp': Timestamp.now(),
//           'action': 'No I am not at work(Outside)',
//           'dayOfWeek': currentDay,
//           'userEmail': userEmail ?? 'Unknown',
//           'userName': userName ?? 'Unknown',
//         });
//         print('Yes button clicked outside radius');
//       }
//       break;
//     case 'No_Button':
//       // Save "No action" with the current users time to Firestore
//       await FirebaseFirestore.instance
//           .collection('Records')
//           .doc('Starting_time')
//           .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
//           .add({
//         'timestamp': Timestamp.now(),
//         'action': 'No I am not at work',
//         'dayOfWeek': currentDay,
//         'userEmail': userEmail ?? 'Unknown',
//         'userName': userName ?? 'Unknown',
//       });
//       print('No button clicked');
//       // await FirebaseFirestore.instance
//       //     .collection('Records')
//       //     .doc('Starting_time')
//       //     .collection(
//       //         '$currentDayNumber-$currentMonth-$currentYear {no_option_selected-$currentDay}')
//       //     .add({
//       //   'timestamp': Timestamp.now(),
//       //   'action': 'No im not at work',
//       //   'dayOfWeek': currentDay,
//       //   'userEmail': userEmail ?? 'Unknown',
//       //   'userName': userName ?? 'Unknown',
//       // });
//       break;
//     default:
//       print('Other action or notification clicked');
//   }
// } catch (e) {
//   print('Error in onActionReceive: $e');
// }
// }
//
// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ViewsPage extends StatefulWidget {
//   const ViewsPage({super.key});
//
//   @override
//   State<ViewsPage> createState() => _ViewsPageState();
// }
//
// class _ViewsPageState extends State<ViewsPage> {
//
//
//   Map<String, dynamic> convertStringToTimestamp(Map<String, dynamic> record) {
//     record['timestamp'] =
//         Timestamp.fromDate(DateTime.parse(record['timestamp']));
//     return record;
//   }
//
//   Future<void> _saveRecordsToSharedPreferences(
//       List<Map<String, dynamic>> records) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     // Check if records already exist in SharedPreferences
//     String? existingRecords = prefs.getString('userRecords');
//     if (existingRecords != null) {
//       // Optionally, you can add a check here to avoid saving duplicates
//       // For simplicity, assuming you want to overwrite existing records
//       await prefs.remove('userRecords');
//     }
//
//     // Convert timestamps to string format for storage
//     List<Map<String, dynamic>> convertedRecords =
//         records.map(convertTimestampToString).toList();
//
//     String jsonString = jsonEncode(convertedRecords);
//     print('Saving records to SharedPreferences: $jsonString');
//     await prefs.setString('userRecords', jsonString);
//   }
//
//   Map<String, dynamic> convertTimestampToString(Map<String, dynamic> record) {
//     // Ensure 'timestamp' field is converted to string format
//     record['timestamp'] =
//         (record['timestamp'] as Timestamp).toDate().toIso8601String();
//     return record;
//   }
//
//   Future<List<Map<String, dynamic>>> _loadRecordsFromSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? jsonString = prefs.getString('userRecords');
//     print('Loaded records from SharedPreferences: $jsonString');
//     if (jsonString == null) {
//       return [];
//     } else {
//       List<dynamic> jsonList = jsonDecode(jsonString);
//       return jsonList
//           .map((item) =>
//               convertStringToTimestamp(Map<String, dynamic>.from(item)))
//           .toList();
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> _fetchUserRecords(String email) async {
//     DateTime now = DateTime.now();
//     DateTime startDate =
//         now.subtract(const Duration(days: 7)); // Adjust the range as needed
//     List<Map<String, dynamic>> allRecords = [];
//
//     for (int i = 0; i <= 7; i++) {
//       DateTime currentDate = startDate.add(Duration(days: i));
//       int currentMonth = currentDate.month;
//       int currentYear = currentDate.year;
//       String currentDayNumber = DateFormat('d')
//           .format(currentDate); // Get the day number of the month
//
//       try {
//         print(
//             'Fetching records for email: $email on $currentDayNumber-$currentMonth-$currentYear');
//
//         final yesInsideRecordsSnapshot = FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {yes_Inside}')
//             .where('userEmail', isEqualTo: email)
//             .get();
//
//         final yesOutsideRecordsSnapshot = FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {yes_Outside}')
//             .where('userEmail', isEqualTo: email)
//             .get();
//
//         final noRecordsSnapshot = FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
//             .where('userEmail', isEqualTo: email)
//             .get();
//
//         final noOptionSelectedRecordsSnapshot = FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {no_option_selected}')
//             .where('userEmail', isEqualTo: email)
//             .get();
//
//         final snapshots = await Future.wait([
//           yesInsideRecordsSnapshot,
//           yesOutsideRecordsSnapshot,
//           noRecordsSnapshot,
//           noOptionSelectedRecordsSnapshot,
//         ]);
//
//         print(
//             'Snapshots retrieved for $currentDayNumber-$currentMonth-$currentYear: ${snapshots.length}');
//         snapshots.forEach((snapshot) {
//           print('Snapshot size: ${snapshot.size}');
//         });
//
//         allRecords.addAll([
//           for (final snapshot in snapshots)
//             ...snapshot.docs.map((doc) {
//               final data = doc.data() as Map<String, dynamic>;
//               print('Document data: $data');
//               data['date'] = DateFormat('d-M-yyyy')
//                   .format((doc['timestamp'] as Timestamp).toDate());
//               data['dayOfWeek'] = DateFormat('EEEE')
//                   .format((doc['timestamp'] as Timestamp).toDate());
//               return data;
//             }),
//         ]);
//       } catch (e) {
//         print(
//             'Error fetching records for $currentDayNumber-$currentMonth-$currentYear: $e');
//       }
//     }
//
//     print('All records: $allRecords');
//     return allRecords;
//   }
//
//   Future<void> _clearRecords() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('userRecords');
//     setState(() {
//       // Update UI state as needed after clearing SharedPreferences
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     User? user = FirebaseAuth.instance.currentUser;
//     String? email = user?.email;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Records'),
//       ),
//       body: email == null
//           ? const Center(child: Text('No user signed in'))
//           : FutureBuilder<List<Map<String, dynamic>>>(
//               future: _loadRecordsFromSharedPreferences()
//                   .then((cachedRecords) async {
//                 final currentRecords = await _fetchUserRecords(email!);
//
//                 // Remove duplicates by checking ids
//                 Set cachedIds = cachedRecords
//                     .map((record) => record['userRecords'])
//                     .toSet();
//                 List<Map<String, dynamic>> combinedRecords = [
//                   ...cachedRecords,
//                   ...currentRecords
//                       .where((record) =>
//                           !cachedIds.contains(record['userRecords']))
//                       .toList()
//                 ];
//
//                 // Save the combined records back to SharedPreferences
//                 await _saveRecordsToSharedPreferences(combinedRecords);
//
//                 return combinedRecords;
//               }),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('No records found'));
//                 } else {
//                   List<Map<String, dynamic>> records = snapshot.data!;
//                   Map<String, List<Map<String, dynamic>>> groupedRecords = {};
//
//                   for (var record in records) {
//                     String dateKey = '${record['dayOfWeek']} ${record['date']}';
//                     if (groupedRecords[dateKey] == null) {
//                       groupedRecords[dateKey] = [];
//                     }
//                     groupedRecords[dateKey]!.add(record);
//                   }
//
//                   return ListView.builder(
//                     itemCount: groupedRecords.keys.length,
//                     itemBuilder: (context, index) {
//                       String dateKey = groupedRecords.keys.elementAt(index);
//                       List<Map<String, dynamic>> dateRecords =
//                           groupedRecords[dateKey]!;
//
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               dateKey,
//                               style: const TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           ...dateRecords.map((record) {
//                             return ListTile(
//                               title: Text('User: ${record['userName']}'),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Email: ${record['userEmail']}'),
//                                   Text('Status: ${record['action']}'),
//                                   Text('Time: ${record['timestamp']}'),
//                                 ],
//                               ),
//                             );
//                           }).toList(),
//                         ],
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _clearRecords,
//         tooltip: 'Clear Records',
//         child: Icon(Icons.clear),
//       ),
//     );
//   }
// }
// import 'dart:convert';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ViewsPage extends StatefulWidget {
//   const ViewsPage({super.key});
//
//   @override
//   State<ViewsPage> createState() => _ViewsPageState();
// }
//
// class _ViewsPageState extends State<ViewsPage> {
//   Map<String, dynamic> convertStringToTimestamp(Map<String, dynamic> record) {
//     record['timestamp'] =
//         Timestamp.fromDate(DateTime.parse(record['timestamp']).toUtc());
//     return record;
//   }
//
//   Future<void> _saveRecordsToSharedPreferences(
//       List<Map<String, dynamic>> records) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     // Check if records already exist in SharedPreferences
//     String? existingRecords = prefs.getString('userRecords');
//     if (existingRecords != null) {
//       // Optionally, you can add a check here to avoid saving duplicates
//       // For simplicity, assuming you want to overwrite existing records
//       await prefs.remove('userRecords');
//     }
//
//     // Convert timestamps to string format for storage
//     List<Map<String, dynamic>> convertedRecords =
//         records.map(convertTimestampToString).toList();
//
//     String jsonString = jsonEncode(convertedRecords);
//     print('Saving records to SharedPreferences: $jsonString');
//     await prefs.setString('userRecords', jsonString);
//   }
//
//   Map<String, dynamic> convertTimestampToString(Map<String, dynamic> record) {
//     // Ensure 'timestamp' field is converted to string format
//     record['timestamp'] =
//         (record['timestamp'] as Timestamp).toDate().toUtc().toIso8601String();
//     return record;
//   }
//
//   Future<List<Map<String, dynamic>>> _loadRecordsFromSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? jsonString = prefs.getString('userRecords');
//     print('Loaded records from SharedPreferences: $jsonString');
//     if (jsonString == null) {
//       return [];
//     } else {
//       List<dynamic> jsonList = jsonDecode(jsonString);
//       return jsonList
//           .map((item) =>
//               convertStringToTimestamp(Map<String, dynamic>.from(item)))
//           .toList();
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> _fetchUserRecords(String email) async {
//     DateTime now = DateTime.now();
//     DateTime startDate =
//         now.subtract(const Duration(days: 7)); // Adjust the range as needed
//     List<Map<String, dynamic>> allRecords = [];
//
//     for (int i = 0; i <= 7; i++) {
//       DateTime currentDate = startDate.add(Duration(days: i));
//       int currentMonth = currentDate.month;
//       int currentYear = currentDate.year;
//       String currentDayNumber = DateFormat('d')
//           .format(currentDate); // Get the day number of the month
//
//       try {
//         print(
//             'Fetching records for email: $email on $currentDayNumber-$currentMonth-$currentYear');
//
//         final yesInsideRecordsSnapshot = FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {yes_Inside}')
//             .where('userEmail', isEqualTo: email)
//             .get();
//
//         final yesOutsideRecordsSnapshot = FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {yes_Outside}')
//             .where('userEmail', isEqualTo: email)
//             .get();
//
//         final noRecordsSnapshot = FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
//             .where('userEmail', isEqualTo: email)
//             .get();
//
//         final noOptionSelectedRecordsSnapshot = FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {no_option_selected}')
//             .where('userEmail', isEqualTo: email)
//             .get();
//
//         final closingRecordsSnapshots = [
//           FirebaseFirestore.instance
//               .collection('ClosingRecords')
//               .doc('Closing_time')
//               .collection('yes_Closed')
//               .where('userEmail', isEqualTo: email)
//               .get(),
//           FirebaseFirestore.instance
//               .collection('ClosingRecords')
//               .doc('Closing_time')
//               .collection('no_Closed')
//               .where('userEmail', isEqualTo: email)
//               .get(),
//           FirebaseFirestore.instance
//               .collection('ClosingRecords')
//               .doc('Closing_time')
//               .collection('no_option_selected_Closed')
//               .where('userEmail', isEqualTo: email)
//               .get(),
//         ];
//
//         final snapshots = await Future.wait([
//           yesInsideRecordsSnapshot,
//           yesOutsideRecordsSnapshot,
//           noRecordsSnapshot,
//           noOptionSelectedRecordsSnapshot,
//           ...closingRecordsSnapshots,
//         ]);
//
//         print(
//             'Snapshots retrieved for $currentDayNumber-$currentMonth-$currentYear: ${snapshots.length}');
//         snapshots.forEach((snapshot) {
//           print('Snapshot size: ${snapshot.size}');
//         });
//
//         allRecords.addAll([
//           for (final snapshot in snapshots)
//             ...snapshot.docs.map((doc) {
//               final data = doc.data() as Map<String, dynamic>;
//               print('Document data: $data');
//               data['date'] = DateFormat('d-M-yyyy')
//                   .format((doc['timestamp'] as Timestamp).toDate().toUtc());
//               data['dayOfWeek'] = DateFormat('EEEE')
//                   .format((doc['timestamp'] as Timestamp).toDate().toUtc());
//               return data;
//             }),
//         ]);
//       } catch (e) {
//         print(
//             'Error fetching records for $currentDayNumber-$currentMonth-$currentYear: $e');
//       }
//     }
//
//     print('All records: $allRecords');
//     return allRecords;
//   }
//
//   Future<void> _clearRecords() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('userRecords');
//     setState(() {
//       // Update UI state as needed after clearing SharedPreferences
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     User? user = FirebaseAuth.instance.currentUser;
//     String? email = user?.email;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Records'),
//       ),
//       body: email == null
//           ? const Center(child: Text('No user signed in'))
//           : FutureBuilder<List<Map<String, dynamic>>>(
//               future: _loadRecordsFromSharedPreferences()
//                   .then((cachedRecords) async {
//                 final currentRecords = await _fetchUserRecords(email!);
//
//                 // Remove duplicates by checking ids
//                 Set cachedIds = cachedRecords
//                     .map((record) => record['userRecords'])
//                     .toSet();
//                 List<Map<String, dynamic>> combinedRecords = [
//                   ...cachedRecords,
//                   ...currentRecords
//                       .where((record) =>
//                           !cachedIds.contains(record['userRecords']))
//                       .toList()
//                 ];
//
//                 // Save the combined records back to SharedPreferences
//                 await _saveRecordsToSharedPreferences(combinedRecords);
//
//                 return combinedRecords;
//               }),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('No records found'));
//                 } else {
//                   List<Map<String, dynamic>> records = snapshot.data!;
//                   Map<String, List<Map<String, dynamic>>> groupedRecords = {};
//
//                   for (var record in records) {
//                     String dateKey = '${record['dayOfWeek']} ${record['date']}';
//                     if (groupedRecords[dateKey] == null) {
//                       groupedRecords[dateKey] = [];
//                     }
//                     groupedRecords[dateKey]!.add(record);
//                   }
//
//                   // Sort records so that the current day's records come first
//                   List<String> sortedKeys = groupedRecords.keys.toList();
//                   sortedKeys.sort((a, b) {
//                     DateTime dateA = DateFormat('EEEE d-M-yyyy').parse(a);
//                     DateTime dateB = DateFormat('EEEE d-M-yyyy').parse(b);
//                     return dateB.compareTo(dateA); // Sort in descending order
//                   });
//
//                   return ListView.builder(
//                     itemCount: sortedKeys.length,
//                     itemBuilder: (context, index) {
//                       String dateKey = sortedKeys[index];
//                       List<Map<String, dynamic>> dateRecords =
//                           groupedRecords[dateKey]!;
//
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               dateKey,
//                               style: const TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           ...dateRecords.map((record) {
//                             return ListTile(
//                               title: Text('User: ${record['userName']}'),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Email: ${record['userEmail']}'),
//                                   Text('Status: ${record['action']}'),
//                                   Text('Time: ${record['timestamp']}'),
//                                 ],
//                               ),
//                             );
//                           }).toList(),
//                         ],
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _clearRecords,
//         tooltip: 'Clear Records',
//         child: Icon(Icons.clear),
//       ),
//     );
//   }
// }

// import 'dart:convert';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ViewsPage extends StatefulWidget {
//   const ViewsPage({super.key});
//
//   @override
//   State<ViewsPage> createState() => _ViewsPageState();
// }
//
// class _ViewsPageState extends State<ViewsPage> {
//   late Stream<List<Map<String, dynamic>>> _recordsStream;
//
//   @override
//   void initState() {
//     super.initState();
//     _recordsStream = _createRecordsStream();
//   }
//
//   Map<String, dynamic> convertStringToTimestamp(Map<String, dynamic> record) {
//     record['timestamp'] =
//         Timestamp.fromDate(DateTime.parse(record['timestamp']).toUtc());
//     return record;
//   }
//
//   Map<String, dynamic> convertTimestampToString(Map<String, dynamic> record) {
//     record['timestamp'] =
//         (record['timestamp'] as Timestamp).toDate().toUtc().toIso8601String();
//     return record;
//   }
//
//   Stream<List<Map<String, dynamic>>> _createRecordsStream() async* {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       yield [];
//       return;
//     }
//
//     final email = user.email!;
//     List<Stream<QuerySnapshot<Map<String, dynamic>>>> streams = [];
//
//     DateTime now = DateTime.now();
//     DateTime startDate = now.subtract(const Duration(days: 7));
//
//     for (int i = 0; i <= 7; i++) {
//       DateTime currentDate = startDate.add(Duration(days: i));
//       int currentMonth = currentDate.month;
//       int currentYear = currentDate.year;
//       String currentDayNumber = DateFormat('d').format(currentDate);
//
//       streams.addAll([
//         FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {yes_Inside}')
//             .where('userEmail', isEqualTo: email)
//             .snapshots(),
//         FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {yes_Outside}')
//             .where('userEmail', isEqualTo: email)
//             .snapshots(),
//         FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
//             .where('userEmail', isEqualTo: email)
//             .snapshots(),
//         FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//                 '$currentDayNumber-$currentMonth-$currentYear {no_option_selected}')
//             .where('userEmail', isEqualTo: email)
//             .snapshots(),
//       ]);
//     }
//
//     streams.addAll([
//       FirebaseFirestore.instance
//           .collection('ClosingRecords')
//           .doc('Closing_time')
//           .collection('yes_Closed')
//           .where('userEmail', isEqualTo: email)
//           .snapshots(),
//       FirebaseFirestore.instance
//           .collection('ClosingRecords')
//           .doc('Closing_time')
//           .collection('no_Closed')
//           .where('userEmail', isEqualTo: email)
//           .snapshots(),
//       FirebaseFirestore.instance
//           .collection('ClosingRecords')
//           .doc('Closing_time')
//           .collection('no_option_selected_Closed')
//           .where('userEmail', isEqualTo: email)
//           .snapshots(),
//     ]);
//
//     yield* CombineLatestStream.list(streams).map((snapshots) {
//       List<Map<String, dynamic>> allRecords = [];
//       for (var snapshot in snapshots) {
//         allRecords.addAll(snapshot.docs.map((doc) {
//           final data = doc.data();
//           data['date'] = DateFormat('d-M-yyyy')
//               .format((doc['timestamp'] as Timestamp).toDate().toUtc());
//           data['dayOfWeek'] = DateFormat('EEEE')
//               .format((doc['timestamp'] as Timestamp).toDate().toUtc());
//           return data;
//         }).toList());
//       }
//       return allRecords;
//     });
//   }
//
//   Future<void> _clearRecords() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('userRecords');
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     User? user = FirebaseAuth.instance.currentUser;
//     String? email = user?.email;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Records'),
//       ),
//       body: email == null
//           ? const Center(child: Text('No user signed in'))
//           : StreamBuilder<List<Map<String, dynamic>>>(
//               stream: _recordsStream,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('No records found'));
//                 } else {
//                   List<Map<String, dynamic>> records = snapshot.data!;
//                   Map<String, List<Map<String, dynamic>>> groupedRecords = {};
//
//                   for (var record in records) {
//                     String dateKey = '${record['dayOfWeek']} ${record['date']}';
//                     if (groupedRecords[dateKey] == null) {
//                       groupedRecords[dateKey] = [];
//                     }
//                     groupedRecords[dateKey]!.add(record);
//                   }
//
//                   List<String> sortedKeys = groupedRecords.keys.toList();
//                   sortedKeys.sort((a, b) {
//                     DateTime dateA = DateFormat('EEEE d-M-yyyy').parse(a);
//                     DateTime dateB = DateFormat('EEEE d-M-yyyy').parse(b);
//                     return dateB.compareTo(dateA);
//                   });
//
//                   return ListView.builder(
//                     itemCount: sortedKeys.length,
//                     itemBuilder: (context, index) {
//                       String dateKey = sortedKeys[index];
//                       List<Map<String, dynamic>> dateRecords =
//                           groupedRecords[dateKey]!;
//
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               dateKey,
//                               style: const TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           ...dateRecords.map((record) {
//                             return ListTile(
//                               title: Text('User: ${record['userName']}'),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Email: ${record['userEmail']}'),
//                                   Text('Status: ${record['action']}'),
//                                   Text('Time: ${record['timestamp']}'),
//                                   if (record.containsKey('source'))
//                                     Text('Source: ${record['source']}'),
//                                 ],
//                               ),
//                             );
//                           }).toList(),
//                         ],
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _clearRecords,
//         tooltip: 'Clear Records',
//         child: Icon(Icons.clear),
//       ),
//     );
//   }
// }
