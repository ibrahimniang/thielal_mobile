import 'package:dio/dio.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../../core/config/api_endpoints.dart';

class NotificationService {
  final Dio dio;

  NotificationService(this.dio);

  /// récupérer les notifications
  Future<Response> getNotifications() async {
    final response = await dio.get(ApiEndpoints.notifications);

    print("NOTIFICATION API RESPONSE:");
    print(response.data);

    return response;
  }

  /// nombre notifications non lues
  Future<Response> getUnreadCount() async {
    return await dio.get(ApiEndpoints.unreadCount);
  }

  /// marquer notification comme lue
  Future<Response> markAsRead(int id) async {
    return await dio.patch(ApiEndpoints.markAsRead(id));
  }
}