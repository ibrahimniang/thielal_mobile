import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thielal/features/home/widgets/blood_request_notification_card.dart';

import '../controllers/notification_controller.dart';
import '../../data/models/notification_model.dart';

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
  final groups = [
    'O+',
    'O-',
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
  ];

  for (final g in groups) {
    if (message.contains(g)) {
      return g;
    }
  }

  return '?';
}

String _extractCity(String message) {
  final regex = RegExp(r'à\s+(.+)');

  final match = regex.firstMatch(
    message,
  );

  if (match != null) {
    return match.group(1) ?? '';
  }

  return 'Mauritanie';
}


void _showDemandeModal(
  BuildContext context,
  NotificationModel notification,
) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
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
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              notification.message,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.message),
                label: const Text("Message"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.bloodtype),
                label: const Text("J'y vais"),
                onPressed: () {
                  Navigator.pop(context);
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
    /// on observe le controller Riverpod
    final notifications = ref.watch(notificationControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),

      /// gestion des états
      body: notifications.when(
        /// ==========================
        /// DATA
        /// ==========================
        data: (list) {
          /// aucune notification
          if (list.isEmpty) {
            return const Center(child: Text("Aucune notification"));
          }

          return ListView.builder(
            itemCount: list.length,

            itemBuilder: (context, index) {
              final notification = list[index];

              // 🔥 Notification demande de sang
              if (notification.message.toLowerCase().contains("sang")) {
  return BloodRequestNotificationCard(
    bloodGroup: _extractBloodGroup(
      notification.message,
    ),

    city: _extractCity(
      notification.message,
    ),

    date: formatNotificationDate(
      notification.dateCreation,
    ),

    isRead: notification.lu,

   onTap: () async {

  if (!notification.lu) {
    await ref
        .read(notificationControllerProvider.notifier)
        .markAsRead(
          notification.idNotification,
        );
  }

  _showDemandeModal(
    context,
    notification,
  );
},
  );
}

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

                decoration: BoxDecoration(
                  color:
                      notification.lu
                          ? Colors.grey.shade100
                          : const Color(0xFFE3F2FD),

                  borderRadius: BorderRadius.circular(12),
                ),

                child: ListTile(
                  /// icone notification
                  leading: CircleAvatar(
                    backgroundColor:
                        notification.lu
                            ? Colors.grey.shade400
                            : const Color(0xFF4FC3F7),

                    child: const Icon(Icons.notifications, color: Colors.white),
                  ),

                  /// message notification
                  title: Text(
                    getNotificationTitle(notification),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),

                      Text(notification.message),

                      const SizedBox(height: 4),

                      Text(formatNotificationDate(notification.dateCreation)),
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

        /// ==========================
        /// LOADING
        /// ==========================
        loading: () => const Center(child: CircularProgressIndicator()),

        /// ==========================
        /// ERROR
        /// ==========================
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}
