import 'package:flutter/material.dart';

class HelpButton extends StatelessWidget {
  const HelpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        onTap: () {
          // Navigate to HelpScreen when tapped
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => HelpScreen()),
          // );
        },
        child: SizedBox(
          width: 135,
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFB090DD),
                  Color(0xFF5151B7),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: const Text(
              "Need Help?",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
