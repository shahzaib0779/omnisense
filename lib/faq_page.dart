import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "OmniSense Knowledge Base",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0A74DA),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCategoryHeader("CORE TECHNOLOGY"),
          _buildFaqItem(
            "What is OmniSense AI?",
            "OmniSense is a specialized AI agent designed for Computer Science and Technical Research. It uses advanced LLMs to provide real-time code analysis and tech support.",
          ),
          _buildFaqItem(
            "How does the AI process my data?",
            "OmniSense processes data through secure Firebase AI Logic gateways. Your prompts are analyzed in real-time to provide context-aware technical solutions.",
          ),
          const SizedBox(height: 20),
          _buildCategoryHeader("ACCOUNT & SECURITY"),
          _buildFaqItem(
            "Is my profile data private?",
            "Absolutely. We use Firebase Authentication to secure your account. Only you can access your technical reports and profile settings.",
          ),
          _buildFaqItem(
            "Can I use OmniSense offline?",
            "Most AI features require an active cloud connection to access our technical knowledge models, but basic interface navigation works offline.",
          ),
          const SizedBox(height: 30),
          const Center(
            child: Text(
              "Developed by Shahzaib • v1.0.2",
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Header for FAQ categories
  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: "Montserrat",
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0A74DA),
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  // Individual FAQ item with Expansion logic
  Widget _buildFaqItem(String question, String answer) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        iconColor: const Color(0xFF0A74DA),
        collapsedIconColor: Colors.grey,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedAlignment: Alignment.topLeft,
        children: [
          Text(
            answer,
            style: const TextStyle(
              fontFamily: "Montserrat",
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
