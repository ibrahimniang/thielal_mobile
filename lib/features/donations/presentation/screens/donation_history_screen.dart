import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../application/donation_controller.dart';

class DonationHistoryScreen extends ConsumerWidget {
  const DonationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final donsAsync = ref.watch(myDonationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes dons"),
        backgroundColor: Colors.red,
      ),
      body: donsAsync.when(
        data: (dons) {
          if (dons.isEmpty) {
            return const Center(
              child: Text("Aucun don enregistré"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: dons.length,
            itemBuilder: (context, index) {
              final don = dons[index];

              final date = DateTime.tryParse(don.dateDon.toString());
              final formattedDate = date != null
                  ? DateFormat('dd MMM yyyy').format(date)
                  : "Date inconnue";

              final centre = don.centre;
              final certificat = don.certificat;

              final hasCertificat = certificat != null;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ================= HEADER =================
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.red.withOpacity(0.1),
                          child: const Icon(Icons.bloodtype, color: Colors.red),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Don de sang",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                "Groupe : ${don.groupeSanguin}",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ================= STATUS =================
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: hasCertificat
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            hasCertificat ? "Validé" : "En attente",
                            style: TextStyle(
                              color: hasCertificat ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ================= CENTRE =================
                    Row(
                      children: [
                        const Icon(Icons.local_hospital,
                            size: 18, color: Colors.grey),

                        const SizedBox(width: 6),

                        Text(
                          centre?.nom ?? "Centre inconnu",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 18, color: Colors.grey),

                        const SizedBox(width: 6),

                        Text(
                          centre?.ville ?? "Ville inconnue",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // ================= DATE =================
                    Text(
                      "Date : $formattedDate",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ================= CERTIFICAT =================
                    if (hasCertificat)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            final url = certificat!.urlCertificat;

                            // TODO: ouvrir PDF / webview
                            debugPrint("Ouvrir certificat: $url");
                          },
                          icon: const Icon(Icons.description,
                              color: Colors.deepPurple),
                          label: const Text(
                            "Voir certificat",
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                        ),
                      )
                    else
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Certificat non disponible",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },

        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.red),
        ),

        error: (e, _) => Center(
          child: Text("Erreur: $e"),
        ),
      ),
    );
  }
}