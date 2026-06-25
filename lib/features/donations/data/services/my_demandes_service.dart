import 'package:dio/dio.dart';
import '../../../../core/config/api_endpoints.dart';

class MyDemandesService {
  final Dio dio;

  MyDemandesService(this.dio);

  Future<Response> getMyDemandes() async {
    return await dio.get(
      ApiEndpoints.myDemandes,
    );
  }
}