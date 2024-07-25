// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
//
// class AttendanceNoticePage extends StatefulWidget {
//   const AttendanceNoticePage({super.key});
//
//   @override
//   _AttendanceNoticePageState createState() => _AttendanceNoticePageState();
// }
//
// class _AttendanceNoticePageState extends State<AttendanceNoticePage> {
//   String userName = 'Unknown User';
//   String userEmail = 'Unknown Email';
//   bool isWithinAllowedTime = false;
//   bool hasCheckedIn = false;
//   bool isAfterNoon = false;
//   bool isAfterWorkTime = false;
//   bool hasLeftWork = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserPreferences();
//     _checkAllowedTime();
//     _checkAfterNoon();
//     _checkAfterWorkTime();
//   }
//
//   Future<void> _loadUserPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userName = prefs.getString('UserName') ?? 'Unknown User';
//       userEmail = prefs.getString('userEmail') ?? 'Unknown Email';
//       hasCheckedIn = prefs.getBool('hasCheckedIn') ?? false;
//       hasLeftWork = prefs.getBool('hasLeftWork') ?? false;
//     });
//   }
//
//   void _checkAllowedTime() {
//     DateTime now = DateTime.now();
//     DateTime startTime = DateTime(now.year, now.month, now.day, 8);
//     DateTime endTime = startTime.add(const Duration(hours: 4));
//     setState(() {
//       isWithinAllowedTime = now.isAfter(startTime) && now.isBefore(endTime);
//     });
//   }
//
//   void _checkAfterNoon() {
//     DateTime now = DateTime.now();
//     DateTime noon = DateTime(now.year, now.month, now.day, 12);
//     setState(() {
//       isAfterNoon = now.isAfter(noon);
//     });
//   }
//
//   void _checkAfterWorkTime() {
//     DateTime now = DateTime.now();
//     DateTime workTime = DateTime(now.year, now.month, now.day, 17);
//     DateTime endTime = workTime.add(const Duration(hours: 2));
//     setState(() {
//       isAfterWorkTime = now.isAfter(workTime) && now.isBefore(endTime);
//     });
//   }
//
//   Future<void> handleAction(String action, String type) async {
//     DateTime now = DateTime.now();
//     int currentMonth = now.month;
//     int currentYear = now.year;
//     String currentDay = DateFormat('EEEE').format(now); // Get the day of the week
//     String currentDayNumber = DateFormat('d').format(now); // Get the day number of the month
//
//     switch (action) {
//       case 'Yes':
//         if (type == 'start') {
//           await _handleYesButtonAction(currentDay, currentDayNumber, currentMonth, currentYear);
//         } else {
//           await _handleYesLeaveButtonAction(currentDay, currentDayNumber, currentMonth, currentYear);
//         }
//         break;
//       case 'No':
//         if (type == 'start') {
//           await _handleNoButtonAction(currentDay, currentDayNumber, currentMonth, currentYear);
//         } else {
//           await _handleNoLeaveButtonAction(currentDay, currentDayNumber, currentMonth, currentYear);
//         }
//         break;
//       default:
//         print('Unknown action');
//     }
//
//     if (type == 'start') {
//       setState(() {
//         hasCheckedIn = true;
//       });
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('hasCheckedIn', true);
//     } else {
//       setState(() {
//         hasLeftWork = true;
//       });
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('hasLeftWork', true);
//     }
//   }
//
//   Future<void> _handleYesButtonAction(String currentDay, String currentDayNumber, int currentMonth, int currentYear) async {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     double targetLatitude = 5.6129311;
//     double targetLongitude = -0.1823302;
//     double radius = 100; // in meters
//
//     double distance = Geolocator.distanceBetween(
//       position.latitude,
//       position.longitude,
//       targetLatitude,
//       targetLongitude,
//     );
//
//     String collectionName = distance <= radius ? 'yes_Inside' : 'yes_Outside';
//     String actionText = distance <= radius ? 'Yes I am at work' : 'No I am not at work (Outside)';
//
//     await FirebaseFirestore.instance
//         .collection('Records')
//         .doc('Starting_time')
//         .collection('$currentDayNumber-$currentMonth-$currentYear {$collectionName}')
//         .add({
//       'timestamp': Timestamp.fromDate(DateTime.now().toUtc()),
//       'action': actionText,
//       'dayOfWeek': currentDay,
//       'userEmail': userEmail,
//       'userName': userName,
//     });
//     print('Yes button clicked');
//   }
//
//   Future<void> _handleNoButtonAction(String currentDay, String currentDayNumber, int currentMonth, int currentYear) async {
//     await FirebaseFirestore.instance
//         .collection('Records')
//         .doc('Starting_time')
//         .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
//         .add({
//       'timestamp': Timestamp.fromDate(DateTime.now().toUtc()),
//       'action': 'No I am not at work',
//       'dayOfWeek': currentDay,
//       'userEmail': userEmail,
//       'userName': userName,
//     });
//     print('No button clicked');
//   }
//
//   Future<void> _handleYesLeaveButtonAction(String currentDay, String currentDayNumber, int currentMonth, int currentYear) async {
//     await FirebaseFirestore.instance
//         .collection('$currentDayNumber-$currentMonth-$currentYear{ClosingRecords}')
//         .doc('Closing_time')
//         .collection('$currentDayNumber-$currentMonth-$currentYear{yes_Closed}')
//         .add({
//       'timestamp': Timestamp.fromDate(DateTime.now().toUtc()),
//       'action': 'Yes I have left work',
//       'dayOfWeek': currentDay,
//       'userEmail': userEmail,
//       'userName': userName,
//     });
//     print('Yes leave button clicked');
//   }
//
//   Future<void> _handleNoLeaveButtonAction(String currentDay, String currentDayNumber, int currentMonth, int currentYear) async {
//     await FirebaseFirestore.instance
//         .collection('ClosingRecords')
//         .doc('Closing_time')
//         .collection('$currentDayNumber-$currentMonth-$currentYear{no_Closed}')
//         .add({
//       'timestamp': Timestamp.fromDate(DateTime.now().toUtc()),
//       'action': 'No I have not left work',
//       'dayOfWeek': currentDay,
//       'userEmail': userEmail,
//       'userName': userName,
//     });
//     print('No leave button clicked');
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Attendance Notice'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (!hasCheckedIn && isWithinAllowedTime) ...[
//                 const Text(
//                   'Are you at work?',
//                   style: TextStyle(fontSize: 24),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: isWithinAllowedTime && !hasCheckedIn ? () => handleAction('Yes', 'start') : null,
//                   child: const Text('Yes'),
//                 ),
//                 ElevatedButton(
//                   onPressed: isWithinAllowedTime && !hasCheckedIn ? () => handleAction('No', 'start') : null,
//                   child: const Text('No'),
//                 ),
//               ],
//               if (isAfterNoon && !hasLeftWork) ...[
//                 const Text(
//                   'Attendance Notice!',
//                   style: TextStyle(fontSize: 24),
//                 ),
//                 const SizedBox(height: 20),
//                 if (isAfterWorkTime) ...[
//                   const Text(
//                     'Have you left work?',
//                     style: TextStyle(fontSize: 24),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: !hasLeftWork ? () => handleAction('Yes', 'end') : null,
//                     child: const Text('Yes'),
//                   ),
//                   ElevatedButton(
//                     onPressed: !hasLeftWork ? () => handleAction('No', 'end') : null,
//                     child: const Text('No'),
//                   ),
//                 ],
//               ],
//             ],
//           ),
//         ),
//       ),
//
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceNoticePage extends StatefulWidget {
  const AttendanceNoticePage({super.key});

  @override
  _AttendanceNoticePageState createState() => _AttendanceNoticePageState();
}

