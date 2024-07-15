import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'noifications_service_new.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int yesInsideCount = 0;
  int yesOutsideCount = 0;
  int noCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _saveUserDetails();
    _initializeWorkManager();
    // NotificationService.showNotification(
    //     'Attendance Notice', 'Are you at work?');
    fetchRecords();
  }

  Future<void> fetchRecords() async {
    try {
      DateTime now = DateTime.now();
      int currentMonth = now.month;
      int currentYear = now.year;
      String currentDay =
          DateFormat('EEEE').format(now); // Get the day of the week
      String currentDayNumber =
          DateFormat('d').format(now); // Get the day number of the month

      // Fetching records for the current month and year
      QuerySnapshot yesRecordsSnapshot = await FirebaseFirestore.instance
          .collection('Records')
          .doc('Starting_time')
          .collection(
              '$currentDayNumber-$currentMonth-$currentYear {yes_Inside-$currentDay}')
          .get();

      QuerySnapshot yesOutsideRecordsSnapshot = await FirebaseFirestore.instance
          .collection('Records')
          .doc('Starting_time')
          .collection(
              '$currentDayNumber-$currentMonth-$currentYear {yes_Outside-$currentDay}')
          .get();

      QuerySnapshot noRecordsSnapshot = await FirebaseFirestore.instance
          .collection('Records')
          .doc('Starting_time')
          .collection(
              '$currentDayNumber-$currentMonth-$currentYear {no-$currentDay}')
          .get();

      int tempYesInsideCount = 0;
      int tempYesOutsideCount = 0;
      int tempNoCount = 0;

// Processing Yes records
      for (var doc in yesRecordsSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        switch (data['action']) {
          case 'Yes I am at work':
            tempYesInsideCount++;
            break;
          case 'No I am not at work (Outside)':
            tempYesOutsideCount++;
            break;
          case 'No I am not at work':
            tempNoCount++;
            break;
          default:
          // Handle unexpected cases if necessary
            break;
        }
      }

// Processing No records
      tempNoCount += noRecordsSnapshot.size;

      setState(() {
        yesInsideCount = tempYesInsideCount;
        yesOutsideCount = tempYesOutsideCount;
        noCount = tempNoCount;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching records: $e');
      setState(() {
        isLoading = false;
      });
    }

  }

  Widget _buildIcon(String title) {
    IconData iconData;
    Color color;

    switch (title) {
      case 'Yes (Inside)':
        iconData = Icons.check_circle;
        color = Colors.white;
        break;
      case 'Yes (Outside)':
        iconData = Icons.location_off;
        color = Colors.white;
        break;
      case 'No':
        iconData = Icons.cancel;
        color = Colors.white;
        break;
      default:
        iconData = Icons.help;
        color = Colors.grey;
    }

    return Icon(iconData, color: color, size: 24);
  }

  Future<void> _initializeWorkManager() async {
    Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
    Workmanager().registerPeriodicTask(
      'dailyNotification',
      'dailyNotificationTask',
      frequency: const Duration(hours: 24),
      initialDelay: const Duration(minutes: 1),
      inputData: {},
    );
  }

  String? _userName;
  String? _userEmail;
  String? _userPassword;

  Future<void> _saveUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName');
      _userEmail = prefs.getString('userEmail');
      _userPassword = prefs.getString('userPassword');
    });
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
        title: const Text('Home Page'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      height: 300, // Adjust the height of the container
                      width: 300,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              color: Colors.green,
                              value: yesInsideCount.toDouble(),
                              badgeWidget: _buildIcon('Yes (Inside)'),
                              badgePositionPercentageOffset: 0.7,
                              radius: 60,
                            ),
                            PieChartSectionData(
                              color: Colors.orange,
                              value: yesOutsideCount.toDouble(),
                              badgeWidget: _buildIcon('Yes (Outside)'),
                              badgePositionPercentageOffset: 0.5,
                              radius: 50,
                            ),
                            PieChartSectionData(
                              color: Colors.red,
                              value: noCount.toDouble(),
                              badgeWidget: _buildIcon('No'),
                              badgePositionPercentageOffset: 0.5,
                              radius: 50,
                            ),
                          ],
                          centerSpaceRadius: 50,
                          sectionsSpace: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLegendItem(Colors.green, 'Yes (Inside)'),
                  _buildLegendItem(Colors.orange, 'Yes (Outside)'),
                  _buildLegendItem(Colors.red, 'No'),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.purple,
        onPressed: () {
          Navigator.pushNamed(context, '/views');
        },
        child: const Column(
          children: [
            SizedBox(
              height: 3,
            ),
            Icon(Icons.remove_red_eye),
            SizedBox(
              height: 3,
            ),
            Text('Views')
          ],
        ),
      ),
    );
  }
}

class ThemeProvider with ChangeNotifier {
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }
}
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) {
//     // Your background task code here
//     return Future.value(true);
//   });
// }
