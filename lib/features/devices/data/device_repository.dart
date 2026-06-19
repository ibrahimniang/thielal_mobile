import 'package:dio/dio.dart';
import 'package:thielal/features/devices/domain/models/device_model.dart';

import '../../../core/network/api_client.dart';


class DeviceRepository {
  final Dio dio = ApiClient().dio;

  Future<void> registerDevice(
    Map<String, dynamic> body,
  ) async {
    await dio.post(
      "/devices/register",
      data: body,
    );
  }

  Future<List<DeviceModel>> getMyDevices() async {
    final response =
        await dio.get("/devices/my-devices");

    final data = response.data;

    if (data["success"] == true &&
        data["data"] != null) {
      return (data["data"] as List)
          .map(
            (e) => DeviceModel.fromJson(e),
          )
          .toList();
    }

    return [];
  }

  Future<void> revokeDevice(
    int id,
  ) async {
    await dio.delete(
      "/devices/$id",
    );
  }
}