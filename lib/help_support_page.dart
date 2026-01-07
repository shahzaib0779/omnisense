import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Help & Support",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0A74DA),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Center(
            child: Icon(
              Icons.headset_mic_outlined,
              size: 80,
              color: Color(0xFF0A74DA),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "How can we help you?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Our technical team is available 24/7 for OmniSense subscribers.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.blueGrey,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 40),
          _supportTile(
            Icons.email_outlined,
            "Email Support",
            "support@omnisense.ai",
          ),
          _supportTile(
            Icons.phone_outlined,
            "Technical Hotline",
            "+92 779-OMNI-AI",
          ),
          _supportTile(
            Icons.chat_bubble_outline,
            "Live Developer Chat",
            "Available in Pro Tier",
          ),
        ],
      ),
    );
  }

  Widget _supportTile(IconData icon, String title, String data) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0A74DA)),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        subtitle: Text(data, style: const TextStyle(fontFamily: 'Montserrat')),
      ),
    );
  }
}
