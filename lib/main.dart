import 'package:attendance_mobile_app/Pages/noifications_service_new.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

import 'Pages/AuthPage.dart';
import 'Pages/HomePage.dart';
import 'Pages/ProfilePage.dart';
import 'Pages/SettingsPage.dart';
import 'Pages/ViewsPage.dart';
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
  _requestLocationPermission();
  await NotificationService.init();
  runApp(const MyApp());
}

Future<void> _requestLocationPermission() async {
  // Request location permission
  PermissionStatus status = await Permission.location.request();

  // Check the permission status
  if (status.isGranted) {
    // If Permission granted,
    print('Location permission granted');
  } else if (status.isDenied) {
    // If Permission denied,
    print('Location permission denied');
  } else if (status.isPermanentlyDenied) {
    //If  Permission permanently denied,
    print('Location permission permanently denied');
    await openAppSettings();
  }
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
        '/settings': (_) => const SettingsPage(),
        '/profile': (_) => const ProfilePage(),
        '/views': (_) => const ViewsPage(),
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
