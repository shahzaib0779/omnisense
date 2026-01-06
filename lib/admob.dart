import 'package:flutter/material.dart';

class Admob extends StatefulWidget {
  const Admob({super.key});

  @override
  State<Admob> createState() => _AdmobState();
}

class _AdmobState extends State<Admob> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Advertisements & Settings",
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
          "Ads/Settings",
          style: TextStyle(fontFamily: "Montserrat", fontSize: 18),
        ),
      ),
    );
  }
}
