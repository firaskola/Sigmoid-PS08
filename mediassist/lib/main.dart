import 'package:flutter/material.dart';
import 'package:mediassist/authentication_pages/login_page.dart';
import 'package:mediassist/screens/home/categories/add_medications.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Primary color used across the app
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromRGBO(143, 148, 251, 1),
          secondary: const Color.fromRGBO(143, 148, 251, .6),
        ),

        // Background color for scaffold widgets
        scaffoldBackgroundColor: const Color.fromRGBO(245, 245, 245, 1),

        // TextTheme controls the styles of different text types used throughout the app
        textTheme: const TextTheme(
          // Large headings
          displayLarge: TextStyle(
              fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),

          // Headline styles
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 61, 61, 61),
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 61, 61, 61),
          ),
          headlineSmall: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 61, 61, 61),
          ),

          // General body text
          bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),

          // Smaller text
          bodyMedium: TextStyle(color: Colors.grey, fontSize: 14),
        ),

        // ElevatedButtonTheme controls the styling of ElevatedButtons in the app
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            // Background color for ElevatedButtons
            backgroundColor: const Color.fromRGBO(143, 148, 251, 1),

            // Color for button text
            foregroundColor: Colors.white,

            // Button shape with rounded corners
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        // InputDecorationTheme sets default styling for InputDecoration used in TextFields
        inputDecorationTheme: InputDecorationTheme(
          // Hint text style
          hintStyle: TextStyle(color: Colors.grey[700]),

          // No default border shown in text fields
          border: InputBorder.none,
        ),
      ),
      home: const AddMedicationsPage(),
    );
  }
}
