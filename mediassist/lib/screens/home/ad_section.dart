import 'package:flutter/material.dart';

class LookingRoomatesCard extends StatelessWidget {
  const LookingRoomatesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.6,
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Took your meds yet?...',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16.0),
          const Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Color.fromRGBO(143, 148, 251, 1),
              ),
              SizedBox(width: 8.0),
              Text('update your meds'),
            ],
          ),
          const SizedBox(height: 8.0),
          const Row(
            children: [
              Icon(Icons.check_circle, color: Color.fromRGBO(143, 148, 251, 1)),
              SizedBox(width: 8.0),
              Text('Complete your profile'),
            ],
          ),
          const SizedBox(height: 8.0),
          const Row(
            children: [
              Icon(Icons.check_circle, color: Color.fromRGBO(143, 148, 251, 1)),
              SizedBox(width: 8.0),
              Text('Check your reports'),
            ],
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Get Started'),
            ),
          ),
        ],
      ),
    );
  }
}
