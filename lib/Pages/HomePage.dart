import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'noifications_service_new.dart';

class HomePage extends StatefulWidget {
  static final GlobalKey<_HomePageState> homePageKey =
      GlobalKey<_HomePageState>();

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int yesInsideCount = 0;
  int yesOutsideCount = 0;
  int noCount = 0;
  bool isLoading = true;
  int _additionalTextIndex = 0;
  Duration _averageTimeWithinRadius = Duration.zero;

  Position? _currentPosition;
  String? _currentAddress;

  List<String> additionalTexts = [
    'Customer Sensitivity',
    'Leadership',
    'Accountability',
    'Speed',
    'Shared Vision and Mindset',
    'Innovation',
    'Effectiveness',
  ];
  List<Map<String, dynamic>> records = [];
  @override
  void initState() {
    super.initState();
    _loadAdditionalTextIndex();
    _saveUserDetails();
    _getCurrentLocation();
    _loadRecordsFromSharedPreferences().then((records) {
      _updateCounts(records);
      _calculateAverageTimeWithinRadius(records);
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

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    setState(() {
      _currentAddress =
          "${place.locality}, ${place.postalCode}, ${place.country}";
    });
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
        case 'Checked In':
          tempYesInsideCount++;
          break;
        case 'Not Checked In(Outside)':
          tempYesOutsideCount++;
          break;
        case 'Not Checked In':
          tempNoCount++;
          break;
        default:
          break;
      }
    }

    setState(() {
      yesInsideCount = tempYesInsideCount;
      yesOutsideCount = tempYesOutsideCount;
      noCount = tempNoCount;
    });
  }

  Future<void> _calculateAverageTimeWithinRadius(
      List<Map<String, dynamic>> records) async {
    int totalMinutes = 0;
    int count = 0;

    DateFormat dateFormat =
        DateFormat('dd-MM-yyyy HH:mm'); // Adjust to your format

    for (var record in records) {
      if (record['action'] == 'Checked In' && record['time'] != null) {
        try {
          DateTime recordTime = dateFormat.parse(record['time']);
          totalMinutes += recordTime.hour * 60 + recordTime.minute;
          count++;
        } catch (e) {
          print('Error parsing date: $e');
        }
      }
    }

    if (count > 0) {
      setState(() {
        _averageTimeWithinRadius = Duration(minutes: totalMinutes ~/ count);
      });
    }
  }

  Widget _buildIcon(String title) {
    IconData iconData;
    Color color;

    switch (title) {
      case 'Checked In':
        iconData = Icons.check_circle;
        color = Colors.white;
        break;
      case 'Not Checked In(Outside)':
        iconData = Icons.location_off;
        color = Colors.white;
        break;
      case 'Not Checked In':
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

  // Future<List<Map<String, dynamic>>> _fetchRecords(String section) async {
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     if (user == null) return [];
  //
  //     final email = user.email!;
  //     List<Stream<QuerySnapshot<Map<String, dynamic>>>> streams = [];
  //
  //     DateTime now = DateTime.now();
  //     DateTime startDate = DateTime(now.year, now.month, 1);
  //     DateTime endDate = DateTime(now.year, now.month + 1, 0);
  //
  //     for (int i = 0; i <= endDate.day; i++) {
  //       DateTime currentDate = startDate.add(Duration(days: i));
  //       int currentMonth = currentDate.month;
  //       int currentYear = currentDate.year;
  //       String currentDayNumber = DateFormat('d').format(currentDate);
  //
  //       String collectionPath;
  //       switch (section) {
  //         case 'Yes (Inside)':
  //           collectionPath =
  //               '$currentDayNumber-$currentMonth-$currentYear {yes_Inside}';
  //           break;
  //         case 'Yes (Outside)':
  //           collectionPath =
  //               '$currentDayNumber-$currentMonth-$currentYear {yes_Outside}';
  //           break;
  //         case 'No':
  //           collectionPath =
  //               '$currentDayNumber-$currentMonth-$currentYear {no}';
  //           break;
  //         default:
  //           collectionPath = '';
  //       }
  //
  //       if (collectionPath.isNotEmpty) {
  //         streams.add(
  //           FirebaseFirestore.instance
  //               .collection('Records')
  //               .doc('Starting_time')
  //               .collection(collectionPath)
  //               .where('userEmail', isEqualTo: email)
  //               .snapshots(),
  //         );
  //       }
  //     }
  //
  //     // Add ClosingRecords
  //     streams.add(
  //       FirebaseFirestore.instance
  //           .collection('ClosingRecords')
  //           .doc('Closing_time')
  //           .collection(section == 'Yes (Inside)'
  //               ? 'yes_Closed'
  //               : section == 'Yes (Outside)'
  //                   ? 'no_Closed'
  //                   : 'no_option_selected_Closed')
  //           .where('userEmail', isEqualTo: email)
  //           .snapshots(),
  //     );

  Future<List<Map<String, dynamic>>> _fetchRecords(String section) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return [];

      final email = user.email!;
      List<Stream<QuerySnapshot<Map<String, dynamic>>>> streams = [];

      DateTime now = DateTime.now();
      DateTime startDate = DateTime(now.year, now.month, 1);
      DateTime endDate = DateTime(now.year, now.month + 1, 0);

      for (int i = 0; i <= endDate.day; i++) {
        DateTime currentDate = startDate.add(Duration(days: i));
        int currentMonth = currentDate.month;
        int currentYear = currentDate.year;
        String currentDayNumber = DateFormat('d').format(currentDate);

        String collectionPath;
        switch (section) {
          case 'Checked In':
            collectionPath =
                '$currentDayNumber-$currentMonth-$currentYear {yes_Inside}';
            break;
          case 'Not Checked In(Outside)':
            collectionPath =
                '$currentDayNumber-$currentMonth-$currentYear {yes_Outside}';
            break;
          case 'Not Checked In':
            collectionPath =
                '$currentDayNumber-$currentMonth-$currentYear {no}';
            break;
          default:
            collectionPath = '';
        }

        if (collectionPath.isNotEmpty) {
          streams.add(
            FirebaseFirestore.instance
                .collection('Records')
                .doc('Starting_time')
                .collection(collectionPath)
                .where('userEmail', isEqualTo: email)
                .snapshots(),
          );
        }
      }

      // Add ClosingRecords
      streams.add(
        FirebaseFirestore.instance
            .collection('ClosingRecords')
            .doc('Closing_time')
            .collection(section == 'Checked In'
                ? 'yes_Closed'
                : section == 'Not Checked In(Outside)'
                    ? 'no_Closed'
                    : 'no_option_selected_Closed')
            .where('userEmail', isEqualTo: email)
            .snapshots(),
      );
      // Fetch and process records
      List<Map<String, dynamic>> records =
          (await CombineLatestStream.list(streams).first)
              .expand((snapshot) => snapshot.docs.map((doc) {
                    final data = doc.data();
                    Timestamp timestamp = data['timestamp'] as Timestamp;
                    DateTime dateTime = timestamp.toDate();
                    data['date'] = DateFormat('dd-MM-yyyy').format(dateTime);
                    data['time'] = DateFormat('HH:mm').format(dateTime);
                    data['dayOfWeek'] = DateFormat('EEEE').format(dateTime);
                    data.remove('timestamp'); // Remove timestamp field
                    return data;
                  }))
              .toList();

      // Update state
      setState(() {
        this.records = records;
      });
      return records;
    } catch (e) {
      print('Error fetching records: $e');
      return [];
    }
  }

