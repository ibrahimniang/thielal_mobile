import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/notification_controller.dart';
import '../../data/models/notification_model.dart';

class NotificationsListScreen extends ConsumerWidget {
  const NotificationsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: notifications.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text("Aucune notification"));
          }

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final notification = list[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      notification.lu ? Colors.grey : Colors.red,
                  child: const Icon(Icons.notifications, color: Colors.white),
                ),
                title: Text(notification.message),
                subtitle:
                    Text(notification.dateCreation.toString()),
              );
            },
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(e.toString())),
      ),
    );
  }
}