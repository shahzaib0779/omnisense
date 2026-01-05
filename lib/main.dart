import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:omnisense/auth_wrapper.dart';
import 'package:omnisense/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0A74DA);
    const Color secondaryCyan = Color(0xFF00D4FF); // Modernity
    const Color backgroundGray = Color(0xFFF8FAFC); // Clean Surface
    const Color errorRed = Color(0xFFD32F2F); // For Firebase Auth Errors

    return MaterialApp(
      title: 'OmniSense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,

        // Setting up the color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          primary: primaryBlue,
          secondary: secondaryCyan,
          surface: Colors.white,
          // ignore: deprecated_member_use
          background: backgroundGray,
          error: errorRed,
          onPrimary: Colors.white,
        ),

        // Global Input Decoration for a "Smart" feel
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: primaryBlue, width: 2),
          ),
        ),

        // Global Button Style
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 2,
          ),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}
