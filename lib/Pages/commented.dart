// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'package:intl/intl.dart';
// another test
// class RecordsPage extends StatefulWidget {
//   final String section;
// another test 2
//   RecordsPage({super.key, required this.section, required List records});
//
//   @override
//   _RecordsPageState createState() => _RecordsPageState();
// }
//
// class _RecordsPageState extends State<RecordsPage> {
//   List<Map<String, dynamic>> records = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadRecordsFromSharedPreferences().then((loadedRecords) {
//       print('Loaded Records: $loadedRecords'); // Debug print
//       setState(() {
//         records = _filterRecordsBySection(loadedRecords, widget.section);
//         print('Filtered Records: $records'); // Debug print
//         isLoading = false;
//       });
//     }).catchError((error) {
//       print('Error loading records: $error');
//       setState(() {
//         isLoading = false; // Stop loading indicator even if there's an error
//       });
//     });
//   }
//
//   Future<List<Map<String, dynamic>>> _loadRecordsFromSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? jsonString = prefs.getString('userRecords');
//     print('Stored Records JSON: $jsonString'); // Debug print
//     if (jsonString == null) {
//       return []; // No records found
//     } else {
//       List<dynamic> jsonList = jsonDecode(jsonString);
//       return jsonList.map((item) => Map<String, dynamic>.from(item)).toList();
//     }
//   }
//
//   List<Map<String, dynamic>> _filterRecordsBySection(
//       List<Map<String, dynamic>> records, String section) {
//     switch (section) {
//       case 'Yes (Inside)':
//         return records
//             .where((record) => record['action'] == 'Yes I am at work')
//             .toList();
//       case 'Yes (Outside)':
//         return records
//             .where((record) => record['action'] == 'No I am not at work (Outside)')
//             .toList();
//       case 'No':
//         return records
//             .where((record) => record['action'] == 'No I am not at work')
//             .toList();
//       default:
//         print('Unknown section: $section'); // Debug print
//         return [];
//     }
//   }
//
//   String _getDayOfWeek(String? dateString) {
//     if (dateString == null) return 'No Date';
//     DateTime date = DateFormat('yyyy-MM-dd').parse(dateString);
//     return DateFormat('EEEE').format(date); // EEEE gives the full day name
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Records for ${widget.section}'),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : records.isEmpty
//           ? Center(child: Text('No records found for ${widget.section}.'))
//           : ListView.builder(
//         itemCount: records.length,
//         itemBuilder: (context, index) {
//           var record = records[index];
//           String? date = record['date'];
//           String dayOfWeek = _getDayOfWeek(date);
//           return ListTile(
//             title: Text('Record ${index + 1}'),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (date != null) Text(dayOfWeek),
//               ],
//             ),
//             trailing: Text(date ?? 'No Date'),
//           );
//         },
//       ),
//     );
//   }
// }
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

// void _signIn() async {
//   if (_formKey.currentState?.validate() ?? false) {
//     setState(() {
//       isLoading = true; // Set loading state to true
//     });
//     try {
//       // String userName = _userName.text;
//       String userEmail = _userEmail.text;
//       String userPassword = _userPassword.text;
//
//       User? user =
//           await _auth.signInWithEmailAndPassword(userEmail, userPassword);
//
//       if (user != null) {
//         print('User is successfully Signed In ');
//
//         Navigator.pushNamed(context, '/home');
//
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         // prefs.setString('UserName', userName);
//         prefs.setString('userPassword', userPassword);
//         prefs.setString('userEmail', userEmail);
//       } else {
//         print('ERROR');
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Sign In  Failed. Try Again!! '),
//             backgroundColor: Colors.red, // Optionally set a background color
//             duration: Duration(seconds: 3), // Duration to show the SnackBar
//           ),
//         );
//       }
//     } catch (e, s) {
//       print('Error');
//       print(s);
//     } finally {
//       setState(() {
//         isLoading = false; // Set loading state to true
//       });
//     }
//   }
// }
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
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:month_picker_dialog/month_picker_dialog.dart';
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
//   DateTime _selectedDate = DateTime.now();
//
//   @override
//   void initState() {
//     super.initState();
//     _recordsStream = _createRecordsStream();
//   }
//
//   Map<String, dynamic> convertStringToTimestamp(Map<String, dynamic> record) {
//     if (record['timestamp'] is String) {
//       record['timestamp'] =
//           Timestamp.fromDate(DateTime.parse(record['timestamp']).toUtc());
//     }
//     return record;
//   }
//
//   Map<String, dynamic> convertTimestampToString(Map<String, dynamic> record) {
//     if (record['timestamp'] is Timestamp) {
//       record['timestamp'] =
//           (record['timestamp'] as Timestamp).toDate().toUtc().toIso8601String();
//     }
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
//     DateTime now = _selectedDate;
//     DateTime startDate = DateTime(now.year, now.month, 1);
//     DateTime endDate =
//         DateTime(now.year, now.month + 1, 1).subtract(Duration(days: 1));
//
//     for (int i = 0; i <= endDate.day; i++) {
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
//                 '$currentDayNumber-$currentMonth-$currentYear {Checked In}')
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
//           Timestamp timestamp = data['timestamp'] as Timestamp;
//           DateTime dateTime = timestamp.toDate();
//
//           data['date'] = DateFormat('dd-MM-yyyy').format(dateTime);
//           data['time'] = DateFormat('HH:mm').format(dateTime); // Remove seconds
//           data['dayOfWeek'] = DateFormat('EEEE').format(dateTime);
//           data.remove('userName'); // Clear userName
//           data.remove('userEmail'); // Clear userEmail
//           return data;
//         }).toList());
//       }
//       return allRecords;
//     });
//   }
//   // Stream<List<Map<String, dynamic>>> _createRecordsStream() async* {
//   //   User? user = FirebaseAuth.instance.currentUser;
//   //   if (user == null) {
//   //     yield [];
//   //     return;
//   //   }
//   //
//   //   final email = user.email!;
//   //   List<Stream<QuerySnapshot<Map<String, dynamic>>>> streams = [];
//   //
//   //   // Adjust the date range for past records
//   //   DateTime now = DateTime.now();
//   //   DateTime startDate = DateTime(now.year - 1, 1, 1); // Start from 1 year ago
//   //   DateTime endDate = now;
//   //
//   //   // Generate date range for past records
//   //   for (DateTime currentDate = startDate;
//   //       currentDate.isBefore(endDate);
//   //       currentDate = currentDate.add(Duration(days: 1))) {
//   //     int currentMonth = currentDate.month;
//   //     int currentYear = currentDate.year;
//   //     String currentDayNumber = DateFormat('d').format(currentDate);
//   //
//   //     streams.addAll([
//   //       FirebaseFirestore.instance
//   //           .collection('Records')
//   //           .doc('Starting_time')
//   //           .collection(
//   //               '$currentDayNumber-$currentMonth-$currentYear {yes_Inside}')
//   //           .where('Email', isEqualTo: email)
//   //           .snapshots(),
//   //       FirebaseFirestore.instance
//   //           .collection('Records')
//   //           .doc('Starting_time')
//   //           .collection(
//   //               '$currentDayNumber-$currentMonth-$currentYear {yes_Outside}')
//   //           .where('Email', isEqualTo: email)
//   //           .snapshots(),
//   //       FirebaseFirestore.instance
//   //           .collection('Records')
//   //           .doc('Starting_time')
//   //           .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
//   //           .where('userEmail', isEqualTo: email)
//   //           .snapshots(),
//   //       FirebaseFirestore.instance
//   //           .collection('Records')
//   //           .doc('Starting_time')
//   //           .collection(
//   //               '$currentDayNumber-$currentMonth-$currentYear {Checked In}')
//   //           .where('userEmail', isEqualTo: email)
//   //           .snapshots(),
//   //       FirebaseFirestore.instance
//   //           .collection('Records')
//   //           .doc('Starting_time')
//   //           .collection(
//   //               '$currentDayNumber-$currentMonth-$currentYear {no_option_selected}')
//   //           .where('userEmail', isEqualTo: email)
//   //           .snapshots(),
//   //     ]);
//   //   }
//   //
//   //   streams.addAll([
//   //     FirebaseFirestore.instance
//   //         .collection('ClosingRecords')
//   //         .doc('Closing_time')
//   //         .collection('yes_Closed')
//   //         .where('userEmail', isEqualTo: email)
//   //         .snapshots(),
//   //     FirebaseFirestore.instance
//   //         .collection('ClosingRecords')
//   //         .doc('Closing_time')
//   //         .collection('no_Closed')
//   //         .where('userEmail', isEqualTo: email)
//   //         .snapshots(),
//   //     FirebaseFirestore.instance
//   //         .collection('ClosingRecords')
//   //         .doc('Closing_time')
//   //         .collection('no_option_selected_Closed')
//   //         .where('userEmail', isEqualTo: email)
//   //         .snapshots(),
//   //   ]);
//   //
//   //   yield* CombineLatestStream.list(streams).map((snapshots) {
//   //     List<Map<String, dynamic>> allRecords = [];
//   //     for (var snapshot in snapshots) {
//   //       allRecords.addAll(snapshot.docs.map((doc) {
//   //         final data = doc.data();
//   //         Timestamp timestamp = data['timestamp'] as Timestamp;
//   //         DateTime dateTime = timestamp.toDate();
//   //
//   //         data['date'] = DateFormat('dd-MM-yyyy').format(dateTime);
//   //         data['time'] = DateFormat('HH:mm').format(dateTime); // Remove seconds
//   //         data['dayOfWeek'] = DateFormat('EEEE').format(dateTime);
//   //         data.remove('userName'); // Clear userName
//   //         data.remove('userEmail'); // Clear userEmail
//   //         return data;
//   //       }).toList());
//   //     }
//   //     return allRecords;
//   //   });
//   // }
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
//         appBar: AppBar(
//           title: const Text('User Records'),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.calendar_today),
//               onPressed: () {
//                 showMonthPicker(
//                   context: context,
//                   initialDate: _selectedDate,
//                   firstDate: DateTime(DateTime.now().year - 5),
//                   lastDate: DateTime(DateTime.now().year + 5),
//                 ).then((date) {
//                   if (date != null) {
//                     setState(() {
//                       _selectedDate = date;
//                       _recordsStream = _createRecordsStream();
//                     });
//                   }
//                 });
//               },
//             ),
//           ],
//         ),
//         body: email == null
//             ? const Center(child: Text('No user signed in'))
//             : StreamBuilder<List<Map<String, dynamic>>>(
//                 stream: _recordsStream,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(child: Text('No records found'));
//                   } else {
//                     List<Map<String, dynamic>> records = snapshot.data!;
//                     Map<String, List<Map<String, dynamic>>> groupedRecords = {};
//
//                     for (var record in records) {
//                       String dateKey =
//                           '${record['dayOfWeek']} ${record['date']}';
//                       if (groupedRecords[dateKey] == null) {
//                         groupedRecords[dateKey] = [];
//                       }
//                       groupedRecords[dateKey]!.add(record);
//                     }
//
//                     List<String> sortedKeys = groupedRecords.keys.toList();
//                     sortedKeys.sort((a, b) {
//                       DateTime dateA = DateFormat('EEEE dd-MM-yyyy').parse(a);
//                       DateTime dateB = DateFormat('EEEE dd-MM-yyyy').parse(b);
//                       return dateB.compareTo(dateA); // Sort in descending order
//                     });
//
//                     return ListView.builder(
//                       itemCount: sortedKeys.length,
//                       itemBuilder: (context, index) {
//                         String dateKey = sortedKeys[index];
//                         List<Map<String, dynamic>> dateRecords =
//                             groupedRecords[dateKey]!;
//
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 dateKey,
//                                 style: const TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             ...dateRecords.map((record) {
//                               return ListTile(
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text('Status: ${record['action']}'),
//                                     Text('Date: ${record['date']}'),
//                                     Text('Time: ${record['time']}'),
//                                     if (record.containsKey('source'))
//                                       Text('Source: ${record['source']}'),
//                                   ],
//                                 ),
//                               );
//                             }).toList(),
//                           ],
//                         );
//                       },
//                     );
//                   }
//                 },
//               ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: _clearRecords,
//           tooltip: 'Clear Records',
//           child: Icon(Icons.clear),
//         ));
//   }
// }

