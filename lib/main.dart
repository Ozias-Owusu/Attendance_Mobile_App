import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'Pages/AuthPage.dart';
import 'Pages/HomePage.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print('Notification Received Successfully');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //         apiKey: 'AIzaSyCXaqMiWXuVi8H1JP3OZZ1qZM4TiY4gkzo',
  //         appId: '1:513839870238:android:6a4b2eee7ef54f4c05190f',
  //         messagingSenderId: '513839870238',
  //         projectId: 'attendance-web-app-a6aa7'));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      print('background notification tapped');
      navigatorKey.currentState!.pushNamed('/home', arguments: message);
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      print('Notification Tapped');
    }
  });

  PushNotifications.init();

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  tz.initializeTimeZones();
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
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          final value = settings.arguments as int;
          return MaterialPageRoute(builder: (_) => const AuthPage());
        }
        return null;
      },
    );
  }
}
