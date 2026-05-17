import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';

class AlertService {
  final Dio _dio = ApiClient().dio;

  Future<Response> getAlerts() async {
    return await _dio.get('/alertes');
  }
}
