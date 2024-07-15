// import 'package:flutter/material.dart';
//
// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Profile')),
//
//       body:const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             CircleAvatar(
//               radius: 65,
//             ),
//             SizedBox(height: 30),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Text('Name: '),
//                 SizedBox(height: 20),
//                 Text('Email: '),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  String? _userName;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadImage();
    _loadUserDetails();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _saveImage(_image!);
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
    setState(() {
      _userName = prefs.getString('UserName');
      _userEmail = prefs.getString('userEmail');
    });
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Welcome'),
          content: const Text('Hey, welcome to PAMA app'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'),
      leading:const Icon(Icons.arrow_back_ios),
      automaticallyImplyLeading: false,
      actions: [
        IconButton( onPressed: () {
          _showInfoDialog(context);
        }, icon:const Icon(Icons.info_outline),)
      ],),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Name: ${_userName ?? 'Unknown'}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                Text(
                  'Email: ${_userEmail ?? 'Unknown'}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
