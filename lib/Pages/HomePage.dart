import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _loadSavedTimes();
    _initializeNotifications();
    _fetchAndScheduleNotifications();
  }

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Accra/Ghana'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tapped logic here, if needed
        Navigator.pushNamed(context, '/home');
      },
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      '0', // id
      'CHANNEL 1', // name
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _loadSavedTimes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String? startTime = prefs.getString('startTime');
      String? endTime = prefs.getString('endTime');

      if (startTime != null) {
        _startTime = TimeOfDay(
          hour: int.parse(startTime.split(":")[0]),
          minute: int.parse(startTime.split(":")[1]),
        );
      }
      if (endTime != null) {
        _endTime = TimeOfDay(
          hour: int.parse(endTime.split(":")[0]),
          minute: int.parse(endTime.split(":")[1]),
        );
      }
    });
  }

  Future<void> _fetchAndScheduleNotifications() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch notification settings from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('notificationsTimer')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        var notificationSettings = userDoc.get('notificationsTimer');
        String startTime = notificationSettings['start'];
        String endTime = notificationSettings['end'];

        _scheduleNotifications(startTime, endTime);
      }
    }
  }

  void _scheduleNotifications(String startTime, String endTime) {
    // Parse the start and end times from Firestore or SharedPreferences
    TimeOfDay start = _parseTime(startTime);
    TimeOfDay end = _parseTime(endTime);

    // Use the earliest start time and the latest end time
    if (_startTime != null &&
        (_startTime!.hour < start.hour ||
            (_startTime!.hour == start.hour &&
                _startTime!.minute < start.minute))) {
      start = _startTime!;
    }

    if (_endTime != null &&
        (_endTime!.hour > end.hour ||
            (_endTime!.hour == end.hour && _endTime!.minute > end.minute))) {
      end = _endTime!;
    }

    // Log the times for debugging
    print('Scheduling notifications between $start and $end');

    // Schedule notifications within the interval
    for (int minute = start.minute; minute <= end.minute; minute++) {
      _scheduleNotificationForTime(minute, start.minute);
    }
  }

  TimeOfDay _parseTime(String timeStr) {
    if (timeStr.isEmpty) {
      throw const FormatException('Empty time string');
    }

    List<String> parts = timeStr.split(':');
    if (parts.length != 2) {
      throw FormatException('Invalid time format: $timeStr');
    }

    int hour = int.tryParse(parts[0]) ?? 0;
    int minute = int.tryParse(parts[1]) ?? 0;

    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      throw FormatException('Invalid time values: $timeStr');
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> _scheduleNotificationForTime(int hour, int minute) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    // Log the scheduled date for debugging
    print('Scheduling notification for: $scheduledDate');

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(minutes: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Use a unique ID for each notification
      'Reminder',
      'This is your scheduled notification.',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '0',
          'CHANNEL 1',
          importance: Importance.max,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
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
                  Navigator.pushNamed(context, '/');
                },
                child: const Text('Log Out')),
            const SizedBox(
              height: 10,
            ),
            // ElevatedButton(
            //     onPressed: () {
            //       Navigator.pushNamed(context, '/pnotification');
            //     },
            //     child: const Text('Push notification page '))
          ],
        ),
      ),
    );
  }
}

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;

  static Future init() async {
    await _firebaseMessaging.requestPermission(
      provisional: true,
      sound: true,
      badge: true,
      alert: true,
      criticalAlert: true,
      announcement: true,
      carPlay: false,
    );
    final token = await _firebaseMessaging.getToken();
    print('Device token is $token');
  }
}

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
