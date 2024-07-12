import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:Pinterest/services/download_service.dart';
import 'package:Pinterest/services/unsplash_service.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:unsplash_client/unsplash_client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Photo> _listPhoto = [];
  final List<bool> _isHidden = [];
  // ignore: unused_field
  final Random _random = Random();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadPhotos();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadPhotos() async {
    var photos = await UnsplashService.getRandomPhoto(30);
    setState(() {
      _listPhoto.addAll(photos);
      _isHidden.addAll(List<bool>.filled(photos.length, false));
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

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadPhotos();
    }
  }

  Future<void> _showMyDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Image.network(
            _listPhoto[index].urls.regular.toString(),
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MasonryGridView.count(
            crossAxisCount: 2,
            controller: _scrollController,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemCount: _listPhoto.length,
            itemBuilder: (context, index) {
              return buildPhotoItem(context, index);
            },
          ),
        ),
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
                        _listPhoto[index].urls.thumb.toString(),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.network(
                      _listPhoto[index].urls.thumb.toString(),
                      fit: BoxFit.cover,
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
                    handleMenuAction(value, context, index, _listPhoto[index]),
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
