import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:omnisense/QRScanner.dart';
import 'package:omnisense/admob.dart';
import 'package:omnisense/chatbot_page.dart';
import 'package:omnisense/chats/chat_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;
  final List<Widget> _screens = [
    const ChatbotPage(),
    const QRScannerScreen(),
    ChatPage(
      currentUserEmail:
          FirebaseAuth.instance.currentUser?.email ?? "default@email.com",
    ),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
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
          Icon(Icons.settings_outlined, size: 30, color: Colors.white), // Ads
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
