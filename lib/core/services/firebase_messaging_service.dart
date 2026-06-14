import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseMessagingService {
  FirebaseMessagingService(this._dio);

  final Dio _dio;

  Future<void> initialize() async {
    final settings = await FirebaseMessaging.instance.requestPermission();

    debugPrint('FCM permission: ${settings.authorizationStatus}');

    final token = await FirebaseMessaging.instance.getToken();

    debugPrint('FCM TOKEN = $token');

    if (token != null) {
      await _registerDevice(token);
    }

    // ==========================
    // APP OUVERTE (Foreground)
    // ==========================
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("📩 Notification reçue");

      debugPrint("Titre : ${message.notification?.title}");

      debugPrint("Body : ${message.notification?.body}");

      debugPrint("Data : ${message.data}");
    });

    // ==========================
    // CLIC SUR NOTIFICATION
    // ==========================
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("📲 Notification ouverte");

      debugPrint("Data : ${message.data}");
    });
  }

  Future<void> _registerDevice(String token) async {
    try {
      await _dio.post('/notifications/register-device', data: {'token': token});

      debugPrint('✅ Device enregistré avec succès');
    } catch (e) {
      debugPrint('❌ Erreur enregistrement device : $e');
    }
  }
}
