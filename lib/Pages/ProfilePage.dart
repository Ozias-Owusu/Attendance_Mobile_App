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

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
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
            const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Name: '),
                SizedBox(height: 20),
                Text('Email: '),
              ],
            )
          ],
        ),
      ),
    );
  }
}

