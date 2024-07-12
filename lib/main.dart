import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' hide ImageProvider;
import 'package:Pinterest/firebase_options.dart';
import 'package:Pinterest/provider/image_provider.dart';
import 'package:Pinterest/screen/login_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ImageProvider())],
      child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}
