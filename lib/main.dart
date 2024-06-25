import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import 'Pages/AuthPage.dart';
import 'Pages/HomePage.dart';
import 'firebase_options.dart';
import 'notification_files/Workmanager_Notification_main.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  Workmanager().registerOneOffTask("task-identifier", "simpleTask");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (_) => const AuthPage(),
        '/home': (_) => const HomePage(),
        '/wmn': (_) => const NotificationScheduler(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/wmn') {
          final value = settings.arguments as int;
          return MaterialPageRoute(
              builder: (_) => const NotificationScheduler());
        }
        return null;
      },
    );
  }
}
