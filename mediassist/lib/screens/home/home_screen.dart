// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:mediassist/nav_bar/bottom_navbar.dart';
import 'package:mediassist/screens/home/categories/categories.dart';
import 'package:mediassist/screens/medications/medications_screen.dart';
import 'package:mediassist/screens/profile/profile_screen.dart';
import 'package:mediassist/screens/reports/reports_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPage = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const MedicationsScreen(),
    const ReportsScreen(),
    const ProfileScreen(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPage],
      bottomNavigationBar: BottomNavigation(
        selectedPage: _selectedPage,
        onPageChanged: _onPageChanged,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: const Center(
        child: Text("Homepage"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Categories(), // Navigate to SignUpScreen
            ),
          );

          // Add your action here, e.g., navigating to a new page or opening a dialog.
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
