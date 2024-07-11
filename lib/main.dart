import 'package:attendance_mobile_app/Pages/noifications_service_new.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:workmanager/workmanager.dart';

import 'Pages/AuthPage.dart';
import 'Pages/HomePage.dart';
import 'Pages/ProfilePage.dart';
import 'Pages/SettingsPage.dart';
import 'Pages/SplashScreen.dart';
import 'Pages/ViewsPage.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Workmanager().initialize(
      callbackDispatcher // The top level function, aka callbackDispatcher
      );
  await Permission_Checker();
  await Permission_Checker_2();
  await NotificationService.init();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

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
      initialRoute: '/splash',
      routes: {
        '/': (_) => const AuthPage(),
        '/profile': (_) => const ProfilePage(),
        '/home': (_) => const HomePage(),
        '/settings': (_) => const SettingsPage(),
        '/views': (_) => const ViewsPage(),
        '/splash': (_) => const Splashscreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/settings') {
          final value = settings.arguments as int;
          return MaterialPageRoute(builder: (_) => const SettingsPage());
        }
        return null;
      },
    );
  }
}
