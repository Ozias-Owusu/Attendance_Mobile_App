// import 'dart:async';
//
// import 'package:attendance_mobile_app/Auth_implementations_services/auth_services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AuthPage extends StatefulWidget {
//   const AuthPage({super.key});
//
//   @override
//   State<AuthPage> createState() => _AuthPageState();
// }
//
// class _AuthPageState extends State<AuthPage> {
//   late SharedPreferences prefs;
//   final _formKey = GlobalKey<FormState>();
//   final FirebaseAuthService _auth = FirebaseAuthService();
//   bool _isPasswordVisible = true;
//   bool isLoading = false;
//   final TextEditingController _userName = TextEditingController();
//   final TextEditingController _userEmail = TextEditingController();
//   final TextEditingController _userPassword = TextEditingController();
//   String? _selectedDepartment;
//   late Timer _locationTimer; // Timer for periodic location updates
//   late StreamSubscription
//       _recordSubscription; // Stream subscription for Firestore updates
//
//   @override
//   void dispose() {
//     super.dispose();
//     _userName.dispose();
//     _userEmail.dispose();
//     _userPassword.dispose();
//     _locationTimer.cancel(); // Cancel the timer
//     _recordSubscription.cancel(); // Cancel the Firestore subscription
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     initPrefs().then((_) {
//       _checkForSavedCredentials();
//     });
//     super.initState();
//     // Initialize the periodic location update timer
//     _locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
//       _getCurrentLocation();
//     });
//
//     // Initialize the Firestore stream subscription
//     _recordSubscription = FirebaseFirestore.instance
//         .collection('records')
//         .snapshots()
//         .listen((snapshot) {
//       if (mounted) {
//         setState(() {
//           // Handle Firestore updates
//         });
//       }
//     });
//   }
//
//   initPrefs() async {
//     prefs = await SharedPreferences.getInstance();
//   }
//
//   void _checkForSavedCredentials() {
//     String? savedEmail = prefs.getString('userEmail');
//     String? savedPassword = prefs.getString('password');
//     if (savedEmail != null && savedPassword != null) {
//       _showSignInDialog(savedEmail, savedPassword);
//     }
//   }
//
//   void _showSignInDialog(String savedEmail, String savedPassword) {
//     final TextEditingController emailController =
//         TextEditingController(text: savedEmail);
//     final TextEditingController passwordController =
//         TextEditingController(text: savedPassword);
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Sign In'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextFormField(
//                 controller: emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                 ),
//               ),
//               TextFormField(
//                 controller: passwordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   labelText: 'Password',
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 String email = emailController.text.trim();
//                 String password = passwordController.text.trim();
//
//                 // Check if the entered credentials match the saved ones
//                 if (email == savedEmail && password == savedPassword) {
//                   Navigator.pop(context); // Close the dialog
//                   Navigator.pushNamed(context, '/home'); // Navigate to home
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Invalid credentials'),
//                       backgroundColor: Colors.red,
//                       duration: Duration(seconds: 3),
//                     ),
//                   );
//                 }
//               },
//               child: const Text('Sign In'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> _getCurrentLocation() async {
//     try {
//       // Your logic to get the current location
//       // ...
//
//       if (mounted) {
//         setState(() {
//           // Update state based on the location
//         });
//       }
//     } catch (e) {
//       // Handle errors
//       print('Error getting location: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text('Welcome'),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     const Text('-------Sign In-------'),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     SizedBox(
//                       width: 300,
//                       child: TextFormField(
//                         validator: (name) => name == null || name.isEmpty
//                             ? 'Field Required'
//                             : (name.length < 4 ? 'Enter full name' : null),
//                         controller: _userName,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           label: const Text('Enter your name'),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     SizedBox(
//                       width: 300,
//                       child: TextFormField(
//                         controller: _userEmail,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           label: const Text('Enter your email'),
//                         ),
//                         validator: (email) {
//                           if (email == null || email.isEmpty) {
//                             return 'Field required';
//                           }
//                           String pattern =
//                               r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'; // Basic email pattern
//                           RegExp regex = RegExp(pattern);
//                           if (!regex.hasMatch((email))) {
//                             return ' Enter valid email';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     SizedBox(
//                       width: 300,
//                       child: DropdownButtonFormField<String>(
//                         value: _selectedDepartment,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           label: const Text('Select your department'),
//                         ),
//                         items: const [
//                           DropdownMenuItem(
//                             value: 'Software Development',
//                             child: Text('Software Development'),
//                           ),
//                           DropdownMenuItem(
//                             value: 'Systems Integration',
//                             child: Text('Systems Integration'),
//                           ),
//                           DropdownMenuItem(
//                             value: 'IT Consulting',
//                             child: Text('IT Consulting'),
//                           ),
//                         ],
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedDepartment = value;
//                           });
//                         },
//                         validator: (value) =>
//                             value == null ? 'Field required' : null,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: isLoading
//                           ? const CircularProgressIndicator()
//                           : ElevatedButton(
//                               onPressed: _checkDetails,
//                               child: const Text('Check Details'),
//                             ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _checkDetails() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       setState(() {
//         isLoading = true; // Set loading state to true
//       });
//
//       try {
//         String userName =
//             _userName.text.trim(); // Trim to remove any extra spaces
//         String userEmail = _userEmail.text.trim();
//         String department = _selectedDepartment!;
//
//         // Query Firestore
//         QuerySnapshot userSnapshot = await FirebaseFirestore.instance
//             .collection('CreatedUsersDetails')
//             .where('Email', isEqualTo: userEmail)
//             .where('Name', isEqualTo: userName)
//             .where('Department', isEqualTo: department)
//             .get();
//
//         // Debugging: Print the number of documents found
//         print('Number of documents found: ${userSnapshot.docs.length}');
//
//         // Check if any documents match the query
//         if (userSnapshot.docs.isNotEmpty) {
//           // Details are correct, save to SharedPreferences
//           prefs.setString('userName', userName);
//           prefs.setString('userEmail', userEmail);
//           prefs.setString('department', department);
//
//           // Show password dialog
//           _showPasswordDialog();
//         } else {
//           // Details are incorrect
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Details are incorrect. Try Again!!'),
//               backgroundColor: Colors.red,
//               duration: Duration(seconds: 3),
//             ),
//           );
//           // Clear fields and reset form
//           _userName.clear();
//           _userEmail.clear();
//           _selectedDepartment = null;
//           _formKey.currentState?.reset();
//         }
//       } catch (e) {
//         print('Error: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('An error occurred. Try Again!!'),
//             backgroundColor: Colors.red,
//             duration: Duration(seconds: 3),
//           ),
//         );
//       } finally {
//         setState(() {
//           isLoading = false; // Set loading state to false
//         });
//       }
//     }
//   }
//
//   void _showPasswordDialog() {
//     // State variables to manage visibility
//     bool _isPasswordVisible = false;
//     bool _isConfirmPasswordVisible = false;
//
//     // Controllers for password fields
//     final TextEditingController passwordController = TextEditingController();
//     final TextEditingController confirmPasswordController =
//         TextEditingController();
//     final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: const Text('Set Password'),
//               content: Form(
//                 key: _passwordFormKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextFormField(
//                       controller: passwordController,
//                       obscureText: !_isPasswordVisible,
//                       decoration: InputDecoration(
//                         labelText: 'Password',
//                         hintText: 'At least 6 characters with a number',
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _isPasswordVisible
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _isPasswordVisible = !_isPasswordVisible;
//                             });
//                           },
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value!.length < 6) {
//                           return 'Password must be at least 6 characters long';
//                         }
//                         if (!value.contains(RegExp(r'\d'))) {
//                           return 'Password must contain at least one number';
//                         }
//                         return null;
//                       },
//                     ),
//                     TextFormField(
//                       controller: confirmPasswordController,
//                       obscureText: !_isConfirmPasswordVisible,
//                       decoration: InputDecoration(
//                         labelText: 'Confirm Password',
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _isConfirmPasswordVisible
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _isConfirmPasswordVisible =
//                                   !_isConfirmPasswordVisible;
//                             });
//                           },
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value != passwordController.text) {
//                           return 'Passwords do not match';
//                         }
//                         return null;
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text('Cancel'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     if (_passwordFormKey.currentState?.validate() ?? false) {
//                       String userPassword = passwordController.text;
//
//                       // Save the password and other details to SharedPreferences
//                       SharedPreferences prefs =
//                           await SharedPreferences.getInstance();
//                       prefs.setString(
//                           'password', userPassword); // Save password
//                       prefs.setString('userEmail', _userEmail.text);
//                       prefs.setString('UserName', _userName.text);
//                       prefs.setString('department', _selectedDepartment!);
//
//                       // Close the dialog and navigate to the home page
//                       Navigator.pop(context); // Close the dialog
//                       Navigator.pushNamed(context, '/home'); // Navigate to home
//                     }
//                   },
//                   child: const Text('Authenticate'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late SharedPreferences prefs;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Use FirebaseAuth directly
  bool _isPasswordVisible = true;
  bool isLoading = false;
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _userEmail = TextEditingController();
  final TextEditingController _userPassword = TextEditingController();
  String? _selectedDepartment;

  @override
  void dispose() {
    super.dispose();
    _userName.dispose();
    _userEmail.dispose();
    _userPassword.dispose();
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    _checkForSavedCredentials(); // Check for saved credentials when initializing
  }

  void _checkForSavedCredentials() {
    String? savedEmail = prefs.getString('userEmail');
    String? savedPassword = prefs.getString('password');
    if (savedEmail != null && savedPassword != null) {
      _showSignInDialog(savedEmail, savedPassword);
    }
  }

  void _showSignInDialog(String savedEmail, String savedPassword) {
    final TextEditingController emailController =
        TextEditingController(text: savedEmail);
    final TextEditingController passwordController =
        TextEditingController(text: savedPassword);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign In'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String email = emailController.text.trim();
                String password = passwordController.text.trim();

                // Check if the entered credentials match the saved ones
                if (email == savedEmail && password == savedPassword) {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pushNamed(context, '/home'); // Navigate to home
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid credentials'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: const Text('Sign In'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    // Implement your location fetching logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Welcome'),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('-------Sign In-------'),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        validator: (name) => name == null || name.isEmpty
                            ? 'Field Required'
                            : (name.length < 4 ? 'Enter full name' : null),
                        controller: _userName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          label: const Text('Enter your name'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: _userEmail,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          label: const Text('Enter your email'),
                        ),
                        validator: (email) {
                          if (email == null || email.isEmpty) {
                            return 'Field required';
                          }
                          String pattern =
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'; // Basic email pattern
                          RegExp regex = RegExp(pattern);
                          if (!regex.hasMatch((email))) {
                            return ' Enter valid email';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 300,
                      child: DropdownButtonFormField<String>(
                        value: _selectedDepartment,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          label: const Text('Select your department'),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Software Development',
                            child: Text('Software Development'),
                          ),
                          DropdownMenuItem(
                            value: 'Systems Integration',
                            child: Text('Systems Integration'),
                          ),
                          DropdownMenuItem(
                            value: 'IT Consulting',
                            child: Text('IT Consulting'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedDepartment = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Field required' : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _checkDetails,
                              child: const Text('Check Details'),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _checkDetails() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true; // Set loading state to true
      });

      try {
        String userName =
            _userName.text.trim(); // Trim to remove any extra spaces
        String userEmail = _userEmail.text.trim();
        String department = _selectedDepartment!;

        // Query Firestore
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('CreatedUsersDetails')
            .where('Email', isEqualTo: userEmail)
            .where('Name', isEqualTo: userName)
            .where('Department', isEqualTo: department)
            .get();

        // Debugging: Print the number of documents found
        print('Number of documents found: ${userSnapshot.docs.length}');

        // Check if any documents match the query
        if (userSnapshot.docs.isNotEmpty) {
          // Details are correct, save to SharedPreferences
          prefs.setString('userName', userName);
          prefs.setString('userEmail', userEmail);
          prefs.setString('department', department);

          // Show password dialog
          _showPasswordDialog();
        } else {
          // Details are incorrect
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Details are incorrect. Try Again!!'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          // Clear fields and reset form
          _userName.clear();
          _userEmail.clear();
          _selectedDepartment = null;
          _formKey.currentState?.reset();
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Try Again!!'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      } finally {
        setState(() {
          isLoading = false; // Set loading state to false
        });
      }
    }
  }

  void _showPasswordDialog() {
    // State variables to manage visibility
    bool _isPasswordVisible = false;
    bool _isConfirmPasswordVisible = false;

    // Controllers for password fields
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    final _passwordFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Password'),
          content: Form(
            key: _passwordFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Password is required'
                      : (value.length < 6
                          ? 'Password must be at least 6 characters'
                          : null),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    suffixIcon: IconButton(
                      icon: Icon(_isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Confirm Password is required'
                      : (value != passwordController.text
                          ? 'Passwords do not match'
                          : null),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_passwordFormKey.currentState?.validate() ?? false) {
                  String password = passwordController.text.trim();

                  // Save password to SharedPreferences
                  await prefs.setString('password', password);

                  // Create Firebase Auth user
                  try {
                    await _auth.createUserWithEmailAndPassword(
                      email: _userEmail.text.trim(),
                      password: password,
                    );

                    Navigator.pushNamed(context, '/home'); // Navigate to home
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error creating account: $e'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                }
              },
              child: const Text('Create Password'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
