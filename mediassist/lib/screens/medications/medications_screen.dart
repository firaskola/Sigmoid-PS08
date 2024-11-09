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

  // Fetch medicines from the backend
  Future<void> fetchMedicines() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionCookie = prefs.getString('session');
    const String url = '${ConfigUrl.baseUrl}/get_medicines';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'cookie': sessionCookie ?? '',
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

  // Delete a medicine from the backend
  Future<void> deleteMedicine(String medicineId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionCookie = prefs.getString('session');

    final String url =
        '${ConfigUrl.baseUrl}/delete_medicine/$medicineId'; // Adjust the URL for your backend

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'cookie': sessionCookie ?? '',
        },
      );

      if (response.statusCode == 200) {
        // If the server returns a successful response
        setState(() {
          medicines.removeWhere((medicine) => medicine['id'] == medicineId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medicine deleted successfully')),
        );
      } else {
        // If the server returns an error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to delete medicine: ${response.body}')),
        );
      }
    } catch (error) {
      // Catch any other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          "Medications",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : medicines.isEmpty
              ? const Center(child: Text("No medications found"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: medicines.length,
                    itemBuilder: (context, index) {
                      final medicine = medicines[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.medication,
                                      size: 28,
                                      color: Color.fromRGBO(143, 148, 251, 1)),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      medicine['name'],
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: const Color.fromRGBO(
                                            143, 148, 251, 1)),
                                    onPressed: () {
                                      // Confirm before deleting
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Delete Medicine'),
                                          content: const Text(
                                              'Are you sure you want to delete this medicine?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                deleteMedicine(medicine['id']);
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if (medicine['time_morning'] != null)
                                Text(
                                  "Morning: ${medicine['time_morning']}",
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              if (medicine['time_afternoon'] != null)
                                Text(
                                  "Afternoon: ${medicine['time_afternoon']}",
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              if (medicine['time_night'] != null)
                                Text(
                                  "Night: ${medicine['time_night']}",
                                  style: const TextStyle(color: Colors.black54),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
