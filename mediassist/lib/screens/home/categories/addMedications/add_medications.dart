import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mediassist/screens/home/home_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mediassist/ngrokurl.dart';
import 'package:flutter/cupertino.dart';

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
      'time_morning': morningTimeController.text,
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
          'cookie': sessionCookie ?? '',
        },
        body: jsonEncode(data),
      );

      setState(() {
        isLoading = false;
      });

      final responseBody = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseBody["message"])),
      );

      if (response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
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
        title: const Text(
          "Add Medicine",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInputField(
                  controller: nameController,
                  labelText: 'Medicine Name',
                  icon: CupertinoIcons.capsule,
                ),
                const SizedBox(height: 16.0),
                _buildInputField(
                  controller: morningTimeController,
                  labelText: 'Morning Time (HH:MM:SS)',
                  icon: CupertinoIcons.sunrise,
                ),
                const SizedBox(height: 16.0),
                _buildInputField(
                  controller: eveningTimeController,
                  labelText: 'Evening Time (HH:MM:SS)',
                  icon: CupertinoIcons.sunset,
                ),
                const SizedBox(height: 16.0),
                _buildInputField(
                  controller: nightTimeController,
                  labelText: 'Night Time (HH:MM:SS)',
                  icon: CupertinoIcons.moon_stars,
                ),
                const SizedBox(height: 16.0),
                _buildInputField(
                  controller: instructionsController,
                  labelText: 'Instructions',
                  icon: CupertinoIcons.pencil_outline,
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isLoading ? null : addMedicine,
        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
        child: const Icon(Icons.check),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: const Color.fromRGBO(143, 148, 251, 1)),
        ),
      ),
    );
  }
}
