import 'package:flutter/material.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isTyping = false;

  // 1. Initialize with System Instructions for CS & Tech Focus
  late final _model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-flash-lite',
    systemInstruction: Content.system(
      "Your name is OmniSense. You are a world-class expert in Computer Science, "
      "Artificial Intelligence, and Technology. Provide insightful, technically "
      "accurate, and helpful responses specifically about CS topics.",
    ),
  );
  late final _chat = _model.startChat();

  // 2. Word-by-Word (Streaming) Logic
  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final userMessage = _controller.text;
    setState(() {
      _messages.add({"role": "user", "text": userMessage});
      _messages.add({
        "role": "ai",
        "text": "",
      }); // Placeholder for streaming text
      _isTyping = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final stream = _chat.sendMessageStream(Content.text(userMessage));
      String fullResponse = "";

      await for (final chunk in stream) {
        if (chunk.text != null) {
          fullResponse += chunk.text!;
          setState(() {
            _messages[_messages.length - 1]["text"] = fullResponse;
            _isTyping = false;
          });
          _scrollToBottom();
        }
      }
    } catch (e) {
      debugPrint("AI ERROR: $e");
      setState(() {
        _messages[_messages.length - 1]["text"] =
            "Connection issue. Check your network!";
        _isTyping = false;
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "OmniSense AI",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0A74DA),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["role"] == "user";

                // 3. Slide Animation Wrapper
                return TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 400),
                  tween: Tween<Offset>(
                    begin: const Offset(0.5, 0),
                    end: Offset.zero,
                  ),
                  builder: (context, Offset offset, child) {
                    return FractionalTranslation(
                      translation: offset,
                      child: Opacity(
                        opacity: 1.0,
                        child: _buildMessageBubble(msg["text"]!, isUser),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (_isTyping) _buildTypingIndicator(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF0A74DA) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            // ignore: deprecated_member_use
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
          ],
        ),
        // Use MarkdownBody to render AI bold text and code snippets
        child: MarkdownBody(
          data: text,
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(
              fontFamily: "Montserrat",
              color: isUser ? Colors.white : Colors.black87,
              fontStyle: text == "OmniSense is compiling your resource..."
                  ? FontStyle.italic
                  : FontStyle.normal,
            ),
            // Customizing bold text color for AI responses
            strong: TextStyle(
              fontWeight: FontWeight.bold,
              color: isUser ? Colors.white : Colors.black,
            ),
            // Styling code snippets for CS projects
            code: const TextStyle(
              backgroundColor: Color(0xFFE2E8F0),
              fontFamily: "monospace",
              fontSize: 13,
            ),
            codeblockDecoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 20, bottom: 10),
      child: const Text(
        "OmniSense is compiling response...",
        style: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 12,
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(fontFamily: "Montserrat"),
                decoration: InputDecoration(
                  hintText: "Ask about AI, Code, or Tech...",
                  hintStyle: TextStyle(
                    fontFamily: "Montserrat",
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF1F5F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: const Color(0xFF0A74DA),
              child: IconButton(
                icon: const Icon(
                  Icons.bolt,
                  color: Colors.white,
                ), // Novel 'Bolt' icon for speed
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
