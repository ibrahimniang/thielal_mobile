import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../core/config/env.dart';
import '../../../../core/config/api_endpoints.dart';
import '../../../auth/application/auth_controller.dart';

class DemandeSangScreen extends ConsumerStatefulWidget {
  const DemandeSangScreen({super.key});

  @override
  ConsumerState<DemandeSangScreen> createState() => _DemandeSangScreenState();
}

class _DemandeSangScreenState extends ConsumerState<DemandeSangScreen> {
  final villeController = TextEditingController();

  String? selectedGroupe;
  int quantite = 1;
  bool isLoading = false;

  final List<String> groupes = [
    "A+","A-","B+","B-","AB+","AB-","O+","O-"
  ];

  Future<void> envoyerDemande() async {
  if (selectedGroupe == null || villeController.text.isEmpty) {
    return;
  }

  setState(() => isLoading = true);

  try {
    // 👇 ICI TU PRENDS LE TOKEN
    final token = ref.read(authControllerProvider).accessToken;

    if (token == null || token.isEmpty) {
      throw Exception("Token manquant");
    }

    final cleanToken = token.replaceAll("Bearer ", "");

    // 👇 ICI TU FAIS LA REQUÊTE
    final response = await http.post(
      Uri.parse("${Env.baseUrl}${ApiEndpoints.demandeSang}"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $cleanToken",
      },
      body: jsonEncode({
        "groupe_sanguin": selectedGroupe,
        "ville": villeController.text.trim(),
        "quantite": quantite,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Demande envoyée ✅")),
      );
      Navigator.pop(context);
    } else {
      throw Exception(response.body);
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erreur: $e")),
    );
  }

  setState(() => isLoading = false);
}
  @override
  void dispose() {
    villeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demande de sang"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// FORMULAIRE
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black12,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [

                  /// Groupe sanguin
                  DropdownButtonFormField<String>(
                    value: selectedGroupe,
                    items: groupes.map((g) {
                      return DropdownMenuItem(
                        value: g,
                        child: Text(g),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGroupe = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Groupe sanguin",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Ville
                  TextField(
                    controller: villeController,
                    decoration: const InputDecoration(
                      labelText: "Ville",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Quantité
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Quantité",
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (quantite > 1) {
                                setState(() => quantite--);
                              }
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text(
                            "$quantite",
                            style: const TextStyle(fontSize: 18),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() => quantite++);
                            },
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// BOUTON ENVOI
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : envoyerDemande,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Envoyer la demande",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}