  //     // Fetch and process records
  //     List<Map<String, dynamic>> records =
  //         (await CombineLatestStream.list(streams).first)
  //             .expand((snapshot) => snapshot.docs.map((doc) {
  //                   final data = doc.data();
  //                   Timestamp timestamp = data['timestamp'] as Timestamp;
  //                   DateTime dateTime = timestamp.toDate();
  //                   data['date'] = DateFormat('dd-MM-yyyy').format(dateTime);
  //                   data['time'] = DateFormat('HH:mm').format(dateTime);
  //                   data['dayOfWeek'] = DateFormat('EEEE').format(dateTime);
  //                   data.remove('userName');
  //                   data.remove('userEmail');
  //                   return data;
  //                 }).toList())
  //             .toList();
  //
  //     return records;
  //   } catch (e) {
  //     print('Error fetching records: $e');
  //     return [];
  //   }
  // }

  // void _onSectionTapped(String section) async {
  //   List<Map<String, dynamic>> records = await _fetchRecords(section);
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => RecordsPage(section: section, records: records),
  //     ),
  //   );
  // }
  void _onSectionTapped(String section) async {
    List<Map<String, dynamic>> records = await _fetchRecords(section);

    // Show records in an alert dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Records for $section'),
          content: SingleChildScrollView(
            child: ListBody(
              children: records
                  .map(
                    (record) => ListTile(
                      title: Text('${record['date']} ${record['time']}'),
                      subtitle: Text('${record['action']}'),
                    ),
                  )
                  .toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
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
              Navigator.pushNamed(context, '/settings').then((_) {
                _saveAdditionalTextIndex(
                    (_additionalTextIndex + 1) % additionalTexts.length);
              });
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
                      child: SizedBox(
                        height: 400,
                        width: 400,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                color: Colors.green,
                                // value: yesInsideCount.toDouble(),
                                badgeWidget: GestureDetector(
                                  onTap: () => _onSectionTapped('Checked In'),
                                  child: _buildIcon('Checked In'),
                                ),
                                badgePositionPercentageOffset: 0.7,
                                radius: 80,
                              ),
                              PieChartSectionData(
                                color: Colors.orange,
                                // value: yesOutsideCount.toDouble(),
                                badgeWidget: GestureDetector(
                                  onTap: () => _onSectionTapped(
                                      'Not Checked In(Outside)'),
                                  child: _buildIcon('Not Checked In(Outside)'),
                                ),
                                badgePositionPercentageOffset: 0.5,
                                radius: 70,
                              ),
                              PieChartSectionData(
                                color: Colors.red,
                                // value: noCount.toDouble(),
                                badgeWidget: GestureDetector(
                                  onTap: () =>
                                      _onSectionTapped('Not Checked In'),
                                  child: _buildIcon('Not Checked In'),
                                ),
                                badgePositionPercentageOffset: 0.5,
                                radius: 70,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        _buildLegendItem(
                            Colors.green, 'Checked In (Within geolocator)'),
                        _buildLegendItem(
                            Colors.orange, 'Checked In (Outside geolocator)'),
                        _buildLegendItem(Colors.red, 'Not Checked In'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_averageTimeWithinRadius != Duration.zero)
                      Text(
                        'Average Time Within Radius: '
                        '${_averageTimeWithinRadius.inHours}h ${_averageTimeWithinRadius.inMinutes % 60}m',
                        style: const TextStyle(fontSize: 16),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      additionalTexts[_additionalTextIndex],
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/atnp');
                        },
                        child: const Text(
                          'Check In',
                          style: TextStyle(fontSize: 25),
                        ))
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/views');
        },
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.remove_red_eye_rounded),
            Padding(
              padding: EdgeInsets.fromLTRB(1, 0, 2, 1),
              child: Text('Records'),
            )
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
