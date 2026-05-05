import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/config/env.dart';
import '../../../../core/config/api_endpoints.dart';
import '../models/donation_model.dart';

class DonationRepository {

  Future<List<DonationModel>> getMyDonations(String token) async {
    final response = await http.get(
      Uri.parse("${Env.baseUrl}${ApiEndpoints.myDons}"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List list = data['data'];

      return list.map((e) => DonationModel.fromJson(e)).toList();
    } else {
      throw Exception("Erreur chargement dons");
    }
  }
}