import 'package:attendance_mobile_app/Pages/noifications_service_new.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import 'Pages/AuthPage.dart';
import 'Pages/HomePage.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().initialize(
      callbackDispatcher // The top level function, aka callbackDispatcher
      );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.init();
  runApp(const MyApp());
  // await requestNotificationPermissions();
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
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final value = settings.arguments as int;
          return MaterialPageRoute(builder: (_) => const HomePage());
        }
        return null;
      },
    );
  }
}