// import 'package:attendance_mobile_app/Pages/pie_chart_records_page.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:month_picker_dialog/month_picker_dialog.dart';
// import 'package:rxdart/rxdart.dart';
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
//   DateTime _selectedDate = DateTime.now();
//
//   @override
//   void initState() {
//     super.initState();
//     _recordsStream = _createRecordsStream();
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
//     DateTime now = _selectedDate;
//     DateTime startDate = DateTime(now.year, now.month, 1);
//     DateTime endDate = DateTime(now.year, now.month + 1, 1).subtract(Duration(days: 1));
//
//     for (int i = 0; i <= endDate.day; i++) {
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
//             '$currentDayNumber-$currentMonth-$currentYear {yes_Inside}')
//             .where('userEmail', isEqualTo: email)
//             .snapshots(),
//         FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//             '$currentDayNumber-$currentMonth-$currentYear {yes_Outside}')
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
//             '$currentDayNumber-$currentMonth-$currentYear {no_option_selected}')
//             .where('userEmail', isEqualTo: email)
//             .snapshots(),
//       ]);
//     }
//
//     yield* CombineLatestStream.list(streams).map((snapshots) {
//       List<Map<String, dynamic>> allRecords = [];
//       for (var snapshot in snapshots) {
//         allRecords.addAll(snapshot.docs.map((doc) {
//           final data = doc.data();
//           Timestamp timestamp = data['timestamp'] as Timestamp;
//           DateTime dateTime = timestamp.toDate();
//
//           data['date'] = DateFormat('dd-MM-yyyy').format(dateTime);
//           data['time'] = DateFormat('HH:mm').format(dateTime); // Remove seconds
//           data['dayOfWeek'] = DateFormat('EEEE').format(dateTime);
//           data.remove('userName'); // Clear userName
//           data.remove('userEmail'); // Clear userEmail
//           return data;
//         }).toList());
//       }
//       return allRecords;
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
//         actions: [
//           IconButton(
//             icon: Icon(Icons.calendar_today),
//             onPressed: () {
//               showMonthPicker(
//                 context: context,
//                 initialDate: _selectedDate,
//                 firstDate: DateTime(DateTime.now().year - 5),
//                 lastDate: DateTime(DateTime.now().year + 5),
//               ).then((date) {
//                 if (date != null) {
//                   setState(() {
//                     _selectedDate = date;
//                     _recordsStream = _createRecordsStream();
//                   });
//                 }
//               });
//             },
//           ),
//         ],
//       ),
//       body: email == null
//           ? const Center(child: Text('No user signed in'))
//           : StreamBuilder<List<Map<String, dynamic>>>(
//         stream: _recordsStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No records found'));
//           } else {
//             List<Map<String, dynamic>> records = snapshot.data!;
//             Map<String, List<Map<String, dynamic>>> groupedRecords = {};
//
//             for (var record in records) {
//               String dateKey = '${record['dayOfWeek']} ${record['date']}';
//               if (groupedRecords[dateKey] == null) {
//                 groupedRecords[dateKey] = [];
//               }
//               groupedRecords[dateKey]!.add(record);
//             }
//
//             List<String> sortedKeys = groupedRecords.keys.toList();
//             sortedKeys.sort((a, b) {
//               DateTime dateA = DateFormat('EEEE dd-MM-yyyy').parse(a);
//               DateTime dateB = DateFormat('EEEE dd-MM-yyyy').parse(b);
//               return dateB.compareTo(dateA); // Sort in descending order
//             });
//
//             return ListView.builder(
//               itemCount: sortedKeys.length,
//               itemBuilder: (context, index) {
//                 String dateKey = sortedKeys[index];
//                 List<Map<String, dynamic>> dateRecords =
//                 groupedRecords[dateKey]!;
//
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         dateKey,
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     ...dateRecords.map((record) {
//                       return ListTile(
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Status: ${record['action']}'),
//                             Text('Date: ${record['date']}'),
//                             Text('Time: ${record['time']}'),
//                             if (record.containsKey('source'))
//                               Text('Source: ${record['source']}'),
//                           ],
//                         ),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => RecordsPage(
//                                 section: record['action'],
//                                 records: snapshot.data!,
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     }).toList(),
//                   ],
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:month_picker_dialog/month_picker_dialog.dart';
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
//   DateTime _selectedDate = DateTime.now();
//
//   @override
//   void initState() {
//     super.initState();
//     _recordsStream = _createRecordsStream();
//   }
//
//   Map<String, dynamic> convertStringToTimestamp(Map<String, dynamic> record) {
//     if (record['timestamp'] is String) {
//       record['timestamp'] =
//           Timestamp.fromDate(DateTime.parse(record['timestamp']).toUtc());
//     }
//     return record;
//   }
//
//   Map<String, dynamic> convertTimestampToString(Map<String, dynamic> record) {
//     if (record['timestamp'] is Timestamp) {
//       record['timestamp'] =
//           (record['timestamp'] as Timestamp).toDate().toUtc().toIso8601String();
//     }
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
//     DateTime now = _selectedDate;
//     DateTime startDate = DateTime(now.year, now.month, 1);
//     DateTime endDate =
//         DateTime(now.year, now.month + 1, 1).subtract(Duration(days: 1));
//
//     for (int i = 0; i <= endDate.day; i++) {
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
//                 '$currentDayNumber-$currentMonth-$currentYear {Checked In}')
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
//           Timestamp timestamp = data['timestamp'] as Timestamp;
//           DateTime dateTime = timestamp.toDate();
//
//           data['date'] = DateFormat('dd-MM-yyyy').format(dateTime);
//           data['time'] = DateFormat('HH:mm').format(dateTime); // Remove seconds
//           data['dayOfWeek'] = DateFormat('EEEE').format(dateTime);
//           data.remove('userName'); // Clear userName
//           data.remove('userEmail'); // Clear userEmail
//           print("Fetched record: $data"); // Debugging print statement
//
//           allRecords.add(data);
//
//           return data;
//         }).toList());
//       }
//       print(
//           "Total records fetched: ${allRecords.length}"); // Debugging print statement
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
//         actions: [
//           IconButton(
//             icon: Icon(Icons.calendar_today),
//             onPressed: () {
//               showMonthPicker(
//                 context: context,
//                 initialDate: _selectedDate,
//                 firstDate: DateTime(DateTime.now().year - 5),
//                 lastDate: DateTime(DateTime.now().year + 5),
//               ).then((date) {
//                 if (date != null) {
//                   setState(() {
//                     _selectedDate = date;
//                     _recordsStream = _createRecordsStream();
//                   });
//                 }
//               });
//             },
//           ),
//         ],
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
//                     DateTime dateA = DateFormat('EEEE dd-MM-yyyy').parse(a);
//                     DateTime dateB = DateFormat('EEEE dd-MM-yyyy').parse(b);
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
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Status: ${record['action']}'),
//                                   Text('Date: ${record['date']}'),
//                                   Text('Time: ${record['time']}'),
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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ViewsPage extends StatefulWidget {
//
//
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
//     if (record['timestamp'] is String) {
//       record['timestamp'] =
//           Timestamp.fromDate(DateTime.parse(record['timestamp']).toUtc());
//     }
//     return record;
//   }
//
//   Map<String, dynamic> convertTimestampToString(Map<String, dynamic> record) {
//     if (record['timestamp'] is Timestamp) {
//       record['timestamp'] =
//           (record['timestamp'] as Timestamp).toDate().toUtc().toIso8601String();
//     }
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
//           Timestamp timestamp = data['timestamp'] as Timestamp;
//           DateTime dateTime = timestamp.toDate();
//
//           data['date'] = DateFormat('dd-MM-yyyy').format(dateTime);
//           data['time'] = DateFormat('HH:mm:ss').format(dateTime);
//           data['dayOfWeek'] = DateFormat('EEEE').format(dateTime);
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
//                     String dateKey =
//                         '${record['dayOfWeek']} ${record['date']} ${record['time']}';
//                     if (groupedRecords[dateKey] == null) {
//                       groupedRecords[dateKey] = [];
//                     }
//                     groupedRecords[dateKey]!.add(record);
//                   }
//
//                   List<String> sortedKeys = groupedRecords.keys.toList();
//                   sortedKeys.sort((a, b) {
//                     DateTime dateA =
//                         DateFormat('EEEE dd-MM-yyyy HH:mm:ss').parse(a);
//                     DateTime dateB =
//                         DateFormat('EEEE dd-MM-yyyy HH:mm:ss').parse(b);
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
//                                   Text('Date: ${record['date']}'),
//                                   Text('Time: ${record['time']}'),
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
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: _clearRecords,
//       //   tooltip: 'Clear Records',
//       //   child: Icon(Icons.clear),
//       // ),
//     );
//   }
// }

//
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:attendance_mobile_app/Pages/pie_chart_records_page.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class HomePage extends StatefulWidget {
//   static final GlobalKey<_HomePageState> homePageKey =
//   GlobalKey<_HomePageState>();
//
//   const HomePage({Key? key}) : super(key: key);
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
//   int _additionalTextIndex = 0; // Index to track which text to display
//
//   Position? _currentPosition;
//   String? _currentAddress;
//
//   String? _imagePath;
//
//   List<String> additionalTexts = [
//     'Customer Sensitivity',
//     'Leadership',
//     'Accountability',
//     'Speed',
//     'Shared Vision and Mindset',
//     'Innovation',
//     'Effectiveness',
//   ];
//
//   static Future<void> showMyDialog() async {
//     final context = HomePage.homePageKey.currentContext;
//
//     if (context != null) {
//       return showDialog<void>(
//         context: context,
//         barrierDismissible: false, // user must tap button!
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('AlertDialog Title'),
//             content: const SingleChildScrollView(
//               child: ListBody(
//                 children: <Widget>[
//                   Text('This is a demo alert dialog.'),
//                   Text('Would you like to approve of this message?'),
//                 ],
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text('Approve'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       print('No context available.');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProfileImage();
//     _loadAdditionalTextIndex(); // Load stored index on initialization
//     _saveUserDetails();
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
//   Future<void> _loadAdditionalTextIndex() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _additionalTextIndex = prefs.getInt('additionalTextIndex') ?? 0;
//     });
//   }
//
//   Future<void> _saveAdditionalTextIndex(int newIndex) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('additionalTextIndex', newIndex);
//     setState(() {
//       _additionalTextIndex = newIndex;
//     });
//   }
//
//   Future<void> _loadProfileImage() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _imagePath = prefs.getString('profile_image');
//     });
//   }
//
//   Future<void> _onSectionTapped(String section) async {
//     List<Map<String, dynamic>> startingRecords = [];
//     List<Map<String, dynamic>> closingRecords = [];
//
//     try {
//       if (section == 'Yes (Inside)' || section == 'Yes (Outside)') {
//         QuerySnapshot startingSnapshot = await FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection('yes_Closed')
//             .get();
//
//         QuerySnapshot closingSnapshot = await FirebaseFirestore.instance
//             .collection('ClosingRecords')
//             .doc('Closing_time')
//             .collection('yes_Closed')
//             .get();
//
//         startingRecords = startingSnapshot.docs
//             .map((doc) => doc.data() as Map<String, dynamic>)
//             .toList();
//
//         closingRecords = closingSnapshot.docs
//             .map((doc) => doc.data() as Map<String, dynamic>)
//             .toList();
//       } else if (section == 'No') {
//         QuerySnapshot startingSnapshot = await FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection('no_Closed')
//             .get();
//
//         QuerySnapshot closingSnapshot = await FirebaseFirestore.instance
//             .collection('ClosingRecords')
//             .doc('Closing_time')
//             .collection('no_Closed')
//             .get();
//
//         startingRecords = startingSnapshot.docs
//             .map((doc) => doc.data() as Map<String, dynamic>)
//             .toList();
//
//         closingRecords = closingSnapshot.docs
//             .map((doc) => doc.data() as Map<String, dynamic>)
//             .toList();
//       }
//
//       List<Map<String, dynamic>> allRecords = [
//         ...startingRecords,
//         ...closingRecords
//       ];
//
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => RecordsPage(records: allRecords, section: section),
//         ),
//       );
//     } catch (e) {
//       print('Error fetching records: $e');
//       // Handle the error appropriately
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: HomePage.homePageKey,
//       appBar: AppBar(
//         title: const Text('Home Page'),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (_imagePath != null)
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ImageScreen(_imagePath!),
//                       ),
//                     );
//                   },
//                   child: CircleAvatar(
//                     radius: 50,
//                     backgroundImage: FileImage(File(_imagePath!)),
//                   ),
//                 ),
//               const SizedBox(height: 16),
//               Text(
//                 _currentAddress ?? 'Getting location...',
//                 style: const TextStyle(fontSize: 18),
//               ),
//               const SizedBox(height: 16),
//               Center(
//                 child: Container(
//                   height: 400,
//                   child: PieChart(
//                     PieChartData(
//                       sections: [
//                         PieChartSectionData(
//                           color: Colors.green,
//                           // value: yesInsideCount.toDouble(),
//                           badgeWidget: GestureDetector(
//                             onTap: () => _onSectionTapped('Yes (Inside)'),
//                             child: _buildIcon('Yes (Inside)'),
//                           ),
//                           radius: 90,
//                           // title: 'Yes (Inside)',
//                           titleStyle: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         PieChartSectionData(
//                           color: Colors.orange,
//                           // value: yesOutsideCount.toDouble(),
//                           badgeWidget: GestureDetector(
//                             onTap: () =>
//                                 _onSectionTapped('Yes (Outside)'),
//                             child: _buildIcon('Yes (Outside)'),
//                           ),
//                           radius: 80,
//                           // title: 'Yes (Outside)',
//                           titleStyle: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         PieChartSectionData(
//                           color: Colors.red,
//                           // value: noCount.toDouble(),
//                           badgeWidget: GestureDetector(
//                             onTap: () => _onSectionTapped('No'),
//                             child: _buildIcon('No'),
//                           ),
//                           radius: 80,
//                           // title: 'No',
//                           titleStyle: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                       centerSpaceRadius: 50,
//                       borderData: FlBorderData(show: false),
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
//               const Text(
//                 'Here is some additional text:',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 additionalTexts[_additionalTextIndex],
//                 style: const TextStyle(fontSize: 18),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) {
//     // Your background task code here
//     return Future.value(true);
//   });
// }
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// /*
//
// Make pie chart clickable where users can click a portion and it will display to them the records of that portion
// make it easy to read
//
// Make the classie more readable and meaningful
// display the coordinates well for viewing
//
// */
// class HomePage extends StatefulWidget {
//   static final GlobalKey<_HomePageState> homePageKey =
//       GlobalKey<_HomePageState>();
//
//   const HomePage({Key? key}) : super(key: key);
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
//   int _additionalTextIndex = 0; // Index to track which text to display
//
//   Position? _currentPosition;
//   String? _currentAddress;
//
//   String? _imagePath;
//
//   List<String> additionalTexts = [
//     'Customer Sensitivity',
//     'Leadership',
//     'Accountability',
//     'Speed',
//     'Shared Vision and Mindset',
//     'Innovation',
//     'Effectiveness',
//   ];
//
//   static Future<void> showMyDialog() async {
//     final context = HomePage.homePageKey.currentContext;
//
//     if (context != null) {
//       return showDialog<void>(
//         context: context,
//         barrierDismissible: false, // user must tap button!
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('AlertDialog Title'),
//             content: const SingleChildScrollView(
//               child: ListBody(
//                 children: <Widget>[
//                   Text('This is a demo alert dialog.'),
//                   Text('Would you like to approve of this message?'),
//                 ],
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text('Approve'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       print('No context available.');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // NotificationService.showNotificationAt5(
//     //     "Attendance Notice!", "Have you closed?");
//     _loadProfileImage();
//     _loadAdditionalTextIndex(); // Load stored index on initialization
//     _saveUserDetails();
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
//         await placemarkFromCoordinates(position.latitude, position.longitude);
//     Placemark place = placemarks[0];
//     setState(() {
//       _currentAddress =
//           "${place.locality}, ${place.postalCode}, ${place.country}";
//     });
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
//           // Handle unexpected cases if necessary
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
//   Future<void> _loadAdditionalTextIndex() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _additionalTextIndex = prefs.getInt('additionalTextIndex') ?? 0;
//     });
//   }
//
//   Future<void> _saveAdditionalTextIndex(int newIndex) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('additionalTextIndex', newIndex);
//     setState(() {
//       _additionalTextIndex = newIndex;
//     });
//   }
//
//   Future<void> _loadProfileImage() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _imagePath = prefs.getString('profile_image');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         actions: [
//           _imagePath == null
//               ? IconButton(
//                   icon: const Icon(Icons.person),
//                   onPressed: () {
//                     // Handle icon press if needed
//                   },
//                 )
//               : GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ImageScreen(_imagePath!),
//                       ),
//                     );
//                   },
//                   child: CircleAvatar(
//                     backgroundImage: FileImage(File(_imagePath!)),
//                     radius: 20,
//                   ),
//                 ),
//           IconButton(
//             icon: const Icon(Icons.settings),
//             onPressed: () {
//               Navigator.pushNamed(context, '/settings').then((_) {
//                 // Navigate back from views page, increment additional text index
//                 _saveAdditionalTextIndex(
//                     (_additionalTextIndex + 1) % additionalTexts.length);
//               });
//               ;
//             },
//           ),
//         ],
//         title: const Text('Home Page'),
//       ),
//       body: isLoading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     if (_currentPosition != null && _currentAddress != null)
//                       Column(
//                         children: [
//                           Text(
//                             'Coordinates: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Location: $_currentAddress',
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                           const SizedBox(height: 16),
//                         ],
//                       ),
//                     Center(
//                       child: Container(
//                         height: 400,
//                         width: 400,
//                         child: PieChart(
//                           PieChartData(
//                             sections: [
//                               PieChartSectionData(
//                                 color: Colors.green,
//                                 // value: yesInsideCount.toDouble(),
//                                 badgeWidget: _buildIcon('Yes (Inside)'),
//                                 badgePositionPercentageOffset: 0.7,
//                                 radius: 60,
//                               ),
//                               PieChartSectionData(
//                                 color: Colors.orange,
//                                 // value: yesOutsideCount.toDouble(),
//                                 badgeWidget: _buildIcon('Yes (Outside)'),
//                                 badgePositionPercentageOffset: 0.5,
//                                 radius: 50,
//                               ),
//                               PieChartSectionData(
//                                 color: Colors.red,
//                                 // value: noCount.toDouble(),
//                                 badgeWidget: _buildIcon('No'),
//                                 badgePositionPercentageOffset: 0.5,
//                                 radius: 50,
//                               ),
//                             ],
//                             centerSpaceRadius: 50,
//                             sectionsSpace: 2,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Column(
//                       children: [
//                         _buildLegendItem(Colors.green, 'Yes (Inside)'),
//                         _buildLegendItem(Colors.orange, 'Yes (Outside)'),
//                         _buildLegendItem(Colors.red, 'No'),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'CLASSIE',
//                       style: TextStyle(
//                           fontSize: 40,
//                           fontWeight: FontWeight.bold,
//                           fontStyle: FontStyle.italic),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       _additionalTextIndex < additionalTexts.length
//                           ? additionalTexts[_additionalTextIndex]
//                           : '',
//                       style: const TextStyle(
//                         fontSize: 20,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//       floatingActionButton: FloatingActionButton(
//         splashColor: Colors.purple,
//         onPressed: () {
//           Navigator.pushNamed(context, '/views').then((_) {
//             // Navigate back from views page, increment additional text index
//             _saveAdditionalTextIndex(
//                 (_additionalTextIndex + 1) % additionalTexts.length);
//           });
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
//             Text('Records')
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'dart:io';
// import 'package:attendance_mobile_app/Pages/pie_chart_records_page.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class HomePage extends StatefulWidget {
//   static final GlobalKey<_HomePageState> homePageKey =
//       GlobalKey<_HomePageState>();
//
//   const HomePage({Key? key}) : super(key: key);
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
//   int _additionalTextIndex = 0; // Index to track which text to display
//
//   Position? _currentPosition;
//   String? _currentAddress;
//
//   String? _imagePath;
//
//   List<String> additionalTexts = [
//     'Customer Sensitivity',
//     'Leadership',
//     'Accountability',
//     'Speed',
//     'Shared Vision and Mindset',
//     'Innovation',
//     'Effectiveness',
//   ];
//
//   static Future<void> showMyDialog() async {
//     final context = HomePage.homePageKey.currentContext;
//
//     if (context != null) {
//       return showDialog<void>(
//         context: context,
//         barrierDismissible: false, // user must tap button!
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('AlertDialog Title'),
//             content: const SingleChildScrollView(
//               child: ListBody(
//                 children: <Widget>[
//                   Text('This is a demo alert dialog.'),
//                   Text('Would you like to approve of this message?'),
//                 ],
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text('Approve'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       print('No context available.');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // NotificationService.showNotificationAt5(
//     //     "Attendance Notice!", "Have you closed?");
//     _loadProfileImage();
//     _loadAdditionalTextIndex(); // Load stored index on initialization
//     _saveUserDetails();
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
//         await placemarkFromCoordinates(position.latitude, position.longitude);
//     Placemark place = placemarks[0];
//     setState(() {
//       _currentAddress =
//           "${place.locality}, ${place.postalCode}, ${place.country}";
//     });
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
//           // Handle unexpected cases if necessary
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
//   Future<void> _loadAdditionalTextIndex() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _additionalTextIndex = prefs.getInt('additionalTextIndex') ?? 0;
//     });
//   }
//
//   Future<void> _saveAdditionalTextIndex(int newIndex) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('additionalTextIndex', newIndex);
//     setState(() {
//       _additionalTextIndex = newIndex;
//     });
//   }
//
//   Future<void> _loadProfileImage() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _imagePath = prefs.getString('profile_image');
//     });
//   }
//
//   void _onSectionTapped(String section) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => RecordsPage(
//           section: section,
//           records: [],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         actions: [
//           _imagePath == null
//               ? IconButton(
//                   icon: const Icon(Icons.person),
//                   onPressed: () {
//                     // Handle icon press if needed
//                   },
//                 )
//               : GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ImageScreen(_imagePath!),
//                       ),
//                     );
//                   },
//                   child: CircleAvatar(
//                     backgroundImage: FileImage(File(_imagePath!)),
//                     radius: 20,
//                   ),
//                 ),
//           IconButton(
//             icon: const Icon(Icons.settings),
//             onPressed: () {
//               Navigator.pushNamed(context, '/settings').then((_) {
//                 // Navigate back from views page, increment additional text index
//                 _saveAdditionalTextIndex(
//                     (_additionalTextIndex + 1) % additionalTexts.length);
//               });
//             },
//           ),
//         ],
//         title: const Text('Home Page'),
//       ),
//       body: isLoading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     if (_currentPosition != null && _currentAddress != null)
//                       Column(
//                         children: [
//                           Text(
//                             'Coordinates: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Location: $_currentAddress',
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                           const SizedBox(height: 16),
//                         ],
//                       ),
//                     Center(
//                       child: Container(
//                         height: 400,
//                         width: 400,
//                         child: PieChart(
//                           PieChartData(
//                             sections: [
//                               PieChartSectionData(
//                                 color: Colors.green,
//                                 value: yesInsideCount.toDouble(),
//                                 badgeWidget: GestureDetector(
//                                   onTap: () => _onSectionTapped('Yes (Inside)'),
//                                   child: _buildIcon('Yes (Inside)'),
//                                 ),
//                                 radius: 80,
//                                 title: 'Yes (Inside)',
//                                 titleStyle: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               PieChartSectionData(
//                                 color: Colors.orange,
//                                 value: yesOutsideCount.toDouble(),
//                                 badgeWidget: GestureDetector(
//                                   onTap: () =>
//                                       _onSectionTapped('Yes (Outside)'),
//                                   child: _buildIcon('Yes (Outside)'),
//                                 ),
//                                 radius: 80,
//                                 title: 'Yes (Outside)',
//                                 titleStyle: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               PieChartSectionData(
//                                 color: Colors.red,
//                                 value: noCount.toDouble(),
//                                 badgeWidget: GestureDetector(
//                                   onTap: () => _onSectionTapped('No'),
//                                   child: _buildIcon('No'),
//                                 ),
//                                 radius: 80,
//                                 title: 'No',
//                                 titleStyle: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                             centerSpaceRadius: 50,
//                             borderData: FlBorderData(show: false),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Column(
//                       children: [
//                         _buildLegendItem(Colors.green, 'Yes (Inside)'),
//                         _buildLegendItem(Colors.orange, 'Yes (Outside)'),
//                         _buildLegendItem(Colors.red, 'No'),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Here is some additional text:',
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       additionalTexts[_additionalTextIndex],
//                       style: const TextStyle(fontSize: 18),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         child: const Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [Icon(Icons.remove_red_eye_rounded), Padding(
//             padding: EdgeInsets.fromLTRB(2, 0, 1, 1),
//             child: Text('Records'),
//           )],
//         ),
//       ),
//     );
//   }
// }
//

// import 'dart:convert';
// import 'dart:io';
// import 'package:attendance_mobile_app/Pages/pie_chart_records_page.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class HomePage extends StatefulWidget {
//   static final GlobalKey<_HomePageState> homePageKey =
//   GlobalKey<_HomePageState>();
//
//   const HomePage({Key? key}) : super(key: key);
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
//   int _additionalTextIndex = 0;
//
//   Position? _currentPosition;
//   String? _currentAddress;
//   String? _imagePath;
//
//   List<String> additionalTexts = [
//     'Customer Sensitivity',
//     'Leadership',
//     'Accountability',
//     'Speed',
//     'Shared Vision and Mindset',
//     'Innovation',
//     'Effectiveness',
//   ];
//
//   static Future<void> showMyDialog() async {
//     final context = HomePage.homePageKey.currentContext;
//     if (context != null) {
//       return showDialog<void>(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('AlertDialog Title'),
//             content: const SingleChildScrollView(
//               child: ListBody(
//                 children: <Widget>[
//                   Text('This is a demo alert dialog.'),
//                   Text('Would you like to approve of this message?'),
//                 ],
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text('Approve'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       print('No context available.');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProfileImage();
//     _loadAdditionalTextIndex();
//     _saveUserDetails();
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
//     List<Placemark> placemarks =
//     await placemarkFromCoordinates(position.latitude, position.longitude);
//     Placemark place = placemarks[0];
//     setState(() {
//       _currentAddress =
//       "${place.locality}, ${place.postalCode}, ${place.country}";
//     });
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
//   Future<void> _loadAdditionalTextIndex() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _additionalTextIndex = prefs.getInt('additionalTextIndex') ?? 0;
//     });
//   }
//
//   Future<void> _saveAdditionalTextIndex(int newIndex) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('additionalTextIndex', newIndex);
//     setState(() {
//       _additionalTextIndex = newIndex;
//     });
//   }
//
//   Future<void> _loadProfileImage() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _imagePath = prefs.getString('profile_image');
//     });
//   }
//
//   void _onSectionTapped(String section) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => RecordsPage(
//           section: section,
//           records: [],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         actions: [
//           _imagePath == null
//               ? IconButton(
//             icon: const Icon(Icons.person),
//             onPressed: () {
//               // Handle icon press if needed
//             },
//           )
//               : GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ImageScreen(_imagePath!),
//                 ),
//               );
//             },
//             child: CircleAvatar(
//               backgroundImage: FileImage(File(_imagePath!)),
//               radius: 20,
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.settings),
//             onPressed: () {
//               Navigator.pushNamed(context, '/settings').then((_) {
//                 _saveAdditionalTextIndex(
//                     (_additionalTextIndex + 1) % additionalTexts.length);
//               });
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
//                 child: GestureDetector(
//                   onTap: () => _onSectionTapped('Yes (Inside)'),
//                   child: Container(
//                     height: 400,
//                     width: 400,
//                     child: PieChart(
//                       PieChartData(
//                         sections: [
//                           PieChartSectionData(
//                             color: Colors.green,
//                             value: yesInsideCount.toDouble(),
//                             badgeWidget: _buildIcon('Yes (Inside)'),
//                             badgePositionPercentageOffset: 0.7,
//                             radius: 60,
//                           ),
//                           PieChartSectionData(
//                             color: Colors.orange,
//                             value: yesOutsideCount.toDouble(),
//                             badgeWidget: _buildIcon('Yes (Outside)'),
//                             badgePositionPercentageOffset: 0.5,
//                             radius: 50,
//                           ),
//                           PieChartSectionData(
//                             color: Colors.red,
//                             value: noCount.toDouble(),
//                             badgeWidget: _buildIcon('No'),
//                             badgePositionPercentageOffset: 0.5,
//                             radius: 50,
//                           ),
//                         ],
//                       ),
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
//               Text(
//                 additionalTexts[_additionalTextIndex],
//                 style: const TextStyle(fontSize: 16),
//               ),
//             ],
//           ),
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
// //
// class ImageScreen extends StatelessWidget {
//   final String imagePath;
//
//   ImageScreen(this.imagePath);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: const Icon(Icons.arrow_back_ios)),
//       ),
//       body: Center(
//         child: Image.file(File(imagePath)),
//       ),
//     );
//   }
// }
//

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'package:intl/intl.dart';
//
// class RecordsPage extends StatefulWidget {
//   final String section;
//
//   RecordsPage({required this.section, required List records});
//
//   @override
//   _RecordsPageState createState() => _RecordsPageState();
// }
//
// class _RecordsPageState extends State<RecordsPage> {
//   List<Map<String, dynamic>> records = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadRecordsFromSharedPreferences().then((loadedRecords) {
//       setState(() {
//         records = _filterRecordsBySection(loadedRecords, widget.section);
//         isLoading = false;
//       });
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
//   List<Map<String, dynamic>> _filterRecordsBySection(
//       List<Map<String, dynamic>> records, String section) {
//     switch (section) {
//       case 'Yes (Inside)':
//         return records
//             .where((record) => record['action'] == 'Yes I am at work')
//             .toList();
//       case 'Yes (Outside)':
//         return records
//             .where((record) => record['action'] == 'No I am not at work (Outside)')
//             .toList();
//       case 'No':
//         return records
//             .where((record) => record['action'] == 'No I am not at work')
//             .toList();
//       default:
//         return [];
//     }
//   }
//
//   String _getDayOfWeek(String? dateString) {
//     if (dateString == null) return 'No Date';
//     DateTime date = DateFormat('yyyy-MM-dd').parse(dateString);
//     return DateFormat('EEEE').format(date); // EEEE gives the full day name
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Records for ${widget.section}'),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: records.length,
//         itemBuilder: (context, index) {
//           var record = records[index];
//           String? date = record['date'];
//           String dayOfWeek = _getDayOfWeek(date);
//           return ListTile(
//             title: Text(record['userName'] ?? 'No Name'),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(record['userEmail'] ?? 'No Email'),
//                 if (date != null) Text(dayOfWeek),
//               ],
//             ),
//             trailing: Text(date ?? 'No Date'),
//           );
//         },
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
//
// class AttendanceNoticePage extends StatefulWidget {
//   const AttendanceNoticePage({super.key});
//
//   @override
//   _AttendanceNoticePageState createState() => _AttendanceNoticePageState();
// }
//
// class _AttendanceNoticePageState extends State<AttendanceNoticePage> {
//   String userName = 'Unknown User';
//   String userEmail = 'Unknown Email';
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserPreferences();
//   }
//
//   Future<void> _loadUserPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userName = prefs.getString('UserName') ?? 'Unknown User';
//       userEmail = prefs.getString('userEmail') ?? 'Unknown Email';
//     });
//   }
//
//   Future<void> handleAction(String action) async {
//     DateTime now = DateTime.now();
//     int currentMonth = now.month;
//     int currentYear = now.year;
//     String currentDay = DateFormat('EEEE').format(now); // Get the day of the week
//     String currentDayNumber = DateFormat('d').format(now); // Get the day number of the month
//
//     switch (action) {
//       case 'Yes':
//         await _handleYesButtonAction(currentDay, currentDayNumber, currentMonth, currentYear);
//         break;
//       case 'No':
//         await _handleNoButtonAction(currentDay, currentDayNumber, currentMonth, currentYear);
//         break;
//       default:
//         print('Unknown action');
//     }
//   }
//
//   Future<void> _handleYesButtonAction(String currentDay, String currentDayNumber, int currentMonth, int currentYear) async {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     double targetLatitude = 5.6129311;
//     double targetLongitude = -0.1823302;
//     double radius = 100; // in meters
//
//     double distance = Geolocator.distanceBetween(
//       position.latitude,
//       position.longitude,
//       targetLatitude,
//       targetLongitude,
//     );
//
//     String collectionName = distance <= radius ? 'yes_Inside' : 'yes_Outside';
//     String actionText = distance <= radius ? 'Yes I am at work' : 'No I am not at work (Outside)';
//
//     await FirebaseFirestore.instance
//         .collection('Records')
//         .doc('Starting_time')
//         .collection('$currentDayNumber-$currentMonth-$currentYear {$collectionName}')
//         .add({
//       'timestamp': Timestamp.fromDate(DateTime.now().toUtc()),
//       'action': actionText,
//       'dayOfWeek': currentDay,
//       'userEmail': userEmail,
//       'userName': userName,
//     });
//     print('Yes button clicked');
//   }
//
//   Future<void> _handleNoButtonAction(String currentDay, String currentDayNumber, int currentMonth, int currentYear) async {
//     await FirebaseFirestore.instance
//         .collection('Records')
//         .doc('Starting_time')
//         .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
//         .add({
//       'timestamp': Timestamp.fromDate(DateTime.now().toUtc()),
//       'action': 'No I am not at work',
//       'dayOfWeek': currentDay,
//       'userEmail': userEmail,
//       'userName': userName,
//     });
//     print('No button clicked');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Attendance Notice'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Are you at work?',
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => handleAction('Yes'),
//               child: Text('Yes'),
//             ),
//             ElevatedButton(
//               onPressed: () => handleAction('No'),
//               child: Text('No'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
//
// class AttendanceNoticePage extends StatefulWidget {
//   const AttendanceNoticePage({super.key});
//
//   @override
//   _AttendanceNoticePageState createState() => _AttendanceNoticePageState();
// }
//
// class _AttendanceNoticePageState extends State<AttendanceNoticePage> {
//   String userName = 'Unknown User';
//   String userEmail = 'Unknown Email';
//   bool isWithinAllowedTime = false;
//   bool hasCheckedIn = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserPreferences();
//     _checkAllowedTime();
//   }
//
//   Future<void> _loadUserPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userName = prefs.getString('UserName') ?? 'Unknown User';
//       userEmail = prefs.getString('userEmail') ?? 'Unknown Email';
//     });
//   }
//
//   void _checkAllowedTime() {
//     DateTime now = DateTime.now();
//     DateTime startTime = DateTime(now.year, now.month, now.day, 8);
//     DateTime endTime = startTime.add(const Duration(hours: 4));
//     setState(() {
//       isWithinAllowedTime = now.isAfter(startTime) && now.isBefore(endTime);
//     });
//   }
//
//   Future<void> handleAction(String action) async {
//     DateTime now = DateTime.now();
//     int currentMonth = now.month;
//     int currentYear = now.year;
//     String currentDay = DateFormat('EEEE').format(now); // Get the day of the week
//     String currentDayNumber = DateFormat('d').format(now); // Get the day number of the month
//
//     switch (action) {
//       case 'Yes':
//         await _handleYesButtonAction(currentDay, currentDayNumber, currentMonth, currentYear);
//         break;
//       case 'No':
//         await _handleNoButtonAction(currentDay, currentDayNumber, currentMonth, currentYear);
//         break;
//       default:
//         print('Unknown action');
//     }
//
//     setState(() {
//       hasCheckedIn = true;
//     });
//   }
//
//   Future<void> _handleYesButtonAction(String currentDay, String currentDayNumber, int currentMonth, int currentYear) async {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     double targetLatitude = 5.6129311;
//     double targetLongitude = -0.1823302;
//     double radius = 100; // in meters
//
//     double distance = Geolocator.distanceBetween(
//       position.latitude,
//       position.longitude,
//       targetLatitude,
//       targetLongitude,
//     );
//
//     String collectionName = distance <= radius ? 'yes_Inside' : 'yes_Outside';
//     String actionText = distance <= radius ? 'Yes I am at work' : 'No I am not at work (Outside)';
//
//     await FirebaseFirestore.instance
//         .collection('Records')
//         .doc('Starting_time')
//         .collection('$currentDayNumber-$currentMonth-$currentYear {$collectionName}')
//         .add({
//       'timestamp': Timestamp.fromDate(DateTime.now().toUtc()),
//       'action': actionText,
//       'dayOfWeek': currentDay,
//       'userEmail': userEmail,
//       'userName': userName,
//     });
//     print('Yes button clicked');
//   }
//
//   Future<void> _handleNoButtonAction(String currentDay, String currentDayNumber, int currentMonth, int currentYear) async {
//     await FirebaseFirestore.instance
//         .collection('Records')
//         .doc('Starting_time')
//         .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
//         .add({
//       'timestamp': Timestamp.fromDate(DateTime.now().toUtc()),
//       'action': 'No I am not at work',
//       'dayOfWeek': currentDay,
//       'userEmail': userEmail,
//       'userName': userName,
//     });
//     print('No button clicked');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Check In /Check Out'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (!hasCheckedIn) ...[
//                 const Text(
//                   'Attendance Notice!',
//                   style: TextStyle(fontSize: 34),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Are you at work?',
//                   style: TextStyle(fontSize: 24),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//               ElevatedButton(
//                 onPressed: isWithinAllowedTime && !hasCheckedIn ? () => handleAction('Yes') : null,
//                 child: const Text('Yes'),
//               ),
//               ElevatedButton(
//                 onPressed: isWithinAllowedTime && !hasCheckedIn ? () => handleAction('No') : null,
//                 child: const Text('No'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
//
// class AttendanceNoticePage extends StatefulWidget {
//   const AttendanceNoticePage({super.key});
//
//   @override
//   _AttendanceNoticePageState createState() => _AttendanceNoticePageState();
// }
//
// class _AttendanceNoticePageState extends State<AttendanceNoticePage> {
//   String userName = 'Unknown User';
//   String userEmail = 'Unknown Email';
//   bool isWithinAllowedTime = false;
//   bool hasCheckedIn = false;
//   bool isAfterNoon = false;
//   bool isAfterWorkTime = false;
//   bool hasLeftWork = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserPreferences();
//     _checkAllowedTime();
//     _checkAfterNoon();
//     _checkAfterWorkTime();
//   }
//
//   Future<void> _loadUserPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userName = prefs.getString('UserName') ?? 'Unknown User';
//       userEmail = prefs.getString('userEmail') ?? 'Unknown Email';
//     });
//   }
//
//   void _checkAllowedTime() {
//     DateTime now = DateTime.now();
//     DateTime startTime = DateTime(now.year, now.month, now.day, 8);
//     DateTime endTime = startTime.add(const Duration(hours: 4));
//     setState(() {
//       isWithinAllowedTime = now.isAfter(startTime) && now.isBefore(endTime);
//     });
//   }
//
//   void _checkAfterNoon() {
//     DateTime now = DateTime.now();
//     DateTime noon = DateTime(now.year, now.month, now.day, 12);
//     setState(() {
//       isAfterNoon = now.isAfter(noon);
//     });
//   }
//
//   void _checkAfterWorkTime() {
//     DateTime now = DateTime.now();
//     DateTime workTime = DateTime(now.year, now.month, now.day, 17);
//     DateTime endTime = workTime.add(const Duration(hours: 4));
//     setState(() {
//       isAfterWorkTime = now.isAfter(workTime) && now.isBefore(endTime);
//     });
//   }
//
//   Future<void> handleAction(String action, String type) async {
//     DateTime now = DateTime.now();
//     int currentMonth = now.month;
//     int currentYear = now.year;
//     String currentDay = DateFormat('EEEE').format(now); // Get the day of the week
//     String currentDayNumber = DateFormat('d').format(now); // Get the day number of the month
//
//     switch (action) {
//       case 'Yes':
//         if (type == 'start') {
//           await _handleYesButtonAction(currentDay, currentDayNumber, currentMonth, currentYear);
//         } else {
//           await _handleYesLeaveButtonAction(currentDay, currentDayNumber, currentMonth, currentYear);
//         }
//         break;
//       case 'No':
//         if (type == 'start') {
//           await _handleNoButtonAction(currentDay, currentDayNumber, currentMonth, currentYear);
//         } else {
//           await _handleNoLeaveButtonAction(currentDay, currentDayNumber, currentMonth, currentYear);
//         }
//         break;
//       default:
//         print('Unknown action');
//     }
//
//     if (type == 'start') {
//       setState(() {
//         hasCheckedIn = true;
//       });
//     } else {
//       setState(() {
//         hasLeftWork = true;
//       });
//     }
//   }
//
//   Future<void> _handleYesButtonAction(String currentDay, String currentDayNumber, int currentMonth, int currentYear) async {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     double targetLatitude = 5.6129311;
//     double targetLongitude = -0.1823302;
//     double radius = 100; // in meters
//
//     double distance = Geolocator.distanceBetween(
//       position.latitude,
//       position.longitude,
//       targetLatitude,
//       targetLongitude,
//     );
//
//     String collectionName = distance <= radius ? 'yes_Inside' : 'yes_Outside';
//     String actionText = distance <= radius ? 'Yes I am at work' : 'No I am not at work (Outside)';
//
//     await FirebaseFirestore.instance
//         .collection('Records')
//         .doc('Starting_time')
//         .collection('$currentDayNumber-$currentMonth-$currentYear {$collectionName}')
//         .add({
//       'timestamp': Timestamp.fromDate(DateTime.now().toUtc()),
//       'action': actionText,
//       'dayOfWeek': currentDay,
//       'userEmail': userEmail,
//       'userName': userName,
//     });
//     print('Yes button clicked');
//   }
//
//   Future<void> _handleNoButtonAction(String currentDay, String currentDayNumber, int currentMonth, int currentYear) async {
//     await FirebaseFirestore.instance
//         .collection('Records')
//         .doc('Starting_time')
//         .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
//         .add({
//       'timestamp': Timestamp.fromDate(DateTime.now().toUtc()),
//       'action': 'No I am not at work',
//       'dayOfWeek': currentDay,
//       'userEmail': userEmail,
//       'userName': userName,
//     });
//     print('No button clicked');
//   }
//
//   Future<void> _handleYesLeaveButtonAction(String currentDay, String currentDayNumber, int currentMonth, int currentYear) async {
//     await FirebaseFirestore.instance
//         .collection('ClosingRecords')
//         .doc('Closing_time')
//         .collection('yes_Closed')
//         .add({
//       'timestamp': Timestamp.fromDate(DateTime.now().toUtc()),
//       'action': 'Yes I have left work',
//       'dayOfWeek': currentDay,
//       'userEmail': userEmail,
//       'userName': userName,
//     });
//     print('Yes leave button clicked');
//   }
//
//   Future<void> _handleNoLeaveButtonAction(String currentDay, String currentDayNumber, int currentMonth, int currentYear) async {
//     await FirebaseFirestore.instance
//         .collection('ClosingRecords')
//         .doc('Closing_time')
//         .collection('no_Closed')
//         .add({
//       'timestamp': Timestamp.fromDate(DateTime.now().toUtc()),
//       'action': 'No I have not left work',
//       'dayOfWeek': currentDay,
//       'userEmail': userEmail,
//       'userName': userName,
//     });
//     print('No leave button clicked');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Attendance Notice'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (!hasCheckedIn && isWithinAllowedTime) ...[
//                 const Text(
//                   'Are you at work?',
//                   style: TextStyle(fontSize: 24),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: isWithinAllowedTime && !hasCheckedIn ? () => handleAction('Yes', 'start') : null,
//                   child: const Text('Yes'),
//                 ),
//                 ElevatedButton(
//                   onPressed: isWithinAllowedTime && !hasCheckedIn ? () => handleAction('No', 'start') : null,
//                   child: const Text('No'),
//                 ),
//               ],
//               if (isAfterNoon && !hasLeftWork && isAfterWorkTime) ...[
//                 const Text(
//                   'Attendance Notice!',
//                   style: TextStyle(fontSize: 24),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Have you left work?',
//                   style: TextStyle(fontSize: 24),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: isAfterWorkTime && !hasLeftWork ? () => handleAction('Yes', 'end') : null,
//                   child: const Text('Yes'),
//                 ),
//                 ElevatedButton(
//                   onPressed: isAfterWorkTime && !hasLeftWork ? () => handleAction('No', 'end') : null,
//                   child: const Text('No'),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
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
//     if (record['timestamp'] is String) {
//       record['timestamp'] =
//           Timestamp.fromDate(DateTime.parse(record['timestamp']).toUtc());
//     }
//     return record;
//   }
//
//   Map<String, dynamic> convertTimestampToString(Map<String, dynamic> record) {
//     if (record['timestamp'] is Timestamp) {
//       record['timestamp'] =
//           (record['timestamp'] as Timestamp).toDate().toUtc().toIso8601String();
//     }
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
//             '$currentDayNumber-$currentMonth-$currentYear {yes_Inside}')
//             .where('userEmail', isEqualTo: email)
//             .snapshots(),
//         FirebaseFirestore.instance
//             .collection('Records')
//             .doc('Starting_time')
//             .collection(
//             '$currentDayNumber-$currentMonth-$currentYear {yes_Outside}')
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
//             '$currentDayNumber-$currentMonth-$currentYear {no_option_selected}')
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
//           Timestamp timestamp = data['timestamp'] as Timestamp;
//           DateTime dateTime = timestamp.toDate();
//
//           data['date'] = DateFormat('dd-MM-yyyy').format(dateTime);
//           data['time'] = DateFormat('HH:mm').format(dateTime); // Remove seconds
//           data['dayOfWeek'] = DateFormat('EEEE').format(dateTime);
//           data.remove('userName'); // Clear userName
//           data.remove('userEmail'); // Clear userEmail
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
//         stream: _recordsStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No records found'));
//           } else {
//             List<Map<String, dynamic>> records = snapshot.data!;
//             Map<String, List<Map<String, dynamic>>> groupedRecords = {};
//
//             for (var record in records) {
//               String dateKey =
//                   '${record['dayOfWeek']} ${record['date']}';
//               if (groupedRecords[dateKey] == null) {
//                 groupedRecords[dateKey] = [];
//               }
//               groupedRecords[dateKey]!.add(record);
//             }
//
//             List<String> sortedKeys = groupedRecords.keys.toList();
//             sortedKeys.sort((a, b) {
//               DateTime dateA = DateFormat('EEEE dd-MM-yyyy').parse(a);
//               DateTime dateB = DateFormat('EEEE dd-MM-yyyy').parse(b);
//               return dateB.compareTo(dateA); // Sort in descending order
//             });
//
//             return ListView.builder(
//               itemCount: sortedKeys.length,
//               itemBuilder: (context, index) {
//                 String dateKey = sortedKeys[index];
//                 List<Map<String, dynamic>> dateRecords =
//                 groupedRecords[dateKey]!;
//
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         dateKey,
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     ...dateRecords.map((record) {
//                       return ListTile(
//
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Status: ${record['action']}'),
//                             Text('Date: ${record['date']}'),
//                             Text('Time: ${record['time']}'),
//                             if (record.containsKey('source'))
//                               Text('Source: ${record['source']}'),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   ],
//                 );
//               },
//             );
//           }
//         },
//       ),
//
//     );
//   }
// }
//
// import 'dart:convert';
// import 'dart:io';
// import 'package:attendance_mobile_app/Pages/pie_chart_records_page.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class HomePage extends StatefulWidget {
//   static final GlobalKey<_HomePageState> homePageKey =
//       GlobalKey<_HomePageState>();
//
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State createState() => _HomePageState();
// }
//
// class _HomePageState extends State {
//   List<Map<String, dynamic>> records =
//       []; // Class-level variable to hold records
//
//   int yesInsideCount = 0;
//   int yesOutsideCount = 0;
//   int noCount = 0;
//
//   bool isLoading = true;
//
//   int _additionalTextIndex = 0;
//
//   Duration _averageTimeWithinRadius = Duration.zero;
//
//   Position? _currentPosition;
//   String? _currentAddress;
//
//   String? _imagePath;
//
//   List additionalTexts = [
//     'Customer Sensitivity',
//     'Leadership',
//     'Accountability',
//     'Speed',
//     'Shared Vision and Mindset',
//     'Innovation',
//     'Effectiveness',
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProfileImage();
//     _loadAdditionalTextIndex();
//     _saveUserDetails();
//     _getCurrentLocation();
//
//     _loadRecordsFromSharedPreferences().then((loadedRecords) {
//       setState(() {
//         records = loadedRecords; // Store loaded records in the class variable
//         _updateCounts(records);
//         _calculateAverageTimeWithinRadius(records);
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
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(position.latitude, position.longitude);
//     Placemark place = placemarks[0];
//     setState(() {
//       _currentAddress =
//           "${place.locality}, ${place.postalCode}, ${place.country}";
//     });
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
//       List jsonList = jsonDecode(jsonString);
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
//   Future<void> _calculateAverageTimeWithinRadius(
//       List<Map<String, dynamic>> records) async {
//     int totalMinutes = 0;
//     int count = 0;
//
//     for (var record in records) {
//       if (record['action'] == 'Yes I am at work' && record['time'] != null) {
//         DateTime recordTime = DateTime.parse(record['time']);
//         totalMinutes += recordTime.hour * 60 + recordTime.minute;
//         count++;
//       }
//     }
//
//     if (count > 0) {
//       setState(() {
//         _averageTimeWithinRadius = Duration(minutes: totalMinutes ~/ count);
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
//   Future<void> _loadAdditionalTextIndex() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _additionalTextIndex = prefs.getInt('additionalTextIndex') ?? 0;
//     });
//   }
//
//   Future<void> _saveAdditionalTextIndex(int newIndex) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('additionalTextIndex', newIndex);
//     setState(() {
//       _additionalTextIndex = newIndex;
//     });
//   }
//
//   Future<void> _loadProfileImage() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _imagePath = prefs.getString('profile_image');
//     });
//   }
//
//   void _onSectionTapped(String section) {
//     // Filter records based on the tapped section
//     List<Map<String, dynamic>> filteredRecords =
//         _filterRecordsBySection(records, section);
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => RecordsPage(
//           section: section,
//           records: filteredRecords,
//         ),
//       ),
//     );
//   }
//
//   List<Map<String, dynamic>> _filterRecordsBySection(
//       List<Map<String, dynamic>> records, String section) {
//     switch (section) {
//       case 'Yes (Inside)':
//         return records
//             .where((record) => record['action'] == 'Yes I am at work')
//             .toList();
//       case 'Yes (Outside)':
//         return records
//             .where(
//                 (record) => record['action'] == 'No I am not at work (Outside)')
//             .toList();
//       case 'No':
//         return records
//             .where((record) => record['action'] == 'No I am not at work')
//             .toList();
//       default:
//         return [];
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         actions: [
//           _imagePath == null
//               ? IconButton(
//                   icon: const Icon(Icons.person),
//                   onPressed: () {
//                     // Handle icon press if needed
//                   },
//                 )
//               : GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ImageScreen(_imagePath!),
//                       ),
//                     );
//                   },
//                   child: CircleAvatar(
//                     backgroundImage: FileImage(File(_imagePath!)),
//                     radius: 20,
//                   ),
//                 ),
//           IconButton(
//             icon: const Icon(Icons.settings),
//             onPressed: () {
//               Navigator.pushNamed(context, '/settings').then((_) {
//                 _saveAdditionalTextIndex(
//                     (_additionalTextIndex + 1) % additionalTexts.length);
//               });
//             },
//           ),
//         ],
//         title: const Text('Home Page'),
//       ),
//       body: isLoading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     if (_currentPosition != null && _currentAddress != null)
//                       Column(
//                         children: [
//                           Text(
//                             'Coordinates: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Location: $_currentAddress',
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                           const SizedBox(height: 16),
//                         ],
//                       ),
//                     Center(
//                       child: SizedBox(
//                         height: 400,
//                         width: 400,
//                         child: PieChart(
//                           PieChartData(
//                             sections: [
//                               PieChartSectionData(
//                                 color: Colors.green,
//                                 // value: yesInsideCount.toDouble(),
//                                 badgeWidget: GestureDetector(
//                                   onTap: () => _onSectionTapped('Yes (Inside)'),
//                                   child: _buildIcon('Yes (Inside)'),
//                                 ),
//                                 badgePositionPercentageOffset: 0.7,
//                                 radius: 80,
//                               ),
//                               PieChartSectionData(
//                                 color: Colors.orange,
//                                 // value: yesOutsideCount.toDouble(),
//                                 badgeWidget: GestureDetector(
//                                   onTap: () =>
//                                       _onSectionTapped('Yes (Outside)'),
//                                   child: _buildIcon('Yes (Outside)'),
//                                 ),
//                                 badgePositionPercentageOffset: 0.5,
//                                 radius: 70,
//                               ),
//                               PieChartSectionData(
//                                 color: Colors.red,
//                                 // value: noCount.toDouble(),
//                                 badgeWidget: GestureDetector(
//                                   onTap: () => _onSectionTapped('No'),
//                                   child: _buildIcon('No'),
//                                 ),
//                                 badgePositionPercentageOffset: 0.5,
//                                 radius: 70,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Column(
//                       children: [
//                         _buildLegendItem(
//                             Colors.green, 'Checked In (Within geolocator)'),
//                         _buildLegendItem(
//                             Colors.orange, 'Checked In (Outside geolocator)'),
//                         _buildLegendItem(Colors.red, 'Not Checked In'),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     if (_averageTimeWithinRadius != Duration.zero)
//                       Text(
//                         'Average Time Within Radius: '
//                         '${_averageTimeWithinRadius.inHours}h ${_averageTimeWithinRadius.inMinutes % 60}m',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     const SizedBox(height: 16),
//                     Text(
//                       additionalTexts[_additionalTextIndex],
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushNamed(context, '/atnp');
//                       },
//                       child: const Text('Check In',
//                           style: TextStyle(fontSize: 25)),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushNamed(context, '/views');
//         },
//         child: const Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Icon(Icons.remove_red_eye_rounded),
//             Padding(
//               padding: EdgeInsets.fromLTRB(1, 0, 2, 1),
//               child: Text('Records'),
//             ),
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
// class ImageScreen extends StatelessWidget {
//   final String imagePath;
//
//   const ImageScreen(this.imagePath, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back_ios),
//         ),
//       ),
//       body: Center(
//         child: Image.file(File(imagePath)),
//       ),
//     );
//   }
// }

// @pragma("vm:entry-point")
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     switch (task) {
//       case "work_hourly":
//         await Firebase.initializeApp();
//         NotificationService.showNotification(
//             "Attendance Notice!", "Are you at work?");
//         NotificationService.showNotificationAt5(
//             "Attendance Notice!", "Have you closed?");
//         break;
//     }
//     return Future.value(true);
//   });
// }
// import 'package:flutter/material.dart';
//
// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Profile')),
//
//       body:const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             CircleAvatar(
//               radius: 65,
//             ),
//             SizedBox(height: 30),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Text('Name: '),
//                 SizedBox(height: 20),
//                 Text('Email: '),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
// void _signIn() async {
//   if (_formKey.currentState?.validate() ?? false) {
//     setState(() {
//       isLoading = true; // Set loading state to true
//     });
//     try {
//       // String userName = _userName.text;
//       String userEmail = _userEmail.text;
//       String userPassword = _userPassword.text;
//
//       User? user =
//           await _auth.signInWithEmailAndPassword(userEmail, userPassword);
//
//       if (user != null) {
//         print('User is successfully Signed In ');
//
//         Navigator.pushNamed(context, '/home');
//
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         // prefs.setString('UserName', userName);
//         prefs.setString('userPassword', userPassword);
//         prefs.setString('userEmail', userEmail);
//       } else {
//         print('ERROR');
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Sign In  Failed. Try Again!! '),
//             backgroundColor: Colors.red, // Optionally set a background color
//             duration: Duration(seconds: 3), // Duration to show the SnackBar
//           ),
//         );
//       }
//     } catch (e, s) {
//       print('Error');
//       print(s);
//     } finally {
//       setState(() {
//         isLoading = false; // Set loading state to true
//       });
//     }
//   }
// }
//}

// import 'package:attendance_mobile_app/Auth_implementations_services/auth_services.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class AuthPage extends StatefulWidget {
//   const AuthPage({super.key});
//
//   @override
//   State<AuthPage> createState() => _AuthPageState();
// }
//
// class _AuthPageState extends State<AuthPage> {
//   late SharedPreferences prefs;
//
//   final _formKey = GlobalKey<FormState>();
//   final FirebaseAuthService _auth = FirebaseAuthService();
//   bool _isPasswordVisible = true;
//
//   bool isLoading = false;
//
//   final TextEditingController _userName = TextEditingController();
//   final TextEditingController _userEmail = TextEditingController();
//   final TextEditingController _userPassword = TextEditingController();
//
//   String? _selectedDepartment;
//
//   @override
//   void dispose() {
//     super.dispose();
//     _userName.dispose();
//     _userEmail.dispose();
//     _userPassword.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     initPrefs();
//   }
//
//   initPrefs() async {
//     prefs = await SharedPreferences.getInstance();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text('Welcome'),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     const Text('-------Sign In-------'),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     SizedBox(
//                       width: 300,
//                       child: TextFormField(
//                         validator: (name) => name == null || name.isEmpty
//                             ? 'Field Required'
//                             : (name.length < 4 ? 'Enter full name' : null),
//                         controller: _userName,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           label: const Text('Enter your name'),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     SizedBox(
//                       width: 300,
//                       child: TextFormField(
//                         controller: _userEmail,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           label: const Text('Enter your email'),
//                         ),
//                         validator: (email) {
//                           if (email == null || email.isEmpty) {
//                             return 'Field required';
//                           }
//                           String pattern =
//                               r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'; // Basic email pattern
//                           RegExp regex = RegExp(pattern);
//                           if (!regex.hasMatch((email))) {
//                             return ' Enter valid email';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     SizedBox(
//                       width: 300,
//                       child: DropdownButtonFormField<String>(
//                         value: _selectedDepartment,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           label: const Text('Select your department'),
//                         ),
//                         items: const [
//                           DropdownMenuItem(
//                             value: 'Software Development',
//                             child: Text('Software Development'),
//                           ),
//                           DropdownMenuItem(
//                             value: 'Systems Integration',
//                             child: Text('Systems Integration'),
//                           ),
//                           DropdownMenuItem(
//                             value: 'IT Consulting',
//                             child: Text('IT Consulting'),
//                           ),
//                         ],
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedDepartment = value;
//                           });
//                         },
//                         validator: (value) =>
//                         value == null ? 'Field required' : null,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: isLoading
//                           ? const CircularProgressIndicator()
//                           : ElevatedButton(
//                         onPressed: _checkDetails,
//                         child: const Text('Check Details'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _checkDetails() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       setState(() {
//         isLoading = true; // Set loading state to true
//       });
//       try {
//         String userName = _userName.text;
//         String userEmail = _userEmail.text;
//         String department = _selectedDepartment!;
//
//         DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(userEmail)
//             .get();
//
//         if (userSnapshot.exists &&
//             userSnapshot.get('name') == userName &&
//             userSnapshot.get('department') == department) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Inputed details are correct'),
//               backgroundColor: Colors.green,
//               duration: Duration(seconds: 3),
//             ),
//           );
//           _showPasswordDialog();
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Details are incorrect. Try Again!!'),
//               backgroundColor: Colors.red,
//               duration: Duration(seconds: 3),
//             ),
//           );
//         }
//       } catch (e) {
//         print('Error: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('An error occurred. Try Again!!'),
//             backgroundColor: Colors.red,
//             duration: Duration(seconds: 3),
//           ),
//         );
//       } finally {
//         setState(() {
//           isLoading = false; // Set loading state to false
//         });
//       }
//     }
//   }
//
//   void _showPasswordDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         final TextEditingController passwordController =
//         TextEditingController();
//         final TextEditingController confirmPasswordController =
//         TextEditingController();
//         final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
//
//         return AlertDialog(
//           title: const Text('Set Password'),
//           content: Form(
//             key: _passwordFormKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextFormField(
//                   controller: passwordController,
//                   obscureText: true,
//                   decoration: const InputDecoration(
//                     labelText: 'Password',
//                     hintText: 'At least 6 characters with a number',
//                   ),
//                   validator: (value) {
//                     if (value!.length < 6) {
//                       return 'Password must be at least 6 characters long';
//                     }
//                     if (!value.contains(RegExp(r'\d'))) {
//                       return 'Password must contain at least one number';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: confirmPasswordController,
//                   obscureText: true,
//                   decoration: const InputDecoration(
//                     labelText: 'Confirm Password',
//                   ),
//                   validator: (value) {
//                     if (value != passwordController.text) {
//                       return 'Passwords do not match';
//                     }
//                     return null;
//                   },
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 if (_passwordFormKey.currentState?.validate() ?? false) {
//                   String userEmail = _userEmail.text;
//                   String userPassword = passwordController.text;
//
//                   try {
//                     User? user = await _auth.signInWithEmailAndPassword(
//                         userEmail, userPassword, _userName.text);
//
//                     if (user != null) {
//                       Navigator.pop(context);
//                       Navigator.pushNamed(context, '/home');
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Authentication Failed. Try Again!!'),
//                           backgroundColor: Colors.red,
//                           duration: Duration(seconds: 3),
//                         ),
//                       );
//                     }
//                   } catch (e) {
//                     print('Error: $e');
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('An error occurred. Try Again!!'),
//                         backgroundColor: Colors.red,
//                         duration: Duration(seconds: 3),
//                       ),
//                     );
//                   }
//                 }
//               },
//               child: const Text('Authenticate'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
// void _showRecordsDialog(String section, List<Map<String, dynamic>> records) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text('Records for $section'),
//         content: Container(
//           width: double.maxFinite,
//           child: ListView.builder(
//             shrinkWrap: true,
//             itemCount: records.length,
//             itemBuilder: (context, index) {
//               Map<String, dynamic> record = records[index];
//               return ListTile(
//                 title: Text(record['date'] ?? 'No Date'),
//                 subtitle: Text(record['dayOfWeek'] ?? 'No Day'),
//                 trailing: Text(record['time'] ?? 'No Time'),
//               );
//             },
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('Close'),
//           ),
//         ],
//       );
//     },
//   );
// }

// void _onSectionTapped(String section) async {
//   List<Map<String, dynamic>> records = await _fetchRecords(section);
//   _showRecordsDialog(section, records);
// }
// showDialog(
//   context: context,
//   builder: (BuildContext context) {
//     return AlertDialog(
//       content: const ProfilePage(),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Text('Close'),
//         ),
//       ],
//     );
//   },
// );
