import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImageProvider extends ChangeNotifier {
  ImageProvider() {
    fetchImages();
  }

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = const Uuid();
  final _user = FirebaseAuth.instance.currentUser;

  List<String> _imageUrls = [];

  List<String> get imageUrls => _imageUrls;

  Future<void> uploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final fileName = _uuid.v4();

    try {
      final ref = _storage.ref().child('images/${_user?.uid}/$fileName');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      _imageUrls.add(url);
      notifyListeners();
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> deleteImage(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
      _imageUrls.remove(url);
      notifyListeners();
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  Future<void> fetchImages() async {
    try {
      if (_user != null) {
        final ListResult result =
            await _storage.ref('images/${_user!.uid}').listAll();
        final List<String> urls =
            await Future.wait(result.items.map((Reference ref) async {
          return await ref.getDownloadURL();
        }).toList());
        _imageUrls = urls;
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching images: $e');
    }
  }

  Future<void> downloadImage(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final File downloadToFile = File('${appDocDir.path}/${ref.name}');

      await ref.writeToFile(downloadToFile);

      print('File downloaded to ${downloadToFile.path}');
    } catch (e) {
      print('Error downloading image: $e');
    }
  }
}
