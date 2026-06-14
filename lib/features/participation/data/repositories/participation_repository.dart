import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/config/env.dart';

class ParticipationRepository {
  final String? token;

  ParticipationRepository({required this.token});

  Future<void> participer(int demandeId) async {
    final res = await http.post(
      Uri.parse("${Env.baseUrl}/dons/participer"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"demande_id": demandeId}),
    );

    final data = jsonDecode(res.body);

    if (res.statusCode != 200 || data["success"] != true) {
      final message =
          data["message"] ?? data["data"]?["message"] ?? "Erreur participation";

      throw Exception(message);
    }
  }

 
  Future<bool> estParticipant(
  int demandeId,
  ) async {
  final res = await http.get(
    Uri.parse(
      "${Env.baseUrl}/dons/$demandeId/est-participant",
    ),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
  );

  final data = jsonDecode(res.body);

  if (res.statusCode != 200) {
    return false;
  }

  return data["data"]["participant"] == true;
}
}
