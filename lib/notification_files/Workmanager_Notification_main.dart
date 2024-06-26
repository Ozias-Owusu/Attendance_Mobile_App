import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';


showNotification() async {
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('currency');
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
          android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        icon: "currency", //add app icon here
        importance: Importance.high,
      )));
  print('ended');
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
          AndroidInitializationSettings('launcher');
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
              android: AndroidNotificationDetails(
            'channelId',
            'channelName',
            icon: "launcher", //add app icon here
            importance: Importance.high,
          )));
      print('ended');
      return Future.value(true);
    } catch (e) {
      print(e);
      return Future.value(false);
    }
  });
}

void schdeduleNotification(){
  Workmanager()
      .initialize(callbackDispatcher, isInDebugMode: false);
  Workmanager().registerPeriodicTask(
      "First Notification", "Scheduled Notifications",
      tag: 'Scheduled Task',
      frequency: const Duration(minutes: 20),
      initialDelay: const Duration(seconds: 10),
  );

}

class NotificationScheduler extends StatefulWidget {
  const NotificationScheduler({super.key});

  @override
  State<NotificationScheduler> createState() => _NotificationSchedulerState();
}

class _NotificationSchedulerState extends State<NotificationScheduler> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  schdeduleNotification;
                },
                child: const Text('Schedule notifications'))
          ],
        ),
      ),


    );
  }
}
