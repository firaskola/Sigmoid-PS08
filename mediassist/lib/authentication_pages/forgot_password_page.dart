import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 270,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background2.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 1600),
                      child: Container(
                        margin: const EdgeInsets.only(top: 0),
                        child: Center(
                          child: Text(
                            "Forgot Password",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  FadeInUp(
                    duration: const Duration(milliseconds: 1800),
                    child: Column(
                      children: [
                        // Email Text Field
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: Theme.of(context)
                                    .inputDecorationTheme
                                    .hintStyle,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              style: const TextStyle(
                                  height: 1.5), // Adjust text height
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInUp(
                    duration: const Duration(milliseconds: 2000),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle Forget Password action
                        },
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 15)),
                          backgroundColor: WidgetStateProperty.all(
                              Theme.of(context).colorScheme.primary),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          minimumSize: WidgetStateProperty.all(
                              const Size.fromHeight(
                                  56)), // Standard button height
                        ),
                        child: const Text("Send Reset Link"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Back to Login option
                  FadeInUp(
                    duration: const Duration(milliseconds: 2100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Remembered your password? ",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
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
