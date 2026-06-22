import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';

class DeviceRepository {
  final Dio dio = ApiClient().dio;

  Future<void> registerDevice(Map<String, dynamic> body) async {
    await dio.post("/devices/register", data: body);
  }

  Future<void> ping() async {
    await dio.post("/devices/ping");
  }
}
