// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mediassist/ngrokurl.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  _MedicationsScreenState createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  List<dynamic> medicines = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMedicines();
  }

  Future<void> fetchMedicines() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionCookie = prefs.getString('session');
    const String url =
        '${ConfigUrl.baseUrl}/get_medicines'; // Endpoint for fetching medicines

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'cookie':
              sessionCookie ?? '', // Use session cookie for authentication
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          medicines = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load medicines')),
        );
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medications"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : medicines.isEmpty
              ? const Center(child: Text("No medications found"))
              : ListView.builder(
                  itemCount: medicines.length,
                  itemBuilder: (context, index) {
                    final medicine = medicines[index];
                    return ListTile(
                      title: Text(medicine['name']),
                      subtitle: Text(
                        "Morning: ${medicine['time_morning'] ?? 'Not set'}\n"
                        "Evening: ${medicine['time_evening'] ?? 'Not set'}\n"
                        "Night: ${medicine['time_night'] ?? 'Not set'}\n"
                        "Instructions: ${medicine['instructions']}",
                      ),
                      leading: const Icon(Icons.medication),
                    );
                  },
                ),
    );
  }
}
