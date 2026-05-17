import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import '../models/nearby_donor_model.dart';

class NearbyDonorsRepository {
  /// 🔥 BACKEND
  final String baseUrl = 'https://lifelink-backend-3bgr.onrender.com/api/dons';

  Future<List<NearbyDonorModel>> getNearbyDonors({
    required String ville,
    required String groupe,
    required double latitude,
    required double longitude,
    required int utilisateurId,
  }) async {
    try {
      /// DEBUG
      debugPrint('🚀 NEARBY DONORS REQUEST');

      debugPrint('🏙️ VILLE => $ville');

      debugPrint('🩸 GROUPE => $groupe');

      debugPrint('📍 LAT => $latitude');

      debugPrint('📍 LNG => $longitude');

      final response = await http.post(
        Uri.parse('$baseUrl/nearby-donors'),

        headers: {'Content-Type': 'application/json'},

        body: jsonEncode({
          'ville': ville,

          'groupe': groupe,

          'latitude': latitude,

          'longitude': longitude,
          
          'utilisateur_id': utilisateurId,
        }),
      );

      debugPrint('✅ STATUS => ${response.statusCode}');

      debugPrint('📦 RESPONSE => ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(data['error'] ?? 'Erreur nearby donors');
      }

      final donors =
          (data['donneurs'] as List)
              .map((e) => NearbyDonorModel.fromJson(e))
              .toList();

      debugPrint('🩸 DONORS COUNT => ${donors.length}');

      return donors;
    } catch (e) {
      debugPrint('❌ NEARBY DONORS ERROR => $e');

      rethrow;
    }
  }
}
