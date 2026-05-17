import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';

class CollecteService {
  final Dio _dio = ApiClient().dio;

  Future<Response> getCollectes() async {
    return await _dio.get('/collectes');
  }

  Future<Response> participer(int collecteId, int utilisateurId) async {
    return await _dio.post(
      '/collectes/$collecteId/participer',

      data: {'utilisateur_id': utilisateurId},
    );
  }
}
