import 'package:flutter/material.dart';
import 'package:Pinterest/screen/add_screen.dart';
import 'package:Pinterest/screen/home_screen.dart';
import 'package:Pinterest/screen/explore_screen.dart';
import 'package:Pinterest/screen/notification_screen.dart';
import 'package:Pinterest/screen/profile_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    const HomeScreen(),
    const ExploreScreen(),
    const AddScreen(),
    const NotificationScreen(),
    ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.home), label: ''),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.search), label: ''),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.plusSquare), label: ''),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.commentDots), label: ''),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.user), label: ''),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red[800],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
