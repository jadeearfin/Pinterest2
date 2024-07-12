import 'package:flutter/material.dart';
import 'package:Pinterest/services/unsplash_service.dart';
import 'package:unsplash_client/unsplash_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          _buildSection(
            title: "Pins inspired by you",
            itemCount: 3,
            future: UnsplashService.getRandomPhoto(3),
          ),
          _buildSection(
            title:
                "Violation notice. Visit your reports and violations centre for more information.",
            itemCount: 0,
            future: UnsplashService.getRandomPhoto(1),
          ),
          _buildSection(
            title: "Your home feed has new Pins",
            itemCount: 4,
            future: UnsplashService.getRandomPhoto(4),
          ),
          _buildSection(
            title: "Pins inspired by you",
            itemCount: 5,
            future: UnsplashService.getRandomPhoto(5),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required int itemCount,
    required Future<List<Photo>> future,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  return Image.network(
                    snapshot.data![index].urls.thumb.toString(),
                    fit: BoxFit.cover,
                  );
                },
              );
            } else {
              return const Center(child: Text('No images available'));
            }
          },
        ),
      ],
    );
  }
}
