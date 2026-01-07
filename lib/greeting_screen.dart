import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart'; // Ensure this matches your home screen file

class GreetingScreen extends StatefulWidget {
  const GreetingScreen({super.key});

  @override
  State<GreetingScreen> createState() => _GreetingScreenState();
}

class _GreetingScreenState extends State<GreetingScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to Home after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get stored name from Firebase Auth profile
    final String? userName = FirebaseAuth.instance.currentUser?.displayName;
    final String firstName = userName?.split(' ').first ?? "User";

    return Scaffold(
      backgroundColor: Colors.white, // Simple White Background
      body: Center(
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1500),
          tween: Tween<double>(begin: 0.0, end: 1.0), // Strict 0 to 1 range
          curve: Curves.easeIn, // Smooth fade to avoid the "Opacity Error"
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Waving Hand in OmniSense Blue
                  const Icon(
                    Icons.waving_hand,
                    color: Color(0xFF0A74DA),
                    size: 70,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Hello, $firstName",
                    style: const TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A74DA),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "OmniSense is ready.",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
