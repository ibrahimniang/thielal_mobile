import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/notification_controller.dart';
import '../../data/models/notification_model.dart';

class NotificationsListScreen extends ConsumerWidget {
  const NotificationsListScreen({super.key});

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

              return ListTile(
                /// icone notification
                leading: CircleAvatar(
                  backgroundColor: notification.lu ? Colors.grey : Colors.red,
                  child: const Icon(Icons.notifications, color: Colors.white),
                ),

                /// message notification
                title: Text(notification.message),

                /// date
                subtitle: Text(notification.dateCreation.toString()),

                /// ==========================
                /// CLICK NOTIFICATION
                /// ==========================
                onTap: () async {
                  /// si notification non lue
                  if (!notification.lu) {
                    /// appeler API mark as read
                    await ref
                        .read(notificationControllerProvider.notifier)
                        .markAsRead(notification.idNotification);

                    /// recharger les notifications
                    ref
                        .read(notificationControllerProvider.notifier)
                        .loadNotifications();
                  }
                },
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
