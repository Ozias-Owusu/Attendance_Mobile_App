import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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
      String currentDayNumber =
          DateFormat('d').format(now); // Get the day number of the month

      switch (receivedAction.id) {
        // Change to `id` instead of `actionId` to get the notification ID
        case 0: // Notification ID for "Are you at work?"
          switch (receivedAction.actionId) {
            case 'Yes_Button':
              // Handle "Yes" button for the 8 AM notification
              await handleYesButtonAction(userName, userEmail, currentDay,
                  currentDayNumber, currentMonth, currentYear);
              break;
            case 'No_Button':
              // Handle "No" button for the 8 AM notification
              await handleNoButtonAction(userName, userEmail, currentDay,
                  currentDayNumber, currentMonth, currentYear);
              break;
          }
          break;

        case 1: // Notification ID for "Have you closed?"
          switch (receivedAction.actionId) {
            case 'Yes_Button':
              // Handle "Yes" button for the 5 PM notification
              await handleYesButtonActionAt5(userName, userEmail, currentDay,
                  currentDayNumber, currentMonth, currentYear);
              break;
            case 'No_Button':
              // Handle "No" button for the 5 PM notification
              await handleNoButtonActionAt5(userName, userEmail, currentDay,
                  currentDayNumber, currentMonth, currentYear);
              break;
          }
          break;

        default:
          print('Other action or notification clicked');
      }
    } catch (e) {
      print('Error in onActionReceive: $e');
    }
  }

  static Future<void> handleYesButtonAction(
      String userName,
      String userEmail,
      String currentDay,
      String currentDayNumber,
      int currentMonth,
      int currentYear) async {
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
          .collection(
              '$currentDayNumber-$currentMonth-$currentYear {yes_Inside}')
          .add({
        'timestamp': Timestamp.fromDate(DateTime.now().toUtc()),
        'action': 'Yes I am at work',
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
          .collection(
              '$currentDayNumber-$currentMonth-$currentYear {yes_Outside}')
          .add({
        'timestamp': Timestamp.fromDate(DateTime.now().toUtc()),
        'action': 'No I am not at work(Outside)',
        'dayOfWeek': currentDay,
        'userEmail': userEmail ?? 'Unknown',
        'userName': userName ?? 'Unknown',
      });
      print('Yes button clicked outside radius');
    }
  }

  static Future<void> handleNoButtonAction(
      String userName,
      String userEmail,
      String currentDay,
      String currentDayNumber,
      int currentMonth,
      int currentYear) async {
    // Save "No action" with the current users time to Firestore
    await FirebaseFirestore.instance
        .collection('Records')
        .doc('Starting_time')
        .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
        .add({
      'timestamp': Timestamp.fromDate(DateTime.now().toUtc()),
      'action': 'No I am not at work',
      'dayOfWeek': currentDay,
      'userEmail': userEmail ?? 'Unknown',
      'userName': userName ?? 'Unknown',
    });
    print('No button clicked');
  }

  static Future<void> handleYesButtonActionAt5(
      String userName,
      String userEmail,
      String currentDay,
      String currentDayNumber,
      int currentMonth,
      int currentYear) async {
    // Save "Yes I have closed" with the current time to Firestore in a different collection
    await FirebaseFirestore.instance
        .collection('ClosingRecords')
        .doc('Closing_time')
        .collection('$currentDayNumber-$currentMonth-$currentYear {yes_Closed}')
        .add({
      'timestamp': Timestamp.fromDate(DateTime.now().toUtc()),
      'action': 'Yes I have closed',
      'dayOfWeek': currentDay,
      'userEmail': userEmail ?? 'Unknown',
      'userName': userName ?? 'Unknown',
    });
    print('Yes button clicked at closing time');
  }

  static Future<void> handleNoButtonActionAt5(
      String userName,
      String userEmail,
      String currentDay,
      String currentDayNumber,
      int currentMonth,
      int currentYear) async {
    // Save "No I have not closed" with the current time to Firestore in a different collection
    await FirebaseFirestore.instance
        .collection('ClosingRecords')
        .doc('Closing_time')
        .collection('$currentDayNumber-$currentMonth-$currentYear {no_Closed}')
        .add({
      'timestamp': Timestamp.fromDate(DateTime.now().toUtc()),
      'action': 'No I have not closed',
      'dayOfWeek': currentDay,
      'userEmail': userEmail ?? 'Unknown',
      'userName': userName ?? 'Unknown',
    });
    print('No button clicked at closing time');
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

    // Schedule background tasks for notifications
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );

    await Workmanager().registerPeriodicTask(
      "work_8_am",
      "work_8_am",
      frequency: const Duration(hours: 24),
      initialDelay: const Duration(seconds: 10),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );

    await Workmanager().registerPeriodicTask(
      "work_5_pm",
      "work_5_pm",
      frequency: const Duration(hours: 24),
      initialDelay: const Duration(seconds: 10),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );
  }

  static Future showNotification(String title, String body) async {
    tz.TZDateTime _notificationAt8AM() {
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate =
          tz.TZDateTime(tz.local, now.year, now.month, now.day, 8);
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
      return scheduledDate;
    }

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
      title,
      body,
      _notificationAt8AM(),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> showNotificationAt5(String title, String body) async {
    tz.TZDateTime _notificationAt5PM() {
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate =
          tz.TZDateTime(tz.local, now.year, now.month, now.day, 17);
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
      return scheduledDate;
    }

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      // iOS: DarwinNotificationDetails(),
      android: AndroidNotificationDetails(
        "channelId5",
        "channelName5",
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
        1, title, body, platformChannelSpecifics); // Notification ID set to 1

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1, // Notification ID set to 1
      title,
      body,
      _notificationAt5PM(),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}

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

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case "work_8_am":
        await NotificationService.showNotification(
            "Attendance Notice!", "Are you at work?");
        break;
      case "work_5_pm":
        await NotificationService.showNotificationAt5(
            "Attendance Notice!", "Have you closed?");
        break;
      default:
        break;
    }
    return Future.value(true);
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
