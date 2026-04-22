import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'api_client.dart';

class FCMConfig {
  static Future<void> initialize() async {
    if (kIsWeb) {
      // Web FCM requires VAPID key and service worker setup
      // For prototype, we'll skip web FCM and use console logging
      return;
    }

    await Firebase.initializeApp();

    final messaging = FirebaseMessaging.instance;

    // Request permission
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    debugPrint('FCM permission status: ${settings.authorizationStatus}');

    // Get token and sync to backend
    final token = await messaging.getToken();
    if (token != null) {
      await _syncTokenToBackend(token);
    }

    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen(_syncTokenToBackend);

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('FCM foreground message: ${message.notification?.title}');
    });

    // Background/terminated handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _syncTokenToBackend(String token) async {
    try {
      await ApiClient.dio.post('/fcm/token', data: {'token': token});
    } catch (e) {
      debugPrint('Failed to sync FCM token: $e');
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('FCM background message: ${message.messageId}');
}
