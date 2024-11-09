import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mediassist/ngrokurl.dart';
import 'package:mediassist/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class AddAppointments extends StatelessWidget {
  final TextEditingController _doctorNameController = TextEditingController();
  final TextEditingController _appointmentDatetimeController =
      TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();

  // Method to add an appointment
  Future<void> addAppointment(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionCookie = prefs.getString('session');

    try {
      var response = await http.post(
        Uri.parse('${ConfigUrl.baseUrl}/add_appointment'), // Flask API URL
        headers: {
          'Content-Type': 'application/json',
          'cookie': sessionCookie ?? '',
        },
        body: json.encode({
          'doctor_name': _doctorNameController.text,
          'appointment_datetime': _appointmentDatetimeController.text,
          'hospital_name': _hospitalNameController.text,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment added successfully.')),
          
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else if (response.statusCode == 400) {
        var responseData = json.decode(response.body);
        String message = responseData['message'] ?? 'Unknown error';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add appointment.')),
        );
      }
    } catch (e) {
      print('Error adding appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while adding the appointment.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Appointment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Doctor Name Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _doctorNameController,
                    decoration: InputDecoration(
                      labelText: 'Doctor Name',
                      prefixIcon: const Icon(
                        CupertinoIcons.person,
                        color: Color.fromRGBO(143, 148, 251, 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Appointment Date & Time Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _appointmentDatetimeController,
                    decoration: InputDecoration(
                      labelText:
                          'Appointment Date & Time (YYYY-MM-DD HH:MM:SS)',
                      prefixIcon: const Icon(
                        CupertinoIcons.calendar,
                        color: Color.fromRGBO(143, 148, 251, 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Hospital Name Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _hospitalNameController,
                    decoration: InputDecoration(
                      labelText: 'Hospital Name',
                      prefixIcon: const Icon(
                        CupertinoIcons.plus,
                        color: Color.fromRGBO(143, 148, 251, 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Add Appointment Button
              ElevatedButton(
                onPressed: () => addAppointment(context),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Add Appointment'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
