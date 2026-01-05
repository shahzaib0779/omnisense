import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Run 'flutter pub add fluttertoast'

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool isScanCompleted = false;

  void closeScreen() {
    setState(() {
      isScanCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Scan QR Code",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color(0xFF0A74DA),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Place the QR code in the area",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "Scanning will be started automatically",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: MobileScanner(
                onDetect: (capture) {
                  if (!isScanCompleted) {
                    final List<Barcode> barcodes = capture.barcodes;
                    final String code = barcodes.first.rawValue ?? "---";
                    isScanCompleted = true;

                    // Requirement: Display data using a Toast
                    Fluttertoast.showToast(
                      msg: "Scanned Data: $code",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: const Color(0xFF0A74DA),
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );

                    // Allow re-scanning after a short delay
                    Future.delayed(
                      const Duration(seconds: 3),
                      () => closeScreen(),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Developed by OmniSense AI",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: Colors.black38,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
