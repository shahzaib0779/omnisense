import 'package:flutter/material.dart';

class UserchatPage extends StatefulWidget {
  const UserchatPage({super.key});

  @override
  State<UserchatPage> createState() => _UserchatPageState();
}

class _UserchatPageState extends State<UserchatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Chat",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0A74DA),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: const Center(
        child: Text(
          "Real-Time Chat",
          style: TextStyle(fontFamily: "Montserrat", fontSize: 18),
        ),
      ),
    );
  }
}