class _AttendanceNoticePageState extends State<AttendanceNoticePage> {
  String userName = 'Unknown User';
  String userEmail = 'Unknown Email';
  bool isWithinAllowedTime = false;
  bool hasCheckedIn = false;
  bool isAfterNoon = false;
  bool isAfterWorkTime = false;
  bool hasLeftWork = false;
  String actionTaken = '';

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
    _checkAllowedTime();
    _checkAfterNoon();
    _checkAfterWorkTime();
  }

  Future<void> _loadUserPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('UserName') ?? 'Unknown User';
      userEmail = prefs.getString('userEmail') ?? 'Unknown Email';
      hasCheckedIn = prefs.getBool('hasCheckedIn') ?? false;
      hasLeftWork = prefs.getBool('hasLeftWork') ?? false;
    });
  }

  void _checkAllowedTime() {
    DateTime now = DateTime.now();
    DateTime startTime = DateTime(now.year, now.month, now.day, 8);
    DateTime endTime = startTime.add(const Duration(hours: 4));
    setState(() {
      isWithinAllowedTime = now.isAfter(startTime) && now.isBefore(endTime);
    });
  }

  void _checkAfterNoon() {
    DateTime now = DateTime.now();
    DateTime noon = DateTime(now.year, now.month, now.day, 12);
    setState(() {
      isAfterNoon = now.isAfter(noon);
    });
  }

  void _checkAfterWorkTime() {
    DateTime now = DateTime.now();
    DateTime workTime = DateTime(now.year, now.month, now.day, 17);
    DateTime endTime = workTime.add(const Duration(hours: 2));
    setState(() {
      isAfterWorkTime = now.isAfter(workTime) && now.isBefore(endTime);
    });
  }

  Future<void> handleAction(String action, String type) async {
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;
    String currentDay =
        DateFormat('EEEE').format(now); // Get the day of the week
    String currentDayNumber =
        DateFormat('d').format(now); // Get the day number of the month

    switch (action) {
      case 'Yes':
        if (type == 'start') {
          await _handleYesButtonAction(
              currentDay, currentDayNumber, currentMonth, currentYear);
          setState(() {
            actionTaken = 'Checked In';
          });
        } else {
          await _handleYesLeaveButtonAction(
              currentDay, currentDayNumber, currentMonth, currentYear);
          setState(() {
            actionTaken = 'Checked Out';
          });
        }
        break;
      case 'No':
        if (type == 'start') {
          await _handleNoButtonAction(
              currentDay, currentDayNumber, currentMonth, currentYear);
          setState(() {
            actionTaken = 'Not Checked In';
          });
        } else {
          await _handleNoLeaveButtonAction(
              currentDay, currentDayNumber, currentMonth, currentYear);
          setState(() {
            actionTaken = 'Not Checked Out';
          });
        }
        break;
      default:
        print('Unknown action');
    }

    if (type == 'start') {
      setState(() {
        hasCheckedIn = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasCheckedIn', true);
    } else {
      setState(() {
        hasLeftWork = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasLeftWork', true);
    }
  }

  Future<void> _handleYesButtonAction(String currentDay,
      String currentDayNumber, int currentMonth, int currentYear) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double targetLatitude = 5.6129311;
    double targetLongitude = -0.1823302;
    double radius = 100; // in meters

    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      targetLatitude,
      targetLongitude,
    );

    String collectionName = distance <= radius ? 'yes_Inside' : 'yes_Outside';
    String actionText =
        distance <= radius ? 'Checked In' : 'Not Checked In(Outside)';

    await FirebaseFirestore.instance
        .collection('Records')
        .doc('Starting_time')
        .collection(
            '$currentDayNumber-$currentMonth-$currentYear {$collectionName}')
        .add({
      'timestamp': Timestamp.fromDate(DateTime.now().toUtc()),
      'action': actionText,
      'dayOfWeek': currentDay,
      'userEmail': userEmail,
      'userName': userName,
    });
    print('Yes button clicked');
  }

  Future<void> _handleNoButtonAction(String currentDay, String currentDayNumber,
      int currentMonth, int currentYear) async {
    await FirebaseFirestore.instance
        .collection('Records')
        .doc('Starting_time')
        .collection('$currentDayNumber-$currentMonth-$currentYear {no}')
        .add({
      'timestamp': Timestamp.fromDate(DateTime.now().toUtc()),
      'action': 'Not Checked In',
      'dayOfWeek': currentDay,
      'userEmail': userEmail,
      'userName': userName,
    });
    print('No button clicked');
  }

  Future<void> _handleYesLeaveButtonAction(String currentDay,
      String currentDayNumber, int currentMonth, int currentYear) async {
    await FirebaseFirestore.instance
        .collection('ClosingRecords')
        .doc('Closing_time')
        .collection('$currentDayNumber-$currentMonth-$currentYear{yes_Closed}')
        .add({
      'timestamp': Timestamp.fromDate(DateTime.now().toUtc()),
      'action': 'Checked Out',
      'dayOfWeek': currentDay,
      'userEmail': userEmail,
      'userName': userName,
    });
    print('Yes leave button clicked');
  }

  Future<void> _handleNoLeaveButtonAction(String currentDay,
      String currentDayNumber, int currentMonth, int currentYear) async {
    await FirebaseFirestore.instance
        .collection('ClosingRecords')
        .doc('Closing_time')
        .collection('$currentDayNumber-$currentMonth-$currentYear{no_Closed}')
        .add({
      'timestamp': Timestamp.fromDate(DateTime.now().toUtc()),
      'action': 'Not Checked Out',
      'dayOfWeek': currentDay,
      'userEmail': userEmail,
      'userName': userName,
    });
    print('No leave button clicked');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Notice'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!hasCheckedIn && isWithinAllowedTime) ...[
                const Text(
                  'Are you at work?',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isWithinAllowedTime && !hasCheckedIn
                      ? () => handleAction('Yes', 'start')
                      : null,
                  child: const Text('Yes'),
                ),
                ElevatedButton(
                  onPressed: isWithinAllowedTime && !hasCheckedIn
                      ? () => handleAction('No', 'start')
                      : null,
                  child: const Text('No'),
                ),
              ],
              if (isAfterNoon && !hasLeftWork) ...[
                const Text(
                  'Attendance Notice!',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                if (isAfterWorkTime) ...[
                  const Text(
                    'Have you left work?',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed:
                        !hasLeftWork ? () => handleAction('Yes', 'end') : null,
                    child: const Text('Yes'),
                  ),
                  ElevatedButton(
                    onPressed:
                        !hasLeftWork ? () => handleAction('No', 'end') : null,
                    child: const Text('No'),
                  ),
                ],
              ],
              if (actionTaken.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  'Action Taken: $actionTaken',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
