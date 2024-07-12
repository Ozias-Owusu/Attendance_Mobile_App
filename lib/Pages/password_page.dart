import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final _userEmail = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _userEmail.dispose();
  }

  Future<void> passwordreset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _userEmail.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent')),
      );
      Navigator.pushReplacementNamed(context, '/');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Enter an email for link to reset password'),
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
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 10),
              ],
              MaterialButton(
                onPressed: passwordreset,
                child: const Text('Reset password'),
              ),
            ],
          ),
        ));
  }
}
