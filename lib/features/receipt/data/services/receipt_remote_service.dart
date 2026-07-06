import 'package:dio/dio.dart';
import '../../../../core/config/api_endpoints.dart';

class ReceiptService {
  final Dio dio;

  ReceiptService(this.dio);

  Future<Response> getReceipt(
    int demandeId,
  ) async {
    return await dio.get(
      ApiEndpoints.receipt(
        demandeId,
      ),
    );
  }
}