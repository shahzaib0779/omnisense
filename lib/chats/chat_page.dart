import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Needed for Timestamp
import 'package:intl/intl.dart'; // You will need to add 'intl' to pubspec.yaml
import 'chat_service.dart';

class ChatPage extends StatelessWidget {
  final String currentUserEmail;
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();

  ChatPage({super.key, required this.currentUserEmail});

  // Helper function to format the timestamp
  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "...";
    var date = timestamp.toDate();
    return DateFormat('hh:mm a').format(date); // Example: 10:06 PM
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      String message = _messageController.text;
      _messageController.clear();
      await _chatService.sendMessage(message, currentUserEmail);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Direct Chat",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "Montserrat",
          ),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _chatService.getMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index];
                    bool isMe = data['senderEmail'] == currentUserEmail;
                    String timeLabel = formatTimestamp(
                      data['timestamp'] as Timestamp?,
                    );

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(
                              top: 8,
                              left: 12,
                              right: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? Colors.blueAccent
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(12),
                                topRight: const Radius.circular(12),
                                bottomLeft: isMe
                                    ? const Radius.circular(12)
                                    : const Radius.circular(0),
                                bottomRight: isMe
                                    ? const Radius.circular(0)
                                    : const Radius.circular(12),
                              ),
                            ),
                            child: Text(
                              data['message'],
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black87,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          // TIMESTAMP LABEL
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 2,
                            ),
                            child: Text(
                              timeLabel,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                                fontFamily: "Montserrat",
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Message Input Area
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w500,
                    ),
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontFamily: "Montserrat",
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: IconButton(
                    onPressed: sendMessage,
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
