import 'package:flutter/material.dart';
import 'package:gradient_icon/gradient_icon.dart';
import 'package:mediassist/profile/otherProfileScreens/get_verified_screen.dart';
import 'package:mediassist/profile/otherProfileScreens/view_profile_screen.dart';
import 'package:mediassist/profile/otherProfileScreens/wallet_screen.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildRectangle(Icons.person, "View Profile", () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ViewProfileScreen()));
        }),
        const SizedBox(width: 10),
        buildRectangle(Icons.verified_user, "Get Verified", () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => GetVerifiedScreen()));
        }),
        const SizedBox(width: 10),
        buildRectangle(Icons.account_balance_wallet, "Wallet", () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => WalletScreen()));
        }),
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
              spreadRadius: 1,
              blurRadius: 2,
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
                  Color(0xFFB090DD), // Start color
                  Color(0xFF5151B7), // End color
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
                      Color(0xFFB090DD), // Start color
                      Color(0xFF5151B7), // End color
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
