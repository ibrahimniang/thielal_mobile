import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'local_notification_service.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';

class FirebaseMessagingService {
  FirebaseMessagingService(this._dio);

  final Dio _dio;

  Future<void> initialize() async {
    debugPrint("================ FCM INIT ================");

    // ==========================
    // PERMISSIONS
    // ==========================
    final settings = await FirebaseMessaging.instance.requestPermission();

    debugPrint("FCM permission => ${settings.authorizationStatus}");

    // ==========================
    // TOKEN
    // ==========================
    final token = await FirebaseMessaging.instance.getToken();

    debugPrint("FCM TOKEN => $token");

    if (token != null) {
      await _registerDevice(token);
    }

    // ==========================
    // TOKEN REFRESH
    // ==========================
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      debugPrint("🔄 TOKEN REFRESH => $newToken");

      await _registerDevice(newToken);
    });

    // ==========================
    // APP OUVERTE VIA NOTIFICATION
    // (APP COMPLETEMENT FERMEE)
    // ==========================
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      debugPrint("🚀 App ouverte depuis notification (terminated)");

      debugPrint("TITLE => ${initialMessage.notification?.title}");

      debugPrint("BODY => ${initialMessage.notification?.body}");

      debugPrint("DATA => ${initialMessage.data}");
    }

    // ==========================
    // APP OUVERTE (FOREGROUND)
    // ==========================
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("📩 Notification reçue");

      debugPrint("TITLE => ${message.notification?.title}");

      debugPrint("BODY => ${message.notification?.body}");

      debugPrint("DATA => ${message.data}");

      await LocalNotificationService.instance.show(
        title: message.notification?.title ?? "LifeLink",

        body: message.notification?.body ?? "",

        payload: message.data,
      );
    });

    // ==========================
    // APP EN ARRIERE-PLAN
    // + CLIC NOTIFICATION
    // ==========================
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("📲 Notification ouverte");

      debugPrint("TITLE => ${message.notification?.title}");

      debugPrint("BODY => ${message.notification?.body}");

      debugPrint("DATA => ${message.data}");

      final type = message.data["type"];

      if (type != "chat") {
        return;
      }

      final conversationId = int.parse(message.data["conversation_id"]!);

      final senderId = int.parse(message.data["sender_id"]!);

      final senderName = message.data["sender_name"] ?? "Discussion";

      rootNavigatorKey.currentContext?.push(
        "/chat/$conversationId",
        extra: {"fullName": senderName, "otherUserId": senderId},
      );
    });

    debugPrint("================ FCM READY ================");
  }

  Future<void> _registerDevice(String token) async {
    try {
      debugPrint("📡 Enregistrement device...");

      await _dio.post('/notifications/register-device', data: {'token': token});

      debugPrint('✅ Device enregistré avec succès');
    } catch (e) {
      debugPrint('❌ Erreur enregistrement device : $e');
    }
  }
}
