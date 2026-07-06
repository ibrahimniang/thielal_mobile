import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:thielal/features/home/widgets/blood_request_notification_card.dart';
import 'package:thielal/features/participation/data/repositories/participation_repository.dart';
import 'package:thielal/features/receipt/data/repositories/receipt_repository.dart';
import 'package:thielal/features/receipt/data/services/receipt_remote_service.dart';
import '../../../../core/network/dio_provider.dart';
import 'package:thielal/shared/widgets/app_heart_loader.dart';

import '../controllers/notification_controller.dart';
import '../../data/models/notification_model.dart';
import 'package:thielal/features/chat/data/repositories/chat_repository.dart';
import '../../../auth/application/auth_controller.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';

class NotificationsListScreen extends ConsumerStatefulWidget {
  const NotificationsListScreen({super.key});

  @override
  ConsumerState<NotificationsListScreen> createState() =>
      _NotificationsListScreenState();
}

class _NotificationsListScreenState
    extends ConsumerState<NotificationsListScreen> {
  int? loadingNotificationId;
  int? loadingParticipationId;

  /// ==========================
  /// FORMAT DATE
  /// ==========================
  String formatNotificationDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return "${AppLocalizations.of(context)!.todayAt} ${DateFormat('HH:mm').format(date)}";
    }

    if (difference.inDays == 1) {
      return "${AppLocalizations.of(context)!.yesterdayAt} ${DateFormat('HH:mm').format(date)}";
    }

    if (difference.inDays < 7) {
      return "${AppLocalizations.of(context)!.daysAgo} ${difference.inDays} ${AppLocalizations.of(context)!.days}";
    }
    return DateFormat('dd/MM/yyyy à HH:mm').format(date);
  }

  //titre pour les notification
  String getNotificationTitle(
    BuildContext context,
    NotificationModel notification,
  ) {
    final l10n = AppLocalizations.of(context)!;

    switch (notification.type) {
      case 'CERTIFICAT_GENERE':
        return '❤️ ${l10n.validatedDonation}';

      case 'DEMANDE_SANG':
        return '🩸 ${l10n.bloodRequest}';

      case 'DEMANDE_DELIVREE':
        return '✅ ${l10n.bloodRequest}';

      default:
        return '📢 ${l10n.notification}';
    }
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

  String _extractCity(BuildContext context, String message) {
    final regex = RegExp(r'à\s+(.+)');

    final match = regex.firstMatch(message);

    if (match != null) {
      return match.group(1) ?? '';
    }

    return AppLocalizations.of(context)!.mauritania;
  }

  Future<void> _showDemandeModal(
    BuildContext context,
    WidgetRef ref, // ✅ AJOUT MINIMAL ICI
    NotificationModel notification,
  ) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final colors = Theme.of(context).colorScheme;
    String demandeurNom = notification.fullName;
    final token = ref.read(authControllerProvider).accessToken;
    final l10n = AppLocalizations.of(context)!;

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
                  Text(
                    "🚨 ${l10n.bloodRequest}",

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
                    demandeurNom.isEmpty ? l10n.requester : demandeurNom,
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
                      label: Text(l10n.message),
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
                      icon:
                          loadingParticipationId == notification.idNotification
                              ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Icon(
                                estParticipant
                                    ? Icons.check_circle
                                    : Icons.bloodtype,
                              ),
                      label: Text(
                        estParticipant
                            ? l10n.alreadyParticipant
                            : l10n.imParticipating,
                      ),
                      onPressed:
                          estParticipant
                              ? null
                              : () async {
                                setState(() {
                                  loadingParticipationId =
                                      notification.idNotification;
                                });

                                await Future.delayed(
                                  const Duration(milliseconds: 25),
                                );
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
                                          title: Text(
                                            l10n.participationRecorded,
                                          ),

                                          content: Text(
                                            '${l10n.youAreNowParticipating}\n\n'
                                            '${l10n.contactCenterToDonate}',
                                          ),

                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(
                                                  successDialogContext,
                                                ).pop();
                                              },

                                              child: Text(l10n.ok),
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

  Future<void> _showReceiptDialog(
    BuildContext context,
    WidgetRef ref,
    NotificationModel notification,
  ) async {
    // print("===== RECEIPT =====");
    // print("TYPE : ${notification.type}");
    // print("DEMANDE ID : ${notification.demandeId}");

    if (notification.demandeId == null) {
      // print("DEMANDE ID NULL");
      return;
    }

    try {
      final repository = ReceiptRepository(
        ReceiptService(ref.read(dioProvider)),
      );

      // print("AVANT API");

      final token = await repository.getReceiptToken(notification.demandeId!);

      // print("TOKEN : $token");

      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (_) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(l10n.deliveryReceipt),
            content: SizedBox(
              width: 260,
              height: 320,
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: QrImageView(data: token, version: QrVersions.auto),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(l10n.presentQrToStaff, textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      // print("ERREUR : $e");

      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final notifications = ref.watch(notificationControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.surface,
        title: Text(
          l10n.notifications,
          style: TextStyle(
            color: colors.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case "read_all":
                  await ref
                      .read(notificationControllerProvider.notifier)
                      .markAllAsRead();

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.allNotificationsMarkedAsRead),
                      ),
                    );
                  }
                  break;

                case "delete_all":
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder:
                        (dialogContext) => AlertDialog(
                          title: Text(l10n.deleteAllNotificationsTitle),
                          content: Text(l10n.deleteAllNotificationsMessage),
                          actions: [
                            TextButton(
                              onPressed:
                                  () => Navigator.of(dialogContext).pop(false),
                              child: Text(l10n.cancel),
                            ),
                            FilledButton(
                              onPressed:
                                  () => Navigator.of(dialogContext).pop(true),
                              child: Text(l10n.delete),
                            ),
                          ],
                        ),
                  );

                  if (confirm == true) {
                    await ref
                        .read(notificationControllerProvider.notifier)
                        .deleteAllReadNotifications();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.allNotificationsDeleted)),
                      );
                    }
                  }

                  break;
              }
            },
            itemBuilder:
                (_) => [
                  PopupMenuItem(
                    value: "read_all",
                    child: Row(
                      children: [
                        Icon(Icons.done_all),
                        SizedBox(width: 10),
                        Text(l10n.markAllAsRead),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: "delete_all",
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline),
                        SizedBox(width: 10),
                        Text(l10n.deleteReadNotifications),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),

      body: notifications.when(
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Text(
                l10n.noNotification,
                style: TextStyle(color: colors.onSurface),
              ),
            );
          }

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final notification = list[index];

              if (notification.type == "DEMANDE_SANG") {
                print("MESSAGE = ${notification.message}");
                return BloodRequestNotificationCard(
                  bloodGroup: _extractBloodGroup(notification.message),
                  city: notification.ville ?? l10n.mauritania,
                  date: formatNotificationDate(
                    context,
                    notification.dateCreation,
                  ),
                  isRead: notification.lu,
                  isLoading:
                      loadingNotificationId == notification.idNotification,

                  onTap: () async {
                    setState(() {
                      loadingNotificationId = notification.idNotification;
                    });
                    await Future.delayed(const Duration(milliseconds: 25));

                    try {
                      if (!notification.lu) {
                        await ref
                            .read(notificationControllerProvider.notifier)
                            .markAsRead(notification.idNotification);
                      }

                      await _showDemandeModal(context, ref, notification);
                    } finally {
                      if (mounted) {
                        setState(() {
                          loadingNotificationId = null;
                        });
                      }
                    }
                  },
                );
              }

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      notification.lu
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
                    backgroundColor:
                        notification.lu
                            ? (isDark ? colors.outline : Colors.grey.shade400)
                            : (isDark
                                ? colors.primary
                                : const Color(0xFF4FC3F7)),
                    child: const Icon(Icons.notifications, color: Colors.white),
                  ),

                  title: Text(
                    getNotificationTitle(context, notification),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(
                          color:
                              isDark
                                  ? colors.onSurface.withOpacity(0.8)
                                  : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatNotificationDate(
                          context,
                          notification.dateCreation,
                        ),
                        style: TextStyle(
                          color:
                              isDark
                                  ? colors.onSurface.withOpacity(0.6)
                                  : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  trailing:
                      notification.type == "DEMANDE_DELIVREE"
                          ? IconButton(
                            icon: const Icon(Icons.visibility_outlined),
                            tooltip: l10n.viewReceipt,
                            onPressed: () {
                              _showReceiptDialog(context, ref, notification);
                            },
                          )
                          : null,

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

        loading: () => const Center(child: AppHeartLoader(size: 90)),

        error: (e, _) => const SizedBox.shrink(),
      ),
    );
  }
}
