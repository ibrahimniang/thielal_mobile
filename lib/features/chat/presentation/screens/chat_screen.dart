import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/config/env.dart';
import '../../../auth/application/auth_controller.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final int conversationId;
  final String fullName;
  final int? otherUserId;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.fullName,
    this.otherUserId,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController messageController =
      TextEditingController();

  final ScrollController scrollController =
      ScrollController();

  List messages = [];
  bool loading = true;
  bool markedAsRead = false;

  late IO.Socket socket;

  Map<String, dynamic>? otherUserData;

  @override
  void initState() {
    super.initState();

    loadMessages();
    loadOtherUserInfo();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      markAsRead();
    });

    socket = IO.io(
      Env.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      debugPrint("Socket chat connecté");

      socket.emit(
        "joinConversation",
        widget.conversationId,
      );
    });

    socket.on("newMessage", (data) {
      if (!mounted) return;

      debugPrint("Nouveau message reçu");

      loadMessages();

      // ✅ important pour mettre message en lu
      markedAsRead = false;
      markAsRead();
    });
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  // =========================
  // LOAD OTHER USER INFO
  // =========================
  Future<void> loadOtherUserInfo() async {
    print("OTHER USER ID = ${widget.otherUserId}");

    if (widget.otherUserId == null) {
      print("ERREUR -> otherUserId null");
      return;
    }

    try {
      final token =
          ref.read(authControllerProvider).accessToken;

      final res = await http.get(
        Uri.parse(
          "${Env.baseUrl}/users/public/${widget.otherUserId}",
        ),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      print("USER API STATUS = ${res.statusCode}");
      print("USER API BODY = ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        if (!mounted) return;

        setState(() {
          otherUserData = data["data"];
        });

        print(
          "PHONE FOUND = ${otherUserData?["telephone"]}",
        );
      } else {
        print("Erreur récupération profil public");
      }
    } catch (e) {
      debugPrint("Erreur user info: $e");
    }
  }

  // =========================
  // CALL USER
  // =========================
  Future<void> callUser() async {
    final phone = otherUserData?["telephone"];

    print("PHONE VALUE = $phone");

    if (phone == null ||
        phone.toString().trim().isEmpty) {
      debugPrint("Téléphone indisponible");
      debugPrint("USER DATA = $otherUserData");
      return;
    }

    final uri = Uri.parse("tel:$phone");

    try {
      if (kIsWeb) {
        debugPrint(
          "Web détecté → tel peut ne pas fonctionner sur desktop",
        );
      }

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        debugPrint(
          "Impossible d'ouvrir téléphone",
        );
      }
    } catch (e) {
      debugPrint("Erreur appel: $e");
    }
  }

  // =========================
  // OPEN PROFILE
  // =========================
  Future<void> openProfile() async {
    final userId = widget.otherUserId;

    if (userId == null) return;

    Navigator.of(context).pop();

    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    if (!mounted) return;

    context.push(
      '${RouteNames.publicProfile}/$userId',
    );
  }

  // =========================
  // USER MODAL
  // =========================
  void showUserInfoModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) {
        final phone =
            otherUserData?["telephone"] ??
                "Non disponible";

        final ville =
            otherUserData?["ville"] ??
                "Non renseignée";

        final groupe =
            otherUserData?["groupe_sanguin"] ??
                "--";

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundColor: Colors.red,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 35,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                widget.fullName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              ListTile(
                leading: const Icon(Icons.phone),
                title: Text(phone),
              ),

              ListTile(
                leading:
                    const Icon(Icons.location_on),
                title: Text(ville),
              ),

              ListTile(
                leading:
                    const Icon(Icons.bloodtype),
                title: Text("Groupe : $groupe"),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.green,
                    ),
                    onPressed: callUser,
                    icon:
                        const Icon(Icons.call),
                    label:
                        const Text("Appeler"),
                  ),

                  ElevatedButton.icon(
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.red,
                    ),
                    onPressed: openProfile,
                    icon:
                        const Icon(Icons.person),
                    label:
                        const Text(
                          "Voir profil",
                        ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================
  // DATE
  // =========================
  String formatDate(String? dateString) {
    if (dateString == null) return "";

    try {
      final date =
          DateTime.parse(dateString).toLocal();

      return DateFormat(
        "d MMM",
        "fr_FR",
      ).format(date);
    } catch (_) {
      return "";
    }
  }

  String formatTime(String? dateString) {
    if (dateString == null) return "";

    try {
      final date =
          DateTime.parse(dateString).toLocal();

      return DateFormat("HH:mm").format(date);
    } catch (_) {
      return "";
    }
  }

  // =========================
  // SCROLL
  // =========================
  void scrollToBottom() {
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController
                .position.maxScrollExtent,
            duration: const Duration(
              milliseconds: 250,
            ),
            curve: Curves.easeOut,
          );
        }
      },
    );
  }

  // =========================
  // MARK AS READ
  // =========================
  Future<void> markAsRead() async {
    if (markedAsRead) return;

    try {
      final token =
          ref.read(authControllerProvider)
              .accessToken;

      await http.put(
        Uri.parse(
          "${Env.baseUrl}/chat/read/${widget.conversationId}",
        ),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      markedAsRead = true;
    } catch (e) {
      debugPrint(
        "Erreur markAsRead: $e",
      );
    }
  }

  // =========================
  // LOAD MESSAGES
  // =========================
  Future<void> loadMessages() async {
    try {
      final token =
          ref.read(authControllerProvider)
              .accessToken;

      final res = await http.get(
        Uri.parse(
          "${Env.baseUrl}/chat/messages/${widget.conversationId}",
        ),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(res.body);

      if (!mounted) return;

      setState(() {
        messages = data["data"] ?? [];
        loading = false;
      });

      scrollToBottom();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  // =========================
  // SEND MESSAGE
  // =========================
  Future<void> sendMessage() async {
    final text =
        messageController.text.trim();

    if (text.isEmpty) return;

    try {
      final token =
          ref.read(authControllerProvider)
              .accessToken;

      final res = await http.post(
        Uri.parse(
          "${Env.baseUrl}/chat/message",
        ),
        headers: {
          "Content-Type":
              "application/json",
          "Authorization":
              "Bearer $token",
        },
        body: jsonEncode({
          "conversation_id":
              widget.conversationId,
          "contenu": text,
        }),
      );

      if (res.statusCode == 200) {
        messageController.clear();
        await loadMessages();
      }
    } catch (e) {
      debugPrint(
        "Erreur envoi message: $e",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser =
        ref.read(authControllerProvider)
            .currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Row(
          children: [
            GestureDetector(
              onTap: showUserInfoModal,
              child: const CircleAvatar(
                backgroundColor:
                    Colors.white,
                child: Icon(
                  Icons.person,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.fullName,
                overflow:
                    TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: callUser,
            icon: const Icon(
              Icons.call,
              color: Colors.white,
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: loading
                ? const Center(
                    child:
                        CircularProgressIndicator(),
                  )
                : messages.isEmpty
                    ? const Center(
                        child: Text(
                          "Aucun message",
                        ),
                      )
                    : ListView.builder(
                        controller:
                            scrollController,
                        padding:
                            const EdgeInsets
                                .all(10),
                        itemCount:
                            messages.length,
                        itemBuilder:
                            (context, index) {
                          final m =
                              messages[index];

                          final isMe =
                              m["expediteur_id"] ==
                                  currentUser
                                      ?.idUtilisateur;

                          // ✅ tick lu/envoyé
                          final isRead =
                              m["lu"] == true;

                          return Align(
                            alignment: isMe
                                ? Alignment
                                    .centerRight
                                : Alignment
                                    .centerLeft,
                            child: Container(
                              margin:
                                  const EdgeInsets
                                      .symmetric(
                                vertical: 5,
                              ),
                              padding:
                                  const EdgeInsets
                                      .all(12),
                              constraints:
                                  const BoxConstraints(
                                maxWidth: 280,
                              ),
                              decoration:
                                  BoxDecoration(
                                color: isMe
                                    ? Colors.red
                                    : Colors.grey
                                        .shade300,
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  15,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(
                                    m["contenu"] ??
                                        "",
                                    style:
                                        TextStyle(
                                      color: isMe
                                          ? Colors
                                              .white
                                          : Colors
                                              .black,
                                    ),
                                  ),

                                  const SizedBox(
                                      height:
                                          5),

                                  Row(
                                    mainAxisSize:
                                        MainAxisSize
                                            .min,
                                    children: [
                                      Text(
                                        "${formatDate(m["date_envoi"])} ${formatTime(m["date_envoi"])}",
                                        style:
                                            TextStyle(
                                          fontSize:
                                              11,
                                          color: isMe
                                              ? Colors
                                                  .white70
                                              : Colors
                                                  .black54,
                                        ),
                                      ),

                                      const SizedBox(
                                          width:
                                              6),

                                      if (isMe)
                                        Icon(
                                          isRead
                                              ? Icons
                                                  .done_all
                                              : Icons
                                                  .done,
                                          size: 16,
                                          color: isRead
                                              ? Colors
                                                  .blue
                                              : Colors
                                                  .white70,
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

          Container(
            padding:
                const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:
                        messageController,
                    decoration:
                        const InputDecoration(
                      hintText:
                          "Message...",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.red,
                  ),
                  onPressed:
                      sendMessage,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}