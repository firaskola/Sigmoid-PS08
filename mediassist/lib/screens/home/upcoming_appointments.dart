import 'package:flutter/material.dart';
import 'package:mediassist/screens/appointment/appointments.dart';
import 'package:mediassist/screens/home/categories/appointments/add_appointments.dart';
import 'package:mediassist/screens/medications/medications_screen.dart';

class UpcomingAppointments extends StatelessWidget {
  final String date;
  final String time;
  final String doctorName;
  final String details;

  const UpcomingAppointments({
    Key? key,
    required this.date,
    required this.time,
    required this.doctorName,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AppointmentsScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.only(right: 8), // Add margin to the right
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        height: 120,
        width:
            MediaQuery.of(context).size.width - 32, // Fixed width for each item
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Side - Date
            Container(
              width: 80,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    date.split(" ")[0], // Extract day
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(143, 148, 251, 1),
                    ),
                  ),
                  Text(
                    date.split(" ")[1], // Extract month
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(143, 148, 251, 1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12), // Space between date and details

            // Right Side - Appointment Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Color.fromRGBO(143, 148, 251, 1),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: Color.fromRGBO(143, 148, 251, 1),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        doctorName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.note_alt,
                        color: Color.fromRGBO(143, 148, 251, 1),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        details,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
