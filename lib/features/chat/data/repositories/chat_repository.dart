import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/config/env.dart';
import '../../../../core/config/api_endpoints.dart';
import '../../../auth/application/auth_controller.dart';

import '../models/conversation_model.dart';
import '../models/message_model.dart';

class ChatRepository {
  final String? token;

  ChatRepository({required this.token});

  // =========================
  // CONVERSATIONS
  // =========================

  Future<List<ConversationModel>> getConversations() async {
    final res = await http.get(
      Uri.parse("${Env.baseUrl}${ApiEndpoints.conversations}"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    final data = jsonDecode(res.body);

    if (res.statusCode != 200) {
      throw Exception("Erreur conversations");
    }

    final List list = data["data"] ?? [];

    return list
        .map((e) => ConversationModel.fromJson(e))
        .toList();
  }

  // =========================
  // MESSAGES
  // =========================

  Future<List<MessageModel>> getMessages(int conversationId) async {
    final res = await http.get(
      Uri.parse(
        "${Env.baseUrl}${ApiEndpoints.messages(conversationId)}",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    final data = jsonDecode(res.body);

    if (res.statusCode != 200) {
      throw Exception("Erreur messages");
    }

    final List list = data["data"] ?? [];

    return list.map((e) => MessageModel.fromJson(e)).toList();
  }

  // =========================
  // ENVOI MESSAGE
  // =========================

  Future<void> sendMessage({
    required int conversationId,
    required String contenu,
  }) async {
    final res = await http.post(
      Uri.parse("${Env.baseUrl}${ApiEndpoints.sendMessage}"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "conversation_id": conversationId,
        "contenu": contenu,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Erreur envoi message");
    }
  }

  // =========================
  // CREATE CONVERSATION
  // =========================

  Future<int> createConversation(int user2Id) async {
  final res = await http.post(
    Uri.parse(
      "${Env.baseUrl}${ApiEndpoints.createConversation}",
    ),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "user2": user2Id,
    }),
  );

  print(
  "CREATE CONVERSATION STATUS => ${res.statusCode}",
);

print(
  "CREATE CONVERSATION BODY => ${res.body}",
);
  final data = jsonDecode(res.body);

  if (res.statusCode != 200) {
    throw Exception(
      data["message"] ??
      "Erreur conversation",
    );
  }

  return data["data"]["id_conversation"];
}
}