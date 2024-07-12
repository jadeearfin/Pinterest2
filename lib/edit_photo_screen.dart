// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'database_helper.dart';
import 'photo.dart';
import 'dart:io';

class EditPhotoScreen extends StatefulWidget {
  final Photo photo;

  EditPhotoScreen({required this.photo});

  @override
  _EditPhotoScreenState createState() => _EditPhotoScreenState();
}

class _EditPhotoScreenState extends State<EditPhotoScreen> {
  late File _image;
  bool _imageChanged = false;

  @override
  void initState() {
    super.initState();
    _image = File(widget.photo.path);
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageChanged = true;
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> _updatePhoto() async {
    if (_imageChanged) {
      final updatedPhoto = widget.photo.copy(path: _image.path);
      await DatabaseHelper.instance.update(updatedPhoto);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Photo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? const Text('No image selected.')
                : Image.file(_image),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image from Gallery'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updatePhoto,
              child: const Text('Update Photo'),
            ),
          ],
        ),
      ),
    );
  }
}
