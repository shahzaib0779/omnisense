import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ComplainPage extends StatefulWidget {
  const ComplainPage({super.key});

  @override
  State<ComplainPage> createState() => _ComplainPageState();
}

class _ComplainPageState extends State<ComplainPage> {
  final _controller = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitComplaint() async {
    if (_controller.text.isEmpty) return;
    setState(() => _isSubmitting = true);

    try {
      // Save data to Firestore 'complaints' collection
      await FirebaseFirestore.instance.collection('complaints').add({
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'userEmail': FirebaseAuth.instance.currentUser?.email,
        'message': _controller.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Complaint Submitted!")));
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Firestore Error: $e");
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Report an Issue",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0A74DA),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Describe your issue or bug below. OmniSense engineers will review it shortly.",
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              maxLines: 5,
              style: const TextStyle(fontFamily: 'Montserrat'),
              decoration: const InputDecoration(
                hintText: "Enter details here...",
                border: OutlineInputBorder(),
                hintStyle: TextStyle(fontFamily: 'Montserrat'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitComplaint,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Submit Report",
                        style: TextStyle(fontFamily: 'Montserrat'),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
