import 'package:flutter/material.dart';

class UpcomingAppointments extends StatelessWidget {
  const UpcomingAppointments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     spreadRadius: 2,
        //     blurRadius: 6,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      margin: const EdgeInsets.only(right: 8), // Add margin to the right
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      height: 120,
      width: MediaQuery.sizeOf(context).width -
          32, // Fixed width for each item in the ListView
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Side - Date
          Container(
            width: 130,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "12",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(143, 148, 251, 1),
                  ),
                ),
                Text(
                  "Nov",
                  style: TextStyle(
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
                      "10:30 AM",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Color.fromRGBO(143, 148, 251, 1),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Dr. John Doe",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(
                      Icons.note_alt,
                      color: Color.fromRGBO(143, 148, 251, 1),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Regular Checkup",
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
    );
  }
}
