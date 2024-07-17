import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService_2 {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {}

  static Future<void> onActionReceived(receivedAction) async {
    try {
      await Firebase.initializeApp();

      //Retrive user details
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userName = prefs.getString('UserName') ?? 'Unknown User';
      String? userEmail = prefs.getString('userEmail') ?? 'Unknown Email';

      DateTime now = DateTime.now();
      int currentMonth = now.month;
      int currentYear = now.year;

      String currentDay = DateFormat('EEEE').format(now);
      String currentDayNumber = DateFormat('d').format(now);

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      switch (receivedAction.actionId) {
        case 'Yes_Button_Id':
          await firestore
              .collection('ClosingRecords')
              .doc('Ending_time')
              .collection('$currentDayNumber-$currentMonth-$currentYear')
              .add({
            'timeStamp': Timestamp.now(),
            'action': 'Yes I have closed',
            'dayOfWeek': currentDay,
            'userEmail': userEmail ?? 'unknown Email',
            'userName': userName ?? 'unknown Name',
          });
          print('Submitted successfully');

          break;

        case 'No_Button_Id':
          await firestore
              .collection('ClosingRecords')
              .doc('EndingTime')
              .collection('$currentDayNumber-$currentMonth-$currentYear')
              .add({
            'timeStamp': Timestamp.now(),
            'action': 'No I have not closed',
            'dayOfWeek': currentDay,
            'userEmail': userEmail ?? 'Unknown',
            'userName': userName ?? 'unknown',
          });
          print('No submitted successfully');

          break;
        default:
          print('Error happened');
      }
    } catch (e) {
      print('Error:$e');
    }
  }

  static Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("mipmap/ic_launcher");

    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: onActionReceived,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  static Future<void> showNotification(String title, String body) async {
    tz.TZDateTime _notificationAt5AM() {
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate =
          tz.TZDateTime(tz.local, now.year, now.month, now.day, 10, 30);
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
      return scheduledDate;
    }

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      // iOS: DarwinNotificationDetails(),
      android: AndroidNotificationDetails(
        "channelId_2",
        "channelName_2",
        importance: Importance.max,
        priority: Priority.high,
        icon: "mipmap/ic_launcher",
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction('Yes_Button_Id', 'Yes'),
          AndroidNotificationAction('No_Button_Id', 'No'),
        ],
      ),
    );
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Attendance Notice!',
      'Have you closed?',
      _notificationAt5AM(),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleDailyNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isNotificationScheduled =
        prefs.getBool('isScheduledNotificationActive_2') ?? false;

    if (!isNotificationScheduled) {
      await showNotification('Attendance Notice', 'Have you closed?');
      await prefs.setBool('isScheduledNotificationActive_2', true);
    }
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'daily_notification_channel_id', 'Daily Notifications',
            importance: Importance.max, priority: Priority.max);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
  }
}
