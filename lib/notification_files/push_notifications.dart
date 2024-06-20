// import 'package:firebase_messaging/firebase_messaging.dart';

// class PushNotifications {
//   static final _firebaseMessaging = FirebaseMessaging.instance;
//
//   static Future init() async {
//     await _firebaseMessaging.requestPermission(
//       provisional: false,
//       sound: true,
//       badge: true,
//       alert: true,
//       criticalAlert: false,
//       announcement: true,
//       carPlay: false,
//     );
//     final token = await _firebaseMessaging.getToken();
//     print('Device token is $token');
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    // Initialize time zones
    tz.initializeTimeZones();
    tz.setLocalLocation(
        tz.getLocation('Accra/Ghana')); // Set your local time zone here

    _initializeNotifications();
    _fetchAndScheduleNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
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
      },
    );

    // Create a notification channel for Android 8.0 and above
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'your_channel_id', // id
      'your_channel_name', // name
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _fetchAndScheduleNotifications() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
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
    // Parse the start and end times
    TimeOfDay start = _parseTime(startTime);
    TimeOfDay end = _parseTime(endTime);

    // Schedule notifications within the interval
    for (int hour = start.hour; hour <= end.hour; hour++) {
      _scheduleNotificationForTime(hour, start.minute);
    }
  }

  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> _scheduleNotificationForTime(int hour, int minute) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      // Schedule for the next day if the time has already passed for today
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      hour, // Use a unique ID for each notification
      'Reminder',
      'This is your scheduled notification.',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          importance: Importance.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Scheduler'),
      ),
      body: const Center(
        child: Text(
          'Notifications are scheduled based on your settings.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
