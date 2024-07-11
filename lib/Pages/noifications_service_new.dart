import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Notifications
  // (
  // Display message with buttons-done
  // Adding geolocation-done
  // Recording actions to firestore- fixed
  //add a date range- done
  // displaying records (automatically delete after a month)-
  //Fix location access permissions-done
  //Splash screen -  needs work
  //Notifications adjustment -
  //Profile page and settings page completion -
  //Views Page
  //
  //)

  static Future<void> onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {}

  static Future<void> onActionReceived(receivedAction) async {
    // Get the current month and year
    try {
      await Firebase.initializeApp();

      // Retrieve the user's name from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userName = prefs.getString('UserName') ?? 'Unknown User';
      String? userEmail = prefs.getString('userEmail') ?? 'Unknown Email';

      DateTime now = DateTime.now();
      int currentMonth = now.month;
      int currentYear = now.year;
      String currentDay =
          DateFormat('EEEE').format(now); // Get the day of the week

      // Check the actionId to determine which button was clicked
      switch (receivedAction.actionId) {
        case 'Yes_Button':
          // Get the user's current position
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          // Define the target coordinate and radius
          double targetLatitude = 5.6129311;
          double targetLongitude = -0.1823302;
          double radius = 100; // in meters

          double distance = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            targetLatitude,
            targetLongitude,
          );

          // Check if the user is within the specified radius
          if (distance <= radius) {
            // Save "Yes im at work" with the current time to Firestore
            await FirebaseFirestore.instance
                .collection('Records')
                .doc('Starting_time')
                .collection('$currentMonth-$currentYear-$currentDay')
                .doc('yes-$currentDay')
                .collection('Yes')
                .add({
              'timestamp': Timestamp.now(),
              'action': 'Yes im at work',
              'dayOfWeek': currentDay,
              'userEmail': userEmail ?? 'Unknown',
              'userName': userName ?? 'Unknown',
            });
            print('Yes button clicked inside radius');
          } else {
            // Save "Yes outside the geolocator radius" with the current user's time to Firestore
            await FirebaseFirestore.instance
                .collection('Records')
                .doc('Starting_time')
                .collection('$currentMonth-$currentYear-$currentDay')
                .doc('Yes_Outside-$currentDay')
                .collection('Yes_Outside')
                .add({
              'timestamp': Timestamp.now(),
              'action': 'No im not at work',
              'dayOfWeek': currentDay,
              'userEmail': userEmail ?? 'Unknown',
              'userName': userName ?? 'Unknown',
            });
            print('Yes button clicked outside radius');
          }
          break;
        case 'No_Button':
          // Save "No action" with the current users time to Firestore
          await FirebaseFirestore.instance
              .collection('Records')
              .doc('Starting_time')
              .collection('$currentMonth-$currentYear-$currentDay')
              .doc('No-$currentDay')
              .collection('No')
              .add({
            'timestamp': Timestamp.now(),
            'action': 'No im not at work',
            'dayOfWeek': currentDay,
            'userEmail': userEmail ?? 'Unknown',
            'userName': userName ?? 'Unknown',
          });
          print('No button clicked');
          // Save "No im not at work" with the current time to Firestore
          await FirebaseFirestore.instance
              .collection('Records')
              .doc('Starting_time')
              .collection('$currentMonth-$currentYear-$currentDay')
              .doc('No-$currentDay')
              .collection('No')
              .add({
            'timestamp': Timestamp.now(),
            'action': 'No im not at work',
            'dayOfWeek': currentDay,
            'userEmail': userEmail ?? 'Unknown',
            'userName': userName ?? 'Unknown',
          });
          break;
        default:
          print('Other action or notification clicked');
      }
    } catch (e) {
      print('Error in onActionReceive: $e');
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

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  static Future<void> showNotification(String title, String body) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      // iOS: DarwinNotificationDetails(),
      android: AndroidNotificationDetails(
        "channelId",
        "channelName",
        importance: Importance.max,
        priority: Priority.high,
        icon: "mipmap/ic_launcher",
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction('Yes_Button', 'Yes'),
          AndroidNotificationAction('No_Button', 'No'),
        ],
      ),
    );
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Attendance Notice!',
      'Are you at work?',
      _nextInstanceOfEightAM(),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _nextInstanceOfEightAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 8);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}

Future<void> scheduleDailyNotifications() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          'daily_notification_channel_id', 'Daily Notifications',
          importance: Importance.max, priority: Priority.max);
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
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
          AndroidInitializationSettings("mipmap/ic_launcher");
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: (e) {
        print('object');
      });
      flutterLocalNotificationsPlugin.show(
          0,
          'Title',
          'body',
          const NotificationDetails(
              android: AndroidNotificationDetails('channelId', 'channelName',
                  icon: "mipmap/ic_launcher", //add app icon here
                  importance: Importance.high,
                  actions: <AndroidNotificationAction>[
                AndroidNotificationAction('Yes_Button', 'Yes'),
                AndroidNotificationAction('No_Button', 'No'),
              ])));
      print('ended');
      return Future.value(true);
    } catch (e) {
      print(e);
      return Future.value(false);
    }
  });
}

Permission_Checker() async {
  // Request location permission
  PermissionStatus status = await Permission.location.request();

  // Check the permission status
  if (status.isGranted) {
    // If Permission granted,
    print('Location permission granted');
  } else if (status.isDenied) {
    // If Permission denied,
    print('Location permission denied');
  }
}

Permission_Checker_2() async {
  // Request location permission
  PermissionStatus status = await Permission.notification.request();

  // Check the permission status
  if (status.isGranted) {
    // If Permission granted,
    print('Location permission granted');
  } else if (status.isDenied) {
    // If Permission denied,
    print('Location permission denied');
  }
}
