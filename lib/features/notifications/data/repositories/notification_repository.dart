import 'package:dio/dio.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationRepository {
  final NotificationService service;

  NotificationRepository(this.service);

  /// ===============================
  /// récupérer la liste des notifications
  /// ===============================
  Future<List<NotificationModel>> fetchNotifications() async {
    final response = await service.getNotifications();

    final data = response.data;

    /// Vérifie que la réponse est valide
    if (data["success"] == true && data["data"] != null) {
      final List list = data["data"];

      /// conversion JSON -> NotificationModel
      return list
          .map((e) => NotificationModel.fromJson(e))
          .toList();
    }

    /// si aucune notification
    return [];
  }

  /// ===============================
  /// marquer notification comme lue
  /// ===============================
  Future<void> markAsRead(int id) async {
    await service.markAsRead(id);
  }

  /// ===============================
  /// récupérer nombre notifications non lues
  /// ===============================
  Future<int> fetchUnreadCount() async {
    final response = await service.getUnreadCount();

    final data = response.data;

    /// Exemple backend attendu :
    /// {
    ///   "success": true,
    ///   "data": 5
    /// }

    if (data["success"] == true) {

      /// conversion sécurisée pour éviter
      /// type 'String' is not subtype of int
      return int.tryParse(data["data"].toString()) ?? 0;

    }

    return 0;
  }
  
}