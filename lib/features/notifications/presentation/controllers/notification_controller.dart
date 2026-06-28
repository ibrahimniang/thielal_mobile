import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/services/notification_service.dart';

/// ===============================
/// PROVIDER SERVICE
/// ===============================
final notificationServiceProvider = Provider<NotificationService>((ref) {
  final dio = ref.read(dioProvider);
  return NotificationService(dio);
});

/// ===============================
/// PROVIDER REPOSITORY
/// ===============================
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final service = ref.read(notificationServiceProvider);
  return NotificationRepository(service);
});

/// ===============================
/// CONTROLLER PROVIDER
/// ===============================
final notificationControllerProvider = StateNotifierProvider<
    NotificationController,
    AsyncValue<List<NotificationModel>>>((ref) {
  final repo = ref.read(notificationRepositoryProvider);
  return NotificationController(repo,ref)..loadNotifications();
});

/// ===============================
/// NOTIFICATION CONTROLLER
/// ===============================
class NotificationController
    extends StateNotifier<AsyncValue<List<NotificationModel>>> {

  final NotificationRepository repository;
  final Ref ref;

  NotificationController(this.repository, this.ref)
      : super(const AsyncValue.loading());

  /// ===============================
  /// Charger les notifications
  /// ===============================
  Future<void> loadNotifications() async {
    try {
      final notifications = await repository.fetchNotifications();

      state = AsyncValue.data(notifications);

    } catch (e, s) {

      state = AsyncValue.error(e, s);
    }
  }

  /// ===============================
  /// Marquer notification comme lue
  /// ===============================
  Future<void> markAsRead(int id) async {

    try {

      await repository.markAsRead(id);

      /// recharger la liste
      await loadNotifications();
       /// mettre à jour le badge
    ref.invalidate(unreadNotificationCountProvider);


    } catch (e) {

      print("Erreur markAsRead: $e");

    }
  }

  /// ===============================
  /// Nombre notifications non lues
  /// ===============================
  Future<int> getUnreadCount() async {

    try {

      return await repository.fetchUnreadCount();

    } catch (e) {

      print("Erreur unreadCount: $e");

      return 0;

    }
  }
/// ===============================
/// Tout marquer comme lu
/// ===============================
Future<void> markAllAsRead() async {
  try {
    await repository.markAllAsRead();

    await loadNotifications();

    ref.invalidate(unreadNotificationCountProvider);

  } catch (e) {
    print("Erreur markAllAsRead : $e");
  }
}

/// ===============================
/// Supprimer les notifications lues
/// ===============================
Future<void> deleteAllReadNotifications() async {
  try {
    await repository.deleteAllReadNotifications();

    await loadNotifications();

    ref.invalidate(unreadNotificationCountProvider);

  } catch (e) {
    print("Erreur deleteAllReadNotifications : $e");
  }
}
}

/// =================================
/// PROVIDER POUR LE BADGE
/// =================================
final unreadNotificationCountProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.fetchUnreadCount();
});

