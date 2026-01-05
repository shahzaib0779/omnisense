import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:omnisense/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;
  final List<Widget> _screens = [
    const Center(
      child: Text(
        "AI Chatbot (Gemini)",
        style: TextStyle(fontFamily: "Montserrat", fontSize: 18),
      ),
    ),
    const Center(
      child: Text(
        "QR Scanner",
        style: TextStyle(fontFamily: "Montserrat", fontSize: 18),
      ),
    ),
    const Center(
      child: Text(
        "Real-Time Chat",
        style: TextStyle(fontFamily: "Montserrat", fontSize: 18),
      ),
    ),
    const Center(
      child: Text(
        "Ads/Settings",
        style: TextStyle(fontFamily: "Montserrat", fontSize: 18),
      ),
    ),
  ];

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "OmniSense",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF0A74DA),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout, // Secure session handling
          ),
        ],
      ),
      body: _screens[_pageIndex],

      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.auto_awesome, size: 30, color: Colors.white),
          Icon(Icons.qr_code_scanner, size: 30, color: Colors.white), 
          Icon(
            Icons.chat_bubble_outline,
            size: 30,
            color: Colors.white,
          ), // Chat
          Icon(Icons.ads_click, size: 30, color: Colors.white), // Ads
        ],
        color: const Color(0xFF0A74DA), // Bar color
        buttonBackgroundColor: const Color(0xFF0A74DA), // Floating button color
        backgroundColor: Colors.transparent, // Background behind the bar
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
