import 'dart:convert';
import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int yesInsideCount = 0;
  int yesOutsideCount = 0;
  int noCount = 0;
  bool isLoading = true;
  int _additionalTextIndex = 0; // Index to track which text to display

  Position? _currentPosition;
  String? _currentAddress;

  String? _imagePath;

  List<String> additionalTexts = [
    'Customer Sensitivity',
    'Leadership',
    'Accountability',
    'Speed',
    'Shared Vision and Mindset',
    'Innovation',
    'Effectiveness',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _loadAdditionalTextIndex(); // Load stored index on initialization
    _saveUserDetails();
    _getCurrentLocation();
    _loadRecordsFromSharedPreferences().then((records) {
      _updateCounts(records);
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });

    // Use Geocoding to get the address
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    setState(() {
      _currentAddress =
          "${place.locality}, ${place.postalCode}, ${place.country}";
    });
  }

  // Future<void> _initializeWorkManager() async {
  //   // Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  //   Workmanager().registerPeriodicTask(
  //     'dailyNotification',
  //     'dailyNotificationTask',
  //     frequency: const Duration(hours: 24),
  //     initialDelay: const Duration(minutes: 1),
  //     inputData: {},
  //   );
  // }

  // Future<void> _initializeWorkManager_2() async {
  //   // await NotificationService.showNotificationAt5(
  //   //     'Attendance Notice!', 'Have you closed? ');
  //   await NotificationService_2().scheduleDailyNotifications();
  //   // Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  //   Workmanager().registerPeriodicTask(
  //     'dailyNotification_2',
  //     'dailyNotificationTask_2',
  //     frequency: const Duration(hours: 24),
  //     initialDelay: const Duration(minutes: 1),
  //     inputData: {},
  //   );
  // }

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

  Future<List<Map<String, dynamic>>> _loadRecordsFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('userRecords');
    if (jsonString == null) {
      return [];
    } else {
      List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((item) => Map<String, dynamic>.from(item)).toList();
    }
  }

  void _updateCounts(List<Map<String, dynamic>> records) {
    int tempYesInsideCount = 0;
    int tempYesOutsideCount = 0;
    int tempNoCount = 0;

    for (var record in records) {
      switch (record['action']) {
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

    setState(() {
      yesInsideCount = tempYesInsideCount;
      yesOutsideCount = tempYesOutsideCount;
      noCount = tempNoCount;
    });
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

  Future<void> _loadAdditionalTextIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _additionalTextIndex = prefs.getInt('additionalTextIndex') ?? 0;
    });
  }

  Future<void> _saveAdditionalTextIndex(int newIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('additionalTextIndex', newIndex);
    setState(() {
      _additionalTextIndex = newIndex;
    });
  }

  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _imagePath = prefs.getString('profile_image');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          _imagePath == null
              ? IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    // Handle icon press if needed
                  },
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageScreen(_imagePath!),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage: FileImage(File(_imagePath!)),
                    radius: 20,
                  ),
                ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings').then((_) {
                // Navigate back from views page, increment additional text index
                _saveAdditionalTextIndex(
                    (_additionalTextIndex + 1) % additionalTexts.length);
              });
              ;
            },
          ),
        ],
        title: const Text('Home Page'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (_currentPosition != null && _currentAddress != null)
                      Column(
                        children: [
                          Text(
                            'Coordinates: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Location: $_currentAddress',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    Center(
                      child: Container(
                        height: 300,
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
                    Column(
                      children: [
                        _buildLegendItem(Colors.green, 'Yes (Inside)'),
                        _buildLegendItem(Colors.orange, 'Yes (Outside)'),
                        _buildLegendItem(Colors.red, 'No'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'CLASSIE',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _additionalTextIndex < additionalTexts.length
                          ? additionalTexts[_additionalTextIndex]
                          : '',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.purple,
        onPressed: () {
          Navigator.pushNamed(context, '/views').then((_) {
            // Navigate back from views page, increment additional text index
            _saveAdditionalTextIndex(
                (_additionalTextIndex + 1) % additionalTexts.length);
          });
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

class ImageScreen extends StatelessWidget {
  final String imagePath;

  ImageScreen(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) {
//     // Your background task code here
//     return Future.value(true);
//   });
// }
