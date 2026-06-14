import 'package:http/http.dart' as http;

import '../../../../core/config/env.dart';
import '../../../../core/config/api_endpoints.dart';

class DonationService {

  Future<http.Response> getDemandeById(
    int id,
    String token,
  ) {
    return http.get(
      Uri.parse(
        "${Env.baseUrl}${ApiEndpoints.demandeById(id)}",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );
  }
}