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
  ConsumerState<ChatScreen> createState() =>
      _ChatScreenState();
}

class _ChatScreenState
    extends ConsumerState<ChatScreen> {

  final TextEditingController messageController =
      TextEditingController();

  final ScrollController scrollController =
      ScrollController();

  List messages = [];

  bool loading = true;
  bool sending = false;
  bool markedAsRead = false;

  late IO.Socket socket;

  Map<String, dynamic>? otherUserData;

  bool isUserOnline = true;

  @override
  void initState() {
    super.initState();

    loadMessages();
    loadOtherUserInfo();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      markAsRead();
    });

    // =========================
    // SOCKET
    // =========================

    socket = IO.io(
      Env.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .enableReconnection()
          .setReconnectionAttempts(999999)
          .setReconnectionDelay(1000)
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {

      debugPrint(
        "✅ Chat socket connecté",
      );

      // rejoindre conversation
      socket.emit(
        "joinConversation",
        widget.conversationId,
      );

      // rejoindre user room
      final currentUser =
          ref.read(authControllerProvider)
              .currentUser;

      if (currentUser != null) {
        socket.emit(
          "joinUser",
          currentUser.idUtilisateur,
        );
      }
    });

    // =========================
    // NEW MESSAGE
    // =========================

    socket.on("newMessage", (data) async {

      if (!mounted) return;

      debugPrint(
        "📩 Nouveau message realtime",
      );

      // recharge direct
      await loadMessages();

      // reset read
      markedAsRead = false;

      // mark read
      await markAsRead();
    });

    // =========================
    // RECONNECT
    // =========================

    socket.onReconnect((_) {

      debugPrint(
        "♻️ Socket reconnecté",
      );

      socket.emit(
        "joinConversation",
        widget.conversationId,
      );
    });

    // =========================
    // DISCONNECT
    // =========================

    socket.onDisconnect((_) {

      debugPrint(
        "❌ Socket disconnected",
      );
    });
  }

  @override
  void dispose() {

    socket.off("newMessage");

    socket.disconnect();
    socket.dispose();

    messageController.dispose();
    scrollController.dispose();

    super.dispose();
  }

  // ======================================================
  // LOAD USER INFO
  // ======================================================

  Future<void> loadOtherUserInfo() async {

    if (widget.otherUserId == null) {
      return;
    }

    try {

      final token =
          ref.read(authControllerProvider)
              .accessToken;

      final res = await http.get(
        Uri.parse(
          "${Env.baseUrl}/users/public/${widget.otherUserId}",
        ),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {

        final data = jsonDecode(res.body);

        if (!mounted) return;

        setState(() {
          otherUserData = data["data"];
        });
      }

    } catch (e) {

      debugPrint(
        "❌ load user info => $e",
      );
    }
  }

  // ======================================================
  // CALL USER
  // ======================================================

  Future<void> callUser() async {

    final phone =
        otherUserData?["telephone"];

    if (phone == null ||
        phone.toString().trim().isEmpty) {
      return;
    }

    final uri = Uri.parse("tel:$phone");

    try {

      if (kIsWeb) {

        debugPrint(
          "⚠️ tel non garanti sur web",
        );
      }

      if (await canLaunchUrl(uri)) {

        await launchUrl(
          uri,
          mode:
              LaunchMode.externalApplication,
        );
      }

    } catch (e) {

      debugPrint(
        "❌ call error => $e",
      );
    }
  }

  // ======================================================
  // OPEN PROFILE
  // ======================================================

  Future<void> openProfile() async {

    final userId =
        widget.otherUserId;

    if (userId == null) return;

    Navigator.of(context).pop();

    await Future.delayed(
      const Duration(milliseconds: 250),
    );

    if (!mounted) return;

    context.push(
      '${RouteNames.publicProfile}/$userId',
    );
  }

  // ======================================================
  // USER MODAL
  // ======================================================

  void showUserInfoModal() {

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(30),
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
            otherUserData?[
                    "groupe_sanguin"] ??
                "--";

        return Padding(
          padding:
              const EdgeInsets.all(24),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [

              Container(
                height: 5,
                width: 60,
                decoration: BoxDecoration(
                  color:
                      Colors.grey.shade300,
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Container(
                height: 80,
                width: 80,
                decoration:
                    const BoxDecoration(
                  color:
                      Color(0xFFE53935),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 42,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                widget.fullName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const SizedBox(height: 26),

              _infoTile(
                Icons.phone,
                phone,
              ),

              _infoTile(
                Icons.location_on,
                ville,
              ),

              _infoTile(
                Icons.bloodtype,
                "Groupe sanguin : $groupe",
              ),

              const SizedBox(height: 28),

              Row(
                children: [

                  Expanded(
                    child:
                        ElevatedButton.icon(
                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            Colors.green,
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),
                        ),
                      ),
                      onPressed:
                          callUser,
                      icon: const Icon(
                        Icons.call,
                      ),
                      label: const Text(
                        "Appeler",
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child:
                        ElevatedButton.icon(
                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            const Color(
                          0xFFE53935,
                        ),
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),
                        ),
                      ),
                      onPressed:
                          openProfile,
                      icon: const Icon(
                        Icons.person,
                      ),
                      label: const Text(
                        "Profil",
                      ),
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

  Widget _infoTile(
    IconData icon,
    String text,
  ) {

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),
      child: Row(
        children: [

          Icon(
            icon,
            color:
                const Color(0xFFE53935),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // DATE
  // ======================================================

  String formatDate(
    String? dateString,
  ) {

    if (dateString == null) {
      return "";
    }

    try {

      final date =
          DateTime.parse(
            dateString,
          ).toLocal();

      return DateFormat(
        "d MMM",
        "fr_FR",
      ).format(date);

    } catch (_) {

      return "";
    }
  }

  String formatTime(
    String? dateString,
  ) {

    if (dateString == null) {
      return "";
    }

    try {

      final date =
          DateTime.parse(
            dateString,
          ).toLocal();

      return DateFormat(
        "HH:mm",
      ).format(date);

    } catch (_) {

      return "";
    }
  }

  // ======================================================
  // SCROLL
  // ======================================================

  void scrollToBottom() {

    Future.delayed(
      const Duration(milliseconds: 200),
      () {

        if (scrollController
            .hasClients) {

          scrollController.animateTo(
            scrollController
                .position.maxScrollExtent,
            duration:
                const Duration(
              milliseconds: 300,
            ),
            curve: Curves.easeOut,
          );
        }
      },
    );
  }

  // ======================================================
  // MARK AS READ
  // ======================================================

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
          "Authorization":
              "Bearer $token",
        },
      );

      markedAsRead = true;

    } catch (e) {

      debugPrint(
        "❌ markAsRead => $e",
      );
    }
  }

  // ======================================================
  // LOAD MESSAGES
  // ======================================================

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
          "Authorization":
              "Bearer $token",
        },
      );

      if (res.statusCode != 200) {

        if (!mounted) return;

        setState(() {
          loading = false;
        });

        return;
      }

      final data =
          jsonDecode(res.body);

      if (!mounted) return;

      setState(() {

        messages =
            data["data"] ?? [];

        loading = false;
      });

      scrollToBottom();

    } catch (e) {

      debugPrint(
        "❌ load messages => $e",
      );

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  // ======================================================
  // SEND MESSAGE
  // ======================================================

  Future<void> sendMessage() async {

    final text =
        messageController.text.trim();

    if (text.isEmpty ||
        sending) {
      return;
    }

    try {

      setState(() {
        sending = true;
      });

      // clear direct
      messageController.clear();

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

      if (res.statusCode != 200 &&
          res.statusCode != 201) {

        debugPrint(
          "❌ send failed",
        );
      }

      // IMPORTANT
      // realtime fera le reload

    } catch (e) {

      debugPrint(
        "❌ send message => $e",
      );

    } finally {

      if (mounted) {

        setState(() {
          sending = false;
        });
      }
    }
  }

  // ======================================================
  // UI
  // ======================================================

  @override
  Widget build(BuildContext context) {

    final currentUser =
        ref.read(authControllerProvider)
            .currentUser;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF6F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor:
            Colors.white,

        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),

        titleSpacing: 0,

        title: GestureDetector(
          onTap:
              showUserInfoModal,
          child: Row(
            children: [

              Stack(
                children: [

                  Container(
                    height: 45,
                    width: 45,
                    decoration:
                        const BoxDecoration(
                      color:
                          Color(0xFFE53935),
                      shape:
                          BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color:
                          Colors.white,
                    ),
                  ),

                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      height: 12,
                      width: 12,
                      decoration:
                          BoxDecoration(
                        color:
                            isUserOnline
                                ? Colors.green
                                : Colors.grey,
                        shape:
                            BoxShape.circle,
                        border: Border.all(
                          color:
                              Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [

                    Text(
                      widget.fullName,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          const TextStyle(
                        color:
                            Colors.black,
                        fontSize: 16,
                        fontWeight:
                            FontWeight
                                .w700,
                      ),
                    ),

                    const SizedBox(
                      height: 2,
                    ),

                    Text(
                      isUserOnline
                          ? "En ligne"
                          : "Hors ligne",
                      style:
                          TextStyle(
                        color:
                            isUserOnline
                                ? Colors.green
                                : Colors.grey,
                        fontSize: 12,
                        fontWeight:
                            FontWeight
                                .w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        actions: [

          Container(
            margin:
                const EdgeInsets.only(
              right: 12,
            ),
            decoration: BoxDecoration(
              color:
                  Colors.red.shade50,
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
            child: IconButton(
              onPressed: callUser,
              icon: const Icon(
                Icons.call,
                color:
                    Color(0xFFE53935),
              ),
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
                            const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 20,
                        ),
                        itemCount:
                            messages.length,
                        itemBuilder:
                            (
                          context,
                          index,
                        ) {

                          final m =
                              messages[index];

                          final isMe =
                              m["expediteur_id"] ==
                                  currentUser
                                      ?.idUtilisateur;

                          final isRead =
                              m["lu"] ==
                                  true;

                          return Align(
                            alignment:
                                isMe
                                    ? Alignment
                                        .centerRight
                                    : Alignment
                                        .centerLeft,
                            child:
                                Container(
                              margin:
                                  const EdgeInsets.only(
                                bottom:
                                    12,
                              ),
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal:
                                    16,
                                vertical:
                                    12,
                              ),
                              constraints:
                                  const BoxConstraints(
                                maxWidth:
                                    290,
                              ),
                              decoration:
                                  BoxDecoration(
                                color:
                                    isMe
                                        ? const Color(
                                            0xFFE53935,
                                          )
                                        : Colors
                                            .white,
                                borderRadius:
                                    BorderRadius.only(
                                  topLeft:
                                      const Radius.circular(
                                    22,
                                  ),
                                  topRight:
                                      const Radius.circular(
                                    22,
                                  ),
                                  bottomLeft:
                                      Radius.circular(
                                    isMe
                                        ? 22
                                        : 6,
                                  ),
                                  bottomRight:
                                      Radius.circular(
                                    isMe
                                        ? 6
                                        : 22,
                                  ),
                                ),
                                boxShadow: [

                                  BoxShadow(
                                    color: Colors
                                        .black
                                        .withOpacity(
                                      0.04,
                                    ),
                                    blurRadius:
                                        10,
                                    offset:
                                        const Offset(
                                      0,
                                      4,
                                    ),
                                  ),
                                ],
                              ),
                              child:
                                  Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [

                                  Text(
                                    m["contenu"] ??
                                        "",
                                    style:
                                        TextStyle(
                                      fontSize:
                                          15,
                                      height:
                                          1.4,
                                      color:
                                          isMe
                                              ? Colors.white
                                              : Colors.black87,
                                    ),
                                  ),

                                  const SizedBox(
                                    height:
                                        8,
                                  ),

                                  Row(
                                    mainAxisSize:
                                        MainAxisSize
                                            .min,
                                    children: [

                                      Text(
                                        "${formatDate(m["date_envoi"])} • ${formatTime(m["date_envoi"])}",
                                        style:
                                            TextStyle(
                                          fontSize:
                                              11,
                                          color:
                                              isMe
                                                  ? Colors.white70
                                                  : Colors.grey,
                                        ),
                                      ),

                                      const SizedBox(
                                        width:
                                            6,
                                      ),

                                      if (isMe)
                                        Icon(
                                          isRead
                                              ? Icons.done_all
                                              : Icons.done,
                                          size:
                                              16,
                                          color:
                                              isRead
                                                  ? Colors.lightBlueAccent
                                                  : Colors.white70,
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

          SafeArea(
            top: false,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [

                  BoxShadow(
                    color: Colors.black
                        .withOpacity(
                      0.04,
                    ),
                    blurRadius: 12,
                    offset:
                        const Offset(
                      0,
                      -2,
                    ),
                  ),
                ],
              ),
              child: Row(
                children: [

                  Expanded(
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 18,
                      ),
                      decoration:
                          BoxDecoration(
                        color:
                            const Color(
                          0xFFF4F5F7,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          30,
                        ),
                      ),
                      child: TextField(
                        controller:
                            messageController,
                        minLines: 1,
                        maxLines: 5,
                        textInputAction:
                            TextInputAction
                                .send,
                        onSubmitted:
                            (_) =>
                                sendMessage(),
                        decoration:
                            const InputDecoration(
                          border:
                              InputBorder.none,
                          hintText:
                              "Écrire un message...",
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  GestureDetector(
                    onTap:
                        sendMessage,
                    child: Container(
                      height: 54,
                      width: 54,
                      decoration:
                          const BoxDecoration(
                        color:
                            Color(
                          0xFFE53935,
                        ),
                        shape:
                            BoxShape.circle,
                      ),
                      child: sending
                          ? const Padding(
                              padding:
                                  EdgeInsets.all(
                                14,
                              ),
                              child:
                                  CircularProgressIndicator(
                                color:
                                    Colors.white,
                                strokeWidth:
                                    2,
                              ),
                            )
                          : const Icon(
                              Icons.send,
                              color:
                                  Colors.white,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}