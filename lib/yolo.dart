// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';

class YoloIdentifierScreen extends StatefulWidget {
  const YoloIdentifierScreen({super.key});

  @override
  State<YoloIdentifierScreen> createState() => _YoloIdentifierScreenState();
}

class _YoloIdentifierScreenState extends State<YoloIdentifierScreen> {
  String _detectedObject = "Scanning...";
  bool _hasResult = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "OmniSense AI Vision",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0A74DA),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // 1. YOLOView handles its own model loading and camera logic
          YOLOView(
            modelPath: 'yolov8n_float16.tflite',
            task: YOLOTask.detect,
            onResult: (List<YOLOResult> results) {
              if (results.isNotEmpty) {
                // Get the name of the highest confidence object
                final topObject = results.first.className;

                // Only update if the object has changed to save battery
                if (topObject != _detectedObject) {
                  setState(() {
                    _detectedObject = topObject;
                    _hasResult = true;
                  });
                }
              }
            },
          ),

          // 2. Loading state: Shows until the camera starts and first result arrives
          if (!_hasResult)
            Container(
              color: Colors.black87,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.blue),
                    SizedBox(height: 15),
                    Text(
                      "Waking up AI Brain...",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

          // 3. Result Banner
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xFF0A74DA).withOpacity(0.9),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10),
                ],
              ),
              child: Text(
                "I see: $_detectedObject",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Montserrat",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
