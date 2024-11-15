import 'package:flutter/material.dart';
import 'package:gradient_icon/gradient_icon.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildRectangle(Icons.person, "Edit Profile", () {}),
        const SizedBox(width: 10),
        buildRectangle(Icons.verified_user, "Get Verified", () {}),
        const SizedBox(width: 10),
        buildRectangle(Icons.account_balance_wallet, "Terms", () {}),
      ],
    );
  }

  Widget buildRectangle(IconData icon, String text, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientIcon(
              icon: icon,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(143, 148, 251, 1), // Start color
                  Color.fromRGBO(143, 148, 251, 1), // End color
                ],
              ),
              size: 25,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey, // Start color
                      Colors.grey, // End color
                    ],
                  ).createShader(bounds);
                },
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
