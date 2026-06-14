import 'dart:convert';

import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  LocalNotificationService._();

  static final instance = LocalNotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(
      settings,

      onDidReceiveNotificationResponse: (NotificationResponse response) {
        try {
          debugPrint("🔔 Notification locale cliquée");

          debugPrint("PAYLOAD => ${response.payload}");

          if (response.payload == null) {
            return;
          }

          final data = jsonDecode(response.payload!);

          debugPrint("DATA => $data");

          final conversationId = int.parse(data["conversation_id"]);

          final senderId = int.parse(data["sender_id"]);

          final senderName = data["sender_name"] ?? "Discussion";

          debugPrint("🚀 NAVIGATION CHAT => $conversationId");

          rootNavigatorKey.currentContext?.push(
            "/chat/$conversationId",
            extra: {"fullName": senderName, "otherUserId": senderId},
          );
        } catch (e, s) {
          debugPrint("❌ NOTIFICATION ERROR => $e");

          debugPrint(s.toString());
        }
      },
    );

    debugPrint("🔔 Local notifications initialisées");
  }

  Future<void> show({
    required String title,
    required String body,
    required Map<String, dynamic> payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'chat_channel',
      'Chat Notifications',
      channelDescription: 'Notifications des messages',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    debugPrint("🔔 Affichage notification locale");

    debugPrint("TITLE => $title");

    debugPrint("BODY => $body");

    await _notifications.show(
      0, // ID fixe compatible Android
      title,
      body,
      details,
      payload: jsonEncode(payload),
    );
  }
}
