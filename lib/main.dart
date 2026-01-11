import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:omnisense/auth_wrapper.dart';
import 'package:omnisense/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 1. Register background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await MobileAds.instance.initialize();
  runApp(const MyApp());
}

// Converted to StatefulWidget to handle lifecycle listeners
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _setupPushNotifications();
  }

  // 2. Setup all notification logic in one place
  Future<void> _setupPushNotifications() async {
    // ONLY run this on Android or iOS
    if (!kIsWeb) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      // Request permission (Mobile only)
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? token = await messaging.getToken();
        print("FCM Mobile Token: $token");

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          if (message.notification != null) {
            _showForegroundAlert(
              message.notification!.title,
              message.notification!.body,
            );
          }
        });

        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          print('Notification opened app!');
        });
      }
    } else {
      print("Push Notifications are disabled on Web.");
    }
  }

  // Helper to show a simple dialog for foreground messages
  void _showForegroundAlert(String? title, String? body) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? "Notification"),
        content: Text(body ?? ""),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0A74DA);
    const Color secondaryCyan = Color(0xFF00D4FF);
    const Color backgroundGray = Color(0xFFF8FAFC);
    const Color errorRed = Color(0xFFD32F2F);

    return MaterialApp(
      title: 'OmniSense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          primary: primaryBlue,
          secondary: secondaryCyan,
          surface: Colors.white,
          // ignore: deprecated_member_use
          background: backgroundGray,
          error: errorRed,
          onPrimary: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: primaryBlue, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 2,
          ),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}
