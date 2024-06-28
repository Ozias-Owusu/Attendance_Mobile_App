

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

class NotificationService{
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async{

  }

  static Future<void> onActionReceived(receivedAction) async{
    // Check the actionId to determine which button was clicked
    switch (receivedAction.actionId) {
      case 'Yes_Button':
        print('yes button clicked');
        break;
      case 'No_Button':
        print('no button clicked');
        break;
      default:
        print('other action or notification clicked');
    }
  }

  static Future<void>init( ) async{

    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings("mipmap/ic_launcher");

    const DarwinInitializationSettings iOSInitializationSettings =
    DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveNotificationResponse: onActionReceived);


    await flutterLocalNotificationsPlugin.
    resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();


    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestExactAlarmsPermission();


  }
  static Future<void> showNotification(String title, String body) async{
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      // iOS: DarwinNotificationDetails(),
      android: AndroidNotificationDetails("channelId",
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
    await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics);
  }
  @pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
  void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      try{
        print('started');
        print("Native called background task: $task"); //simpleTask will be emitted here.
        FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
        const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('currency');
        const InitializationSettings initializationSettings = InitializationSettings(
            android: initializationSettingsAndroid);
        await flutterLocalNotificationsPlugin.initialize(initializationSettings,
            onDidReceiveNotificationResponse: (e){
              print('object');
            });
        flutterLocalNotificationsPlugin.show(0, 'Title', 'body'
            ,const NotificationDetails( android: AndroidNotificationDetails(
              'channelId',
              'channelName',
              icon: "currency", //add app icon here
              importance: Importance.high,
                // actions: <AndroidNotificationAction>[
                //   AndroidNotificationAction('Yes_Button', 'Yes'),
                //   AndroidNotificationAction('No_Button', 'No'),
                // ]
            )));
        print('ended');
        return Future.value(true);
      } catch(e){
        print(e);
        return Future.value(false);
      }
    });
  }
}