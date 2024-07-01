import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {}

  // Notifications
  // (
  // Display message with buttons-done
  // Adding geolocation-done
  // Recording actions-
  // displaying records (automatically delete after a month)-
  //Fix location access permissions
  //)

  static Future<void> onActionReceived(receivedAction) async {
    // Check the actionId to determine which button was clicked
    switch (receivedAction.actionId) {
      case 'Yes_Button':
        // Get the user's current position
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        // Define the target coordinate and radius
        double targetLatitude = 37.7749;
        double targetLongitude = -122.4194;
        double radius = 100; // in meters

        double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          targetLatitude,
          targetLongitude,
        );

        // Check if the user is within the specified radius
        if (distance <= radius) {
          print('Yes button clicked (within radius)');
        } else {
          print('Yes button clicked (outside radius)');
        }
        break;
      case 'No_Button':
        print('No button clicked');
        break;
      default:
        print('Other action or notification clicked');
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
  }
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
