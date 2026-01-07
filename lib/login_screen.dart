import 'package:firebase_auth/firebase_auth.dart';
import 'package:omnisense/greeting_screen.dart';
import 'package:omnisense/signup_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String displayTitle = "";
  final String firstWord = "Welcome To";
  final String finalAppName = "OmniSense";

  // State variables for UI feedback
  bool _isPasswordVisible = false;
  bool _isLoading = false; // Added loading state

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startTypewriterAnimation();
  }

  // --- LOGIN LOGIC WITH PROGRESS INDICATOR ---
  Future<void> _login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showError("Please enter both email and password.");
      return;
    }

    // Start loading spinner
    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Navigate to Home on success
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GreetingScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showError("No user found for that email. Please register first.");
      } else if (e.code == 'wrong-password') {
        _showError("Wrong password provided for that user.");
      } else {
        _showError(e.message ?? "An error occurred.");
      }
    } finally {
      // Stop loading spinner even if there's an error
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: "Montserrat"),
        ),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  // --- FORGOT PASSWORD LOGIC ---
  Future<void> _resetPassword() async {
    if (emailController.text.isEmpty || !emailController.text.contains('@')) {
      _showError("Please enter a valid email address first.");
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Password reset link sent to your email!",
            style: TextStyle(fontFamily: "Montserrat"),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      _showError("Failed to send reset email.");
    }
  }

  void _startTypewriterAnimation() async {
    for (int i = 0; i <= firstWord.length; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (!mounted) return;
      setState(() => displayTitle = firstWord.substring(0, i));
    }
    await Future.delayed(const Duration(seconds: 1));
    for (int i = firstWord.length; i >= 0; i--) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      setState(() => displayTitle = firstWord.substring(0, i));
    }
    for (int i = 0; i <= finalAppName.length; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (!mounted) return;
      setState(() => displayTitle = finalAppName.substring(0, i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                displayTitle,
                style: const TextStyle(
                  fontSize: 36,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0A74DA),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "AI-Powered Intelligence",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueGrey,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 50),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined, size: 20),
                  labelText: "Email Address",
                  labelStyle: TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                style: const TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                  labelText: "Password",
                  labelStyle: const TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 20,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(
                      () => _isPasswordVisible = !_isPasswordVisible,
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _isLoading
                      ? null
                      : _resetPassword, // Disable link while loading
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0A74DA),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // --- BUTTON WITH LOADING INDICATOR ---
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : _login, // Disable button while loading
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "SIGN IN",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "New to OmniSense?",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      color: Colors.black54,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Create Account",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0A74DA),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
