import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:omnisense/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String displayTitle = "";
  bool isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final String targetText = "Let's Connect :)";

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Error Strings for Field Validation
  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _startTypewriterAnimation();
  }

  void _startTypewriterAnimation() async {
    for (int i = 0; i <= targetText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (!mounted) return;
      setState(() => displayTitle = targetText.substring(0, i));
    }
  }

  // Validation Logic
  bool _validateFields() {
    // Regex: At least one uppercase, one lowercase, and one digit
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$');

    setState(() {
      nameError = nameController.text.isEmpty ? "Username is required" : null;
      emailError = emailController.text.isEmpty ? "Email is required" : null;

      String password = passwordController.text;

      if (password.length < 8) {
        passwordError = "Password must be at least 8 characters";
      } else if (!passwordRegex.hasMatch(password)) {
        passwordError = "Use uppercase, lowercase, and a number";
      } else {
        passwordError = null;
      }

      if (confirmPasswordController.text != passwordController.text) {
        confirmPasswordError = "Passwords do not match";
      } else {
        confirmPasswordError = null;
      }
    });

    return nameError == null &&
        emailError == null &&
        passwordError == null &&
        confirmPasswordError == null;
  }

  Future<void> _signUp() async {
    if (!_validateFields()) return;

    setState(() => isLoading = true);

    try {
      // Firebase handles duplicate email checks automatically [cite: 17]
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await FirebaseAuth.instance.currentUser?.updateDisplayName(
        nameController.text.trim(),
      );

      _showSuccess("Account created! Please Login.");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'email-already-in-use') {
          emailError = "This email is already registered";
        } else if (e.code == 'weak-password') {
          passwordError = "The password provided is too weak";
        } else {
          _showError(e.message ?? "An error occurred");
        }
      });
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // UI Helper for SnackBar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontFamily: "Montserrat")),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontFamily: "Montserrat")),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                displayTitle,
                style: const TextStyle(
                  fontSize: 34,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0A74DA),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Create your OmniSense account",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueGrey,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),

              _buildTextField(
                nameController,
                Icons.person_outline,
                "User Name",
                error: nameError,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                emailController,
                Icons.email_outlined,
                "Email Address",
                keyboardType: TextInputType.emailAddress,
                error: emailError,
              ),
              const SizedBox(height: 15),

              // Password Field with Eye Icon
              _buildTextField(
                passwordController,
                Icons.lock_outline,
                "Password",
                isObscure: !_isPasswordVisible,
                error: passwordError,
                suffix: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
              ),
              const SizedBox(height: 15),

              // Confirm Password Field
              _buildTextField(
                confirmPasswordController,
                Icons.lock_reset_outlined,
                "Confirm Password",
                isObscure: !_isConfirmPasswordVisible,
                error: confirmPasswordError,
                suffix: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    size: 20,
                  ),
                  onPressed: () => setState(
                    () =>
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
                  ),
                ),
              ),
              const SizedBox(height: 35),

              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _signUp,
                      child: const Text(
                        "CREATE ACCOUNT",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      color: Colors.black54,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                    child: const Text(
                      "Login",
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

  Widget _buildTextField(
    TextEditingController controller,
    IconData icon,
    String label, {
    bool isObscure = false,
    TextInputType? keyboardType,
    String? error,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontFamily: "Montserrat",
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 20),
        suffixIcon: suffix,
        labelText: label,
        errorText: error, // This automatically turns the border red [cite: 47]
        labelStyle: const TextStyle(
          fontFamily: "Montserrat",
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
