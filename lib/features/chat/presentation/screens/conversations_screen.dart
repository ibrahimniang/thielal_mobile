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

  bool isSearching = false;

  List conversations = [];

  bool loading = true;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  late IO.Socket socket;

  int? currentUserId;

  @override
  void initState() {
    super.initState();

    final user =
        ref.read(authControllerProvider)
            .currentUser;

    currentUserId = user?.idUtilisateur;

    loadConversations();

    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });

    // =========================
    // SOCKET
    // =========================
    socket = IO.io(
      Env.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .setReconnectionAttempts(999999)
          .setReconnectionDelay(2000)
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    // =========================
    // CONNECT
    // =========================
    socket.onConnect((_) {

      debugPrint(
        "✅ Socket conversations connecté"
      );

      socket.emit(
        "joinUser",
        currentUserId,
      );
    });

    // =========================
    // RECONNECT
    // =========================
    socket.onReconnect((_) {

      debugPrint(
        "🔄 socket reconnect"
      );

      socket.emit(
        "joinUser",
        currentUserId,
      );

      loadConversations();
    });

    // =========================
    // REALTIME CONVERSATIONS
    // =========================
    socket.on(
      "conversationUpdated",
      (data) {

        if (!mounted) return;

        debugPrint(
          "🔥 conversationUpdated reçu"
        );

        loadConversations();
      },
    );

    // =========================
    // MESSAGE READ
    // =========================
    socket.on(
      "messageRead",
      (_) {

        if (!mounted) return;

        loadConversations();
      },
    );

    // =========================
    // SOCKET ERROR
    // =========================
    socket.onConnectError((e) {

      debugPrint(
        "❌ socket connect error: $e"
      );
    });

    socket.onDisconnect((_) {

      debugPrint(
        "❌ socket disconnected"
      );
    });
  }

  @override
  void dispose() {

    socket.off("conversationUpdated");

    socket.off("messageRead");

    socket.disconnect();

    socket.dispose();
    searchController.dispose();

    super.dispose();
  }

  // =========================
  // LOAD CONVERSATIONS
  // =========================
  Future<void> loadConversations() async {

    try {

      final token =
          ref.read(authControllerProvider)
              .accessToken;

      final res = await http.get(
        Uri.parse(
          "${Env.baseUrl}${ApiEndpoints.conversations}",
        ),
        headers: {
          "Authorization":
              "Bearer $token",

          "Content-Type":
              "application/json",
        },
      );

      debugPrint(
        "📨 conversations status => ${res.statusCode}"
      );

      if (res.statusCode == 200) {

        final data =
            jsonDecode(res.body);

        if (!mounted) return;

        setState(() {

          conversations =
              data["data"] ?? [];

          loading = false;
        });

      } else {

        if (!mounted) return;

        setState(() {

          loading = false;
        });
      }

    } catch (e) {

      debugPrint(
        "❌ Erreur conversations: $e",
      );

      if (!mounted) return;

      setState(() {

        loading = false;
      });
    }
  }

  // =========================
  // DATE
  // =========================
  String formatDate(
    String? dateString,
  ) {

    if (dateString == null) {
      return "";
    }

    try {

      final date =
          DateTime.parse(dateString)
              .toLocal();

      return DateFormat(
        "d MMM à HH:mm",
        "fr_FR",
      ).format(date);

    } catch (_) {

      return "";
    }
  }

  // =========================
  // FULL NAME
  // =========================
  String getFullName(Map? user) {

    if (user == null) {
      return "Utilisateur";
    }

    final prenom =
        user["prenom"] ?? "";

    final nom =
        user["nom"] ?? "";

    return "$prenom $nom".trim();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7FB),

      body: SafeArea(
        child: Column(
          children: [

            /// =========================
            /// HEADER
            /// =========================
            Container(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                28,
              ),

              decoration:
                  const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFE53946),
                    Color(0xFFC1121F),
                  ],
                ),

                borderRadius:
                    BorderRadius.only(
                  bottomLeft:
                      Radius.circular(30),

                  bottomRight:
                      Radius.circular(30),
                ),
              ),

              child: Row(
                children: [

                  GestureDetector(
                    onTap: () {

                      context.pop();
                    },

                    child: Container(
                      padding:
                          const EdgeInsets.all(10),

                      decoration:
                          BoxDecoration(
                        color: Colors.white24,

                        shape:
                            BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(
                          "Messagerie",

                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          "Mes discussions",

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight:
                                FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSearching = !isSearching;

                        if (!isSearching) {
                          searchController.clear();
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSearching ? Icons.close : Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            if (isSearching)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Rechercher un utilisateur...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

           

            /// =========================
            /// LOADING
            /// =========================
            if (loading)

              const Expanded(
                child: Center(
                  child:
                      CircularProgressIndicator(
                    color:
                        Color(0xFFE53946),
                  ),
                ),
              )

            /// =========================
            /// EMPTY
            /// =========================
            else if (conversations.isEmpty)

              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      Container(
                        height: 100,
                        width: 100,

                        decoration:
                            BoxDecoration(
                          color:
                              Colors.red.withOpacity(.08),

                          shape:
                              BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.forum_outlined,
                          size: 50,
                          color:
                              Color(0xFFE53946),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Aucune conversation",

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Vos discussions apparaîtront ici",

                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              )

            /// =========================
            /// LISTE
            /// =========================
            else

              Expanded(
                child: RefreshIndicator(
                  color:
                      const Color(0xFFE53946),

                  onRefresh:
                      loadConversations,

                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),

                    itemCount:
                        conversations.length,

                    itemBuilder:
                        (context, index) {

                      final c =
                          conversations[index];

                      final user1 =
                          c["utilisateur1"];

                      final user2 =
                          c["utilisateur2"];

                      final conversationId =
                          c["id_conversation"];

                      final otherUser =
                          (user1 != null &&
                                  user1[
                                          "id_utilisateur"] ==
                                      currentUserId)
                              ? user2
                              : user1;

                      final otherUserId =
                          otherUser?[
                              "id_utilisateur"];

                      final fullName =
                          getFullName(
                        otherUser,
                      );
                      final telephone =
                        (otherUser?["telephone"] ?? "")
                            .toString()
                            .toLowerCase();
                            
                      final search = searchQuery.trim().toLowerCase();

                      if (search.isNotEmpty &&
                          !fullName.toLowerCase().contains(search) &&
                          !telephone.contains(search)) {
                        return const SizedBox.shrink();
                      }

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
                      

                      return GestureDetector(

                        onTap: () {

                          context.push(
                            '/chat/$conversationId',

                            extra: {
                              "fullName":
                                  fullName,

                              "otherUserId":
                                  otherUserId,
                            },
                          );
                        },

                        child: Container(
                          margin:
                              const EdgeInsets.only(
                            bottom: 16,
                          ),

                          padding:
                              const EdgeInsets.all(
                            18,
                          ),

                          decoration:
                              BoxDecoration(
                            color: Colors.white,

                            borderRadius:
                                BorderRadius.circular(
                              24,
                            ),

                            boxShadow: [

                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(
                                  0.05,
                                ),

                                blurRadius: 20,

                                offset:
                                    const Offset(
                                  0,
                                  8,
                                ),
                              ),
                            ],
                          ),

                          child: Row(
                            children: [

                              /// AVATAR
                              Stack(
                                children: [

                                  CircleAvatar(
                                    radius: 28,

                                    backgroundColor:
                                        const Color(
                                      0xFFE53946,
                                    ),

                                    child: Text(
                                      fullName
                                              .isNotEmpty
                                          ? fullName[0]
                                              .toUpperCase()
                                          : "?",

                                      style:
                                          const TextStyle(
                                        color:
                                            Colors.white,

                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  if (hasUnread)

                                    Positioned(
                                      right: 0,
                                      top: 0,

                                      child:
                                          Container(
                                        padding:
                                            const EdgeInsets
                                                .all(6),

                                        decoration:
                                            const BoxDecoration(
                                          color:
                                              Colors.red,

                                          shape:
                                              BoxShape.circle,
                                        ),

                                        child: Text(
                                          unreadCount
                                              .toString(),

                                          style:
                                              const TextStyle(
                                            color:
                                                Colors.white,

                                            fontSize: 10,

                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(width: 16),

                              /// MESSAGE
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                  children: [

                                    Text(
                                      fullName,

                                      style:
                                          const TextStyle(
                                        fontWeight:
                                            FontWeight.bold,

                                        fontSize: 16,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 6,
                                    ),

                                    Text(
                                      lastMessage,

                                      maxLines: 1,

                                      overflow:
                                          TextOverflow.ellipsis,

                                      style: TextStyle(
                                        color:
                                            Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 10),

                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.end,

                                children: [

                                  Text(
                                    formattedDate,

                                    style:
                                        const TextStyle(
                                      fontSize: 11,

                                      color: Colors.grey,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  const Icon(
                                    Icons.chevron_right,

                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}