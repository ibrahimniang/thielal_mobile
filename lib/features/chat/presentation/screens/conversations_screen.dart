import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../core/config/env.dart';
import '../../../../core/config/api_endpoints.dart';
import '../../../auth/application/auth_controller.dart';

class ConversationsScreen extends ConsumerStatefulWidget {
  const ConversationsScreen({super.key});

  @override
  ConsumerState<ConversationsScreen> createState() =>
      _ConversationsScreenState();
}

class _ConversationsScreenState
    extends ConsumerState<ConversationsScreen> {

  List conversations = [];
  bool loading = true;

  late IO.Socket socket;

  int? currentUserId;

  @override
  void initState() {
    super.initState();

    final user =
        ref.read(authControllerProvider).currentUser;

    currentUserId = user?.idUtilisateur;

    loadConversations();

    // SOCKET
    socket = IO.io(
      Env.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      debugPrint("Socket conversations connecté");

      socket.emit("joinUser", currentUserId);
    });

    socket.on("newMessage", (data) {
      if (!mounted) return;
      loadConversations();
    });

    socket.on("messageRead", (_) {
      if (!mounted) return;
      loadConversations();
    });
  }

  @override
  void dispose() {
    socket.off("newMessage");
    socket.off("messageRead");
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

  Future<void> loadConversations() async {
    try {
      final token =
          ref.read(authControllerProvider).accessToken;

      final res = await http.get(
        Uri.parse(
          "${Env.baseUrl}${ApiEndpoints.conversations}",
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        if (!mounted) return;

        setState(() {
          conversations = data["data"] ?? [];
          loading = false;
        });
      } else {
        if (!mounted) return;

        setState(() {
          conversations = [];
          loading = false;
        });
      }
    } catch (e) {
      debugPrint("Erreur conversations: $e");

      if (!mounted) return;

      setState(() {
        conversations = [];
        loading = false;
      });
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null) return "";

    try {
      final date = DateTime.parse(dateString);

      return DateFormat(
        "d MMM à HH:mm",
        "fr_FR",
      ).format(date);
    } catch (_) {
      return "";
    }
  }

  String getFullName(Map? user) {
    if (user == null) return "Utilisateur";

    final prenom = user["prenom"] ?? "";
    final nom = user["nom"] ?? "";

    return "$prenom $nom".trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes discussions"),
        backgroundColor: Colors.red,
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : conversations.isEmpty
              ? const Center(
                  child: Text("Aucune conversation"),
                )
              : RefreshIndicator(
                  onRefresh: loadConversations,
                  child: ListView.builder(
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      final c = conversations[index];

                      final user1 = c["utilisateur1"];
                      final user2 = c["utilisateur2"];
                      final conversationId =
                          c["id_conversation"];

                      final otherUser =
                          (user1 != null &&
                                  user1["id_utilisateur"] ==
                                      currentUserId)
                              ? user2
                              : user1;

                      final otherUserId =
                          otherUser?["id_utilisateur"];

                      final fullName =
                          getFullName(otherUser);

                      final lastMessage =
                          c["dernier_message"] ??
                              "Aucun message";

                      final unreadCount =
                          int.tryParse(
                                c["unreadCount"]
                                    .toString(),
                              ) ??
                              0;

                      final hasUnread =
                          unreadCount > 0;

                      final formattedDate =
                          formatDate(
                        c["date_dernier_message"]
                            ?.toString(),
                      );

                      return Card(
                        margin:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    Colors.red,
                                child: Text(
                                  fullName.isNotEmpty
                                      ? fullName[0]
                                          .toUpperCase()
                                      : "?",
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,
                                  ),
                                ),
                              ),

                              if (hasUnread)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration:
                                        const BoxDecoration(
                                      color:
                                          Colors.red,
                                      shape:
                                          BoxShape
                                              .circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          title: Text(
                            fullName,
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          subtitle: Text(
                            lastMessage,
                            maxLines: 1,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                          ),

                          trailing: Text(
                            formattedDate,
                            style:
                                const TextStyle(
                              fontSize: 12,
                              color:
                                  Colors.grey,
                            ),
                          ),

                          onTap: () {
                            context.push(
                              '/chat/$conversationId',
                              extra: {
                                "fullName": fullName,
                                "otherUserId": otherUser?["id_utilisateur"],
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}