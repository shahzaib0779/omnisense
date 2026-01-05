import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omnisense/home_screen.dart';
import 'package:omnisense/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Requirement: Session handling using Firebase Auth State
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the snapshot has data, the user is logged in
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        // Otherwise, they need to log in
        return const LoginScreen();
      },
    );
  }
}
