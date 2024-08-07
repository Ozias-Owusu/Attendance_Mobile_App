import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    });
  }

  Future<void> _checkUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('userEmail');
    String? userPassword = prefs.getString('userPassword');

    if (userEmail != null && userPassword != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: userEmail, password: userPassword);

        User? user = userCredential.user;

        if (user != null) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pushReplacementNamed(context, '/');
        }
      } catch (e) {
        print('Error: $e');
        Navigator.pushReplacementNamed(context, '/');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.white, Colors.purple],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/PAMA main.png'),
            ),
            SizedBox(
              height: 10,
            ),
            Text('ATTENDANCE MOBILE APP'),
          ],
        ),
      ),
    );
  }
}
// import 'package:attendance_mobile_app/Auth_implementations_services/auth_services.dart';
// import 'package:firebase_auth/firebase_auth.dart';
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
// /* Check the details below and fix the authentication
// -sign in
// {email, password}
// {
// authentication
// {
// create users and authenticate if email provided is equal to the email saved
// } */
//
// class _AuthPageState extends State<AuthPage> {
//   late SharedPreferences prefs;
//
//   final _formKey = GlobalKey<FormState>();
//   final FirebaseAuthService _auth = FirebaseAuthService();
//   bool _isPasswordVisible = true;
//
//   bool isLoading = false;
//
//   // final TextEditingController _userName = TextEditingController();
//   final TextEditingController _userEmail = TextEditingController();
//   final TextEditingController _userPassword = TextEditingController();
//
//   @override
//   void dispose() {
//     super.dispose();
//     // _userName.dispose();
//     _userEmail.dispose();
//     _userPassword.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     initPrefs();
//   }
//
//   initPrefs() async {
//     prefs = await SharedPreferences.getInstance();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Form(
//         key: _formKey,
//         child: Card(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text('Welcome'),
//               const SizedBox(
//                 height: 10,
//               ),
//               const Text('-------Sign In-------'),
//               const SizedBox(
//                 height: 10,
//               ),
//               // SizedBox(
//               //   width: 300,
//               //   child: TextFormField(
//               //     validator: (name) => name == null || name.isEmpty
//               //         ? 'Field Required'
//               //         : (name.length < 4 ? 'Enter full name' : null),
//               //     controller: _userName,
//               //     decoration: InputDecoration(
//               //       border: OutlineInputBorder(
//               //         borderRadius: BorderRadius.circular(10),
//               //       ),
//               //       label: const Text('Enter your name'),
//               //     ),
//               //   ),
//               // ),
//               const SizedBox(
//                 height: 10,
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 width: 300,
//                 child: TextFormField(
//                   controller: _userEmail,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     label: const Text('Enter your email'),
//                   ),
//                   validator: (email) {
//                     if (email == null || email.isEmpty) {
//                       return 'Field required';
//                     }
//                     String pattern =
//                         r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'; // Basic email pattern
//                     RegExp regex = RegExp(pattern);
//                     if (!regex.hasMatch((email))) {
//                       return ' Enter valid email';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 width: 300,
//                 child: TextFormField(
//                   validator: (value) {
//                     if (value!.length < 6) {
//                       return 'Password must be at least 6 characters long';
//                     }
//                     if (!value.contains(RegExp(r'\d'))) {
//                       return 'Password must contain at least one number';
//                     }
//                     return null;
//                   },
//                   obscureText: _isPasswordVisible,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       label: const Text('Enter your password'),
//                       suffixIcon: IconButton(
//                         onPressed: () {
//                           setState(() {
//                             _isPasswordVisible = !_isPasswordVisible;
//                           });
//                         },
//                         icon: _isPasswordVisible
//                             ? const Icon(Icons.remove_red_eye)
//                             : const Icon(Icons.remove_red_eye_outlined),
//                       )),
//                   controller: _userPassword,
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     TextButton(
//                         onPressed: () {
//                           Navigator.pushNamed(context, '/password');
//                         },
//                         child: const Text(
//                           'Forgot Password',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         )),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     isLoading
//                         ? const CircularProgressIndicator()
//                         : ElevatedButton(
//                         onPressed: _signIn, child: const Text('Sign In')),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _signIn() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       setState(() {
//         isLoading = true; // Set loading state to true
//       });
//       try {
//         String userEmail = _userEmail.text;
//         String userPassword = _userPassword.text;
//
//         UserCredential userCredential = await FirebaseAuth.instance
//             .signInWithEmailAndPassword(
//             email: userEmail, password: userPassword);
//
//         User? user = userCredential.user;
//
//         if (user != null) {
//           print('User is successfully Signed In');
//
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           await prefs.clear();
//           prefs.setString('userEmail', userEmail);
//           prefs.setString('userPassword', userPassword);
//
//           Navigator.pushNamed(context, '/home');
//         } else {
//           print('ERROR');
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Sign In Failed. Try Again!!'),
//               backgroundColor: Colors.red, // Optionally set a background color
//               duration: Duration(seconds: 3), // Duration to show the SnackBar
//             ),
//           );
//         }
//       } catch (e) {
//         print('Error: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Sign In Failed. Try Again!!'),
//             backgroundColor: Colors.red, // Optionally set a background color
//             duration: Duration(seconds: 3), // Duration to show the SnackBar
//           ),
//         );
//       } finally {
//         setState(() {
//           isLoading = false; // Set loading state to false
//         });
//       }
//     }
//   }
// }
