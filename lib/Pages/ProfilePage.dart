import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback? onImageChanged;
  const ProfilePage({super.key, this.onImageChanged});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  String? _userName;
  String? _userEmail;
  String? _userDepartment;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadImage();
    _loadUserDetails();
    _loadProfileImage();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _saveImage(_image!);
      if (widget.onImageChanged != null) {
        widget.onImageChanged!(); // Notify the HomePage
      }
    }
  }

  Future<void> _saveImage(File image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(image.path);
    final localImage = await image.copy('${directory.path}/$name');
    prefs.setString('profile_image', localImage.path);
  }

  Future<void> _loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profile_image');

    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  Future<void> _loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? name = prefs.getString('userName');
    String? email = prefs.getString('userEmail');
    String? department = prefs.getString('department');

    setState(() {
      _userName = name ?? 'Unknown';
      _userEmail = email ?? 'Unknown';
      _userDepartment = department ?? 'Unknown';
    });
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Welcome'),
          content: Text('Hello $_userName , welcome to PAMA app'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
          title: const Text('Profile'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/settings');
            },
          ),
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
              onPressed: () {
                _showInfoDialog(context);
              },
              icon: const Icon(Icons.info_outline),
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 65,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? const Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Name: ${_userName ?? 'Unknown'}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Text(
                'Email: ${_userEmail ?? 'Unknown'}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Text(
                'Department: ${_userDepartment ?? 'Unknown'}',
                style: const TextStyle(fontSize: 18),
              )
            ],
            // ),
          ),
        ));
  }
}

class ImageScreen extends StatelessWidget {
  final String imagePath;

  const ImageScreen(this.imagePath, {super.key});

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
