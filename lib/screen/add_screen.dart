import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide ImageProvider;
import 'package:Pinterest/provider/image_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  // Future<void> _pickImage() async {
  //   final PermissionStatus permission = await Permission.photos.request();
  //   print(permission);
  //   if (permission.isGranted) {
  //     final picker = ImagePicker();
  //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //     if (pickedFile != null) {
  //       setState(() {
  //         _image = File(pickedFile.path);
  //       });
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => CreatePostScreen(image: _image!),
  //         ),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final imageProvider = context.read<ImageProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await imageProvider.uploadImage();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Photo uploaded (view profile)")));
                }
              },
              child: const Text('Pick Image from Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
