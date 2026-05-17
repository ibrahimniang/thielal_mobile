import 'package:dio/dio.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationRepository {
  final NotificationService service;

  NotificationRepository(this.service);

  Future<List<NotificationModel>> fetchNotifications() async {
    final response = await service.getNotifications();

    final data = response.data;

    if (data["success"] == true && data["data"] != null) {
      final List list = data["data"];

      return list
          .map((e) => NotificationModel.fromJson(e))
          .toList();
    }

    return [];
  }
}