import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mediassist/screens/home/home_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mediassist/ngrokurl.dart';

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({super.key});

  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController morningTimeController = TextEditingController();
  final TextEditingController eveningTimeController = TextEditingController();
  final TextEditingController nightTimeController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  bool isLoading = false;

  Future<void> addMedicine() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionCookie = prefs.getString('session');

    const String url = '${ConfigUrl.baseUrl}/add_medicine';
    final Map<String, dynamic> data = {
      'name': nameController.text,
      'time_morning': morningTimeController.text, // "HH:MM:SS" format expected
      'time_evening': eveningTimeController.text,
      'time_night': nightTimeController.text,
      'instructions': instructionsController.text,
    };

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'cookie': sessionCookie ?? '', // Include session cookie
        },
        body: jsonEncode(data),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody["message"])),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        final responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody["message"])),
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
        title: const Text("Add Medicine"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Medicine Name',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: morningTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Morning Time (HH:MM:SS)',
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: eveningTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Evening Time (HH:MM:SS)',
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: nightTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Night Time (HH:MM:SS)',
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: instructionsController,
                  decoration: const InputDecoration(
                    labelText: 'Instructions',
                  ),
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : addMedicine, // Disable button when loading
                  child: const Text("Add Medicine"),
                ),
              ],
            ),
          ),
          if (isLoading) ...[
            const ModalBarrier(
              color: Colors.black54,
              dismissible: false,
            ),
            const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ],
      ),
    );
  }
}
