import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/services/notification_service.dart';

/// provider service
final notificationServiceProvider = Provider<NotificationService>((ref) {
  final dio = ref.read(dioProvider);
  return NotificationService(dio);
});

/// provider repository
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final service = ref.read(notificationServiceProvider);
  return NotificationRepository(service);
});

/// controller principal
final notificationControllerProvider =
    StateNotifierProvider<NotificationController,
        AsyncValue<List<NotificationModel>>>((ref) {
  final repo = ref.read(notificationRepositoryProvider);
  return NotificationController(repo)..loadNotifications();
});

class NotificationController
    extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  final NotificationRepository repository;

  NotificationController(this.repository)
      : super(const AsyncValue.loading());

  Future<void> loadNotifications() async {
    try {
      final notifications = await repository.fetchNotifications();
      state = AsyncValue.data(notifications);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}