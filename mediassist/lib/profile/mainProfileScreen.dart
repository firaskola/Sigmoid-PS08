import 'package:flutter/material.dart';
import 'package:mediassist/profile/helpButton.dart';
import 'package:mediassist/profile/profileBody.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 20),
              child: const ProfileBody(),
            ),
          ),
          const Positioned(
            bottom: 0,
            right: 10,
            child: HelpButton(),
          ),
        ],
      ),
    );
  }
}
