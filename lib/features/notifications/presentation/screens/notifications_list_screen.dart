import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thielal/features/home/widgets/blood_request_notification_card.dart';
import 'package:thielal/features/participation/data/repositories/participation_repository.dart';

import '../controllers/notification_controller.dart';
import '../../data/models/notification_model.dart';
import 'package:thielal/features/chat/data/repositories/chat_repository.dart';
import '../../../auth/application/auth_controller.dart';
import 'package:go_router/go_router.dart';

class NotificationsListScreen extends ConsumerWidget {
  const NotificationsListScreen({super.key});

  /// ==========================
  /// FORMAT DATE
  /// ==========================
  String formatNotificationDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return "Aujourd'hui à ${DateFormat('HH:mm').format(date)}";
    }

    if (difference.inDays == 1) {
      return "Hier à ${DateFormat('HH:mm').format(date)}";
    }

    if (difference.inDays < 7) {
      return "Il y a ${difference.inDays} jours";
    }

    return DateFormat('dd/MM/yyyy à HH:mm').format(date);
  }

  //titre pour les notification
  String getNotificationTitle(NotificationModel notification) {
    final message = notification.message.toLowerCase();

    if (message.contains('urgence')) {
      return '🚨 Urgence';
    }

    if (message.contains('validé') || message.contains('contribution')) {
      return '❤️ Don validé';
    }

    if (message.contains('sang')) {
      return '🩸 Demande de sang';
    }

    return '📢 Notif';
  }

  String _extractBloodGroup(String message) {
    final groups = ['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'];

    for (final g in groups) {
      if (message.contains(g)) {
        return g;
      }
    }

    return '?';
  }

  String _extractCity(String message) {
    final regex = RegExp(r'à\s+(.+)');

    final match = regex.firstMatch(message);

    if (match != null) {
      return match.group(1) ?? '';
    }

    return 'Mauritanie';
  }

  Future<void> _showDemandeModal(
    BuildContext context,
    WidgetRef ref, // ✅ AJOUT MINIMAL ICI
    NotificationModel notification,
  ) async {

    final isDark =
    Theme.of(context).brightness == Brightness.dark;

    final colors =
    Theme.of(context).colorScheme;
    String demandeurNom = notification.fullName;
    final token = ref.read(authControllerProvider).accessToken;

    final participationRepo = ParticipationRepository(token: token);

    bool estParticipant = false;

    if (notification.demandeId != null) {
      estParticipant = await participationRepo.estParticipant(
        notification.demandeId!,
      );
    }

    print("demandeId = ${notification.demandeId}");
    print("nom = ${notification.nom}");
    print("prenom = ${notification.prenom}");

    if (notification.demandeId != null) {
      try {
        final token = ref.read(authControllerProvider).accessToken;

        final repo = ChatRepository(token: token);

        final demande = await repo.getDemandeById(notification.demandeId!);

        print("DEMANDE = $demande");

        demandeurNom =
            "${demande["utilisateur"]["prenom"]} ${demande["utilisateur"]["nom"]}"
                .split(' ')
                .map(
                  (e) =>
                      e.isEmpty
                          ? e
                          : e[0].toUpperCase() + e.substring(1).toLowerCase(),
                )
                .join(' ');
        print("DEMANDEUR = $demandeurNom");
      } catch (e) {
        print("ERREUR DEMANDE = $e");
      }
    }
    showDialog(
      context: context,
      builder:
          (dialogContext) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "🚨 Demande de sang",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.red.shade100,
                    child: const Icon(
                      Icons.person,
                      size: 36,
                      color: Colors.red,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    demandeurNom.isEmpty ? "Demandeur" : demandeurNom,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ), 

                  const SizedBox(height: 16),

                  Text(
                    notification.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_hospital,
                          color: Colors.red,
                          size: 18,
                        ),

                        const SizedBox(width: 8),

                        Flexible(
                          child: Text(
                            notification.centreNom,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.message),
                      label: const Text("Message"),
                      onPressed: () async {
                        context.pop();

                        final token =
                            ref.read(authControllerProvider).accessToken;
                        final chatRepo = ChatRepository(token: token);

                        final demandeId = notification.demandeId;
                        final user2Id = notification.utilisateurId;

                        if (demandeId == null || user2Id == null) return;

                        final conversations = await chatRepo.getConversations();

                        int? conversationId;

                        for (final c in conversations) {
                          if (c.demandeId == demandeId) {
                            conversationId = c.idConversation;
                            break;
                          }
                        }

                        conversationId ??= await chatRepo.createConversation(
                          user2Id,
                        );

                        if (context.mounted) {
                          context.push(
                            '/chat/$conversationId',
                            extra: {
                              "fullName": demandeurNom,
                              "otherUserId": user2Id,
                            },
                          );
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        estParticipant ? Icons.check_circle : Icons.bloodtype,
                      ),
                      label: Text(
                        estParticipant ? "Déjà participant" : "Je participe",
                      ),
                      onPressed:
                          estParticipant
                              ? null
                              : () async {
                                try {
                                  await participationRepo.participer(
                                    notification.demandeId!,
                                  );

                                  if (context.mounted) {
                                    // Fermer le modal principal
                                    Navigator.of(dialogContext).pop();

                                    showDialog(
                                      context: context,

                                      builder: (successDialogContext) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Participation enregistrée',
                                          ),

                                          content: Text(
                                            'Vous participez maintenant à cette demande.\n\n'
                                            'Veuillez contacter le centre ou vous y rendre pour effectuer votre don.',
                                          ),

                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(
                                                  successDialogContext,
                                                ).pop();
                                              },

                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }

                                  ref.invalidate(
                                    notificationControllerProvider,
                                  );
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          e.toString().replaceFirst(
                                            "Exception: ",
                                            "",
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationControllerProvider);
    final isDark =
    Theme.of(context).brightness == Brightness.dark;

final colors =
    Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.surface,
        title: Text(
          "Notifications",
          style: TextStyle(
            color: colors.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: notifications.when(
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Text(
                "Aucune notification",
                style: TextStyle(
                  color: colors.onSurface,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final notification = list[index];

              if (notification.message.toLowerCase().contains("sang")) {
                return BloodRequestNotificationCard(
                  bloodGroup: _extractBloodGroup(notification.message),
                  city: _extractCity(notification.message),
                  date: formatNotificationDate(notification.dateCreation),
                  isRead: notification.lu,

                  onTap: () async {
                    if (!notification.lu) {
                      await ref
                          .read(notificationControllerProvider.notifier)
                          .markAsRead(notification.idNotification);
                    }

                    _showDemandeModal(context, ref, notification); // ✅ FIX
                  },
                );
              }

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: notification.lu
                  ? (isDark
                      ? colors.surfaceContainerHighest
                      : Colors.grey.shade100)
                  : (isDark
                      ? colors.primaryContainer
                      : const Color(0xFFE3F2FD)),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: notification.lu
                      ? (isDark
                          ? colors.outline
                          : Colors.grey.shade400)
                      : (isDark
                          ? colors.primary
                          : const Color(0xFF4FC3F7)),
                    child: const Icon(Icons.notifications, color: Colors.white),
                  ),

                  title: Text(
                    getNotificationTitle(notification),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(
                          color: isDark
                              ? colors.onSurface.withOpacity(0.8)
                              : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatNotificationDate(notification.dateCreation),
                        style: TextStyle(
                          color: isDark
                              ? colors.onSurface.withOpacity(0.6)
                              : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  onTap: () async {
                    if (!notification.lu) {
                      await ref
                          .read(notificationControllerProvider.notifier)
                          .markAsRead(notification.idNotification);
                    }
                  },
                ),
              );
            },
          );
        },

        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}
