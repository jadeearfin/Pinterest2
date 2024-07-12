import 'dart:async';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Pinterest/services/download_service.dart';
import 'package:Pinterest/services/unsplash_service.dart';
import 'package:unsplash_client/unsplash_client.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _timer; // Timer for debouncing
  final List<Photo> _photos = [];
  final List<bool> _isHidden = [];

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    var photos = await UnsplashService.getRandomPhoto(30);
    setState(() {
      _photos.addAll(photos);
      _isHidden.addAll(List<bool>.filled(photos.length, false));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onSearch(String value) async {
    if (_searchController.text.isEmpty) return;

    if (_timer?.isActive ?? false) _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 1000), () async {
      final photos = await UnsplashService.searchPhoto(value);
      setState(() {
        _photos.clear();
        _photos.addAll(photos);
        _isHidden.clear();
        _isHidden.addAll(List<bool>.filled(photos.length, false));
      });
    });
  }

  void handleMenuAction(
      String value, BuildContext context, int index, Photo photo) async {
    switch (value) {
      case 'Download':
        final isDownload =
            await downloadImage(photo.urls.thumb.toString(), photo.id);
        if (isDownload) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image downloaded successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to download image'),
              backgroundColor: Colors.red,
            ),
          );
        }
        break;
      case 'Hide':
        setState(() {
          _isHidden[index] = true;
        });
        break;
      case 'Report':
        _showReportMenu(context);
        break;
    }
  }

  void _showReportMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: const [
            ListTile(title: Text('Spam')),
            ListTile(title: Text('Nudity, pornography or sexualized content')),
            ListTile(title: Text('Self-harm')),
            ListTile(title: Text('Misinformation')),
            ListTile(title: Text('Hateful activities')),
            ListTile(title: Text('Dangerous goods')),
            ListTile(title: Text('Harassment or criticism')),
            ListTile(title: Text('Graphic violence')),
            ListTile(title: Text('Privacy violation')),
            ListTile(title: Text('My intellectual property')),
            ListTile(title: Text('')),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Image.network(
            _photos[index].urls.regular.toString(),
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _onSearch,
          decoration: const InputDecoration(
            hintText: 'Search for ideas',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Recommendation',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _photos.length,
              itemBuilder: (context, index) {
                return buildPhotoItem(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPhotoItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _showMyDialog(index),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _isHidden[index]
                  ? ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Image.network(
                        _photos[index].urls.thumb.toString(),
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.center,
                      ),
                    )
                  : Image.network(
                      _photos[index].urls.thumb.toString(),
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                    ),
            ),
            if (_isHidden[index])
              Positioned(
                right: 5,
                bottom: 5,
                child: ElevatedButton(
                  onPressed: () => setState(() {
                    _isHidden[index] = false;
                  }),
                  child: const Text('Undo Hide'),
                ),
              ),
            Positioned(
              right: 5,
              bottom: 5,
              child: PopupMenuButton<String>(
                onSelected: (value) =>
                    handleMenuAction(value, context, index, _photos[index]),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Download',
                    child: Text('Download image'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Hide',
                    child: Text('Hide pin'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Report',
                    child: Text('Report pin'),
                  ),
                ],
                icon: const Icon(Icons.more_horiz, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
