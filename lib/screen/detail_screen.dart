import 'package:flutter/material.dart';
import 'package:unsplash_client/unsplash_client.dart';

class DetailScreen extends StatelessWidget {
  final Photo photo;

  const DetailScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Detail'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              photo.urls.full as String,
              fit: BoxFit.cover,
              height: 300,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                photo.description ?? 'No description available',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            // Additional photo details or actions can be added here
          ],
        ),
      ),
    );
  }
}
