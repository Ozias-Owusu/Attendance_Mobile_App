import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _userName;
  String? _userEmail;

  String? _userPassword;

  // @override
  // void initState() {
  //   super.initState();
  //
  // }

  Future<void> _saveUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName');
      _userEmail = prefs.getString('userEmail');
      _userPassword = prefs.getString('userPassword');
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                child: const Text('Log Out')),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/pnotification');
                },
                child: const Text('Push notification page '))
          ],
        ),
      ),
    );
  }
}
