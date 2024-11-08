import 'package:flutter/material.dart';
import 'package:mediassist/profile/otherProfileScreens/about_us_screen.dart';
import 'package:mediassist/profile/otherProfileScreens/legal_screen.dart';
import 'package:mediassist/profile/otherProfileScreens/settings_screen.dart';

class AdditionalOptions extends StatelessWidget {
  final VoidCallback onTapLogout;

  const AdditionalOptions({
    Key? key,
    required this.onTapLogout,
  }) : super(key: key);

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          title: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 0, horizontal: 20), // Adjust padding as needed
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 22, // Adjust size as needed
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          content: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 0),
                  child: Text(
                    'Are you sure you want to logout?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Divider(
                  height: 0, // No space above the divider
                  thickness: 1, // Thickness of the divider
                  color: Colors.grey[700], // Color of the divider
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                    ),
                    Container(
                      height:
                          50, // Adjust height to match the height of the buttons
                      width: 1, // Thickness of the divider
                      color: Colors.grey[700], // Color of the divider
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: onTapLogout,
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.red, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildAdditionalRectangle("Settings", icon: Icons.settings, onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SettingsScreen()));
        }),
        const SizedBox(height: 20),
        buildAdditionalRectangle("Legal", icon: Icons.description, onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LegalScreen()));
        }),
        const SizedBox(height: 20),
        buildAdditionalRectangle("About Us", icon: Icons.info, onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AboutUsScreen()));
        }),
        const SizedBox(height: 20),
        buildAdditionalRectangle("Logout",
            color: Colors.red,
            showArrow: false,
            fontWeight: FontWeight.bold, onTap: () {
          _showLogoutConfirmationDialog(context);
        }),
      ],
    );
  }

  Widget buildAdditionalRectangle(String text,
      {IconData? icon,
      Color color = Colors.grey,
      bool showArrow = true,
      FontWeight? fontWeight,
      void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
        margin: const EdgeInsets.symmetric(vertical: 0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: Colors.black54,
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15.8,
                  color: showArrow ? Colors.black54 : Colors.red,
                  fontWeight: fontWeight,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            if (showArrow && icon != null)
              const Icon(
                Icons.arrow_forward,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
}
