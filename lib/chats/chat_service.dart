import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // This is the unique ID for the two users you specified
  final String chatRoomId =
      "shahzaib.ahmad0779@gmail.com_shahzaib.blogging@gmail.com";

  // SEND MESSAGE
  Future<void> sendMessage(String message, String senderEmail) async {
    if (message.trim().isEmpty) return;

    final Timestamp timestamp = Timestamp.now();

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
          'senderEmail': senderEmail,
          'message': message,
          'timestamp': timestamp,
        });
  }

  // GET MESSAGES
  Stream<QuerySnapshot> getMessages() {
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
