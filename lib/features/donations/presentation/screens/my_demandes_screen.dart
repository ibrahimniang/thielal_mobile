import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/models/my_demande_model.dart';
import '../../data/repositories/my_demandes_repository.dart';
import '../../data/services/my_demandes_service.dart';
import '../../../../l10n/app_localizations.dart';

class MyDemandesScreen extends ConsumerStatefulWidget {
  const MyDemandesScreen({super.key});

  @override
  ConsumerState<MyDemandesScreen> createState() => _MyDemandesScreenState();
}

class _MyDemandesScreenState extends ConsumerState<MyDemandesScreen> {
  List<MyDemandeModel> demandes = [];

  bool isLoading = true;
  String filtre = "TOUTES";
  String getStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case "DELIVREE":
        return AppLocalizations.of(context)!.delivered;

      case "EN_ATTENTE":
        return AppLocalizations.of(context)!.pending;

      case "ANNULEE":
        return AppLocalizations.of(context)!.cancelled;

      default:
        return status;
    }
  }

  @override
  void initState() {
    super.initState();

    chargerDemandes();
  }

  Future<void> chargerDemandes() async {
    try {
      final dio = ref.read(dioProvider);

      final repository = MyDemandesRepository(MyDemandesService(dio));

      final result = await repository.fetchMyDemandes();

      if (!mounted) return;

      setState(() {
        demandes = result;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("ERREUR DEMANDES => $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text('${l10n.myRequests} (${demandes.length})')),

      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : demandes.isEmpty
              ? Center(child: Text(l10n.noRequestFound))
              : RefreshIndicator(
                onRefresh: chargerDemandes,

                child: Builder(
                  builder: (context) {
                    final demandesFiltrees =
                        filtre == "TOUTES"
                            ? demandes
                            : demandes
                                .where((d) => d.statut.toUpperCase() == filtre)
                                .toList();

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),

                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,

                            child: Row(
                              children: [
                                ChoiceChip(
                                  label: Text(l10n.all),

                                  selected: filtre == "TOUTES",

                                  onSelected: (_) {
                                    setState(() {
                                      filtre = "TOUTES";
                                    });
                                  },
                                ),

                                const SizedBox(width: 8),

                                ChoiceChip(
                                  label: Text(l10n.pending),

                                  selected: filtre == "EN_ATTENTE",

                                  onSelected: (_) {
                                    setState(() {
                                      filtre = "EN_ATTENTE";
                                    });
                                  },
                                ),

                                const SizedBox(width: 8),

                                ChoiceChip(
                                  label: Text(l10n.delivered),
                                  selected: filtre == "DELIVREE",
                                  onSelected: (_) {
                                    setState(() {
                                      filtre = "DELIVREE";
                                    });
                                  },
                                ),

                                const SizedBox(width: 8),

                                ChoiceChip(
                                  label: Text(l10n.cancelled),
                                  selected: filtre == "ANNULEE",
                                  onSelected: (_) {
                                    setState(() {
                                      filtre = "ANNULEE";
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        Expanded(
                          child:
                              demandesFiltrees.isEmpty
                                  ? Center(child: Text(l10n.noRequestFound))
                                  : ListView.builder(
                                    padding: EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                      top: 16,
                                      bottom:
                                          MediaQuery.of(
                                            context,
                                          ).padding.bottom +
                                          100,
                                    ),

                                    itemCount: demandesFiltrees.length,

                                    itemBuilder: (context, index) {
                                      final demande = demandesFiltrees[index];

                                      Color statusColor;

                                      switch (demande.statut.toUpperCase()) {
                                        case "DELIVREE":
                                          statusColor = Colors.green;
                                          break;

                                        case "ANNULEE":
                                          statusColor = Colors.red;
                                          break;

                                        default:
                                          statusColor = Colors.orange;
                                      }

                                      return Card(
                                        margin: const EdgeInsets.only(
                                          bottom: 12,
                                        ),

                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),

                                        child: Padding(
                                          padding: const EdgeInsets.all(16),

                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,

                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 56,
                                                    height: 56,

                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFFC1121F,
                                                      ),

                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            18,
                                                          ),
                                                    ),

                                                    child: Center(
                                                      child: Text(
                                                        demande.groupeSanguin,

                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  const SizedBox(width: 14),

                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,

                                                      children: [
                                                        Text(
                                                          demande.centreNom,

                                                          maxLines: 2,

                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,

                                                          style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,

                                                                fontSize: 16,
                                                              ),
                                                        ),

                                                        const SizedBox(
                                                          height: 4,
                                                        ),

                                                        Text(
                                                          l10n.bloodRequest,

                                                          style: TextStyle(
                                                            color:
                                                                Colors
                                                                    .grey
                                                                    .shade600,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 8,
                                                        ),

                                                    decoration: BoxDecoration(
                                                      color: statusColor,

                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            30,
                                                          ),
                                                    ),

                                                    child: Text(
                                                      getStatusLabel(
                                                        demande.statut,
                                                      ),

                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 16),

                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.location_on,
                                                    size: 18,
                                                    color: Colors.grey,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(demande.ville),
                                                ],
                                              ),

                                              const SizedBox(height: 4),

                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.bloodtype,
                                                    size: 18,
                                                    color: Color(0xFFC1121F),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    '${l10n.quantity}: ${demande.quantite}',
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 4),

                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.calendar_month,
                                                    size: 18,
                                                    color: Colors.grey,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    "${demande.dateCreation.day}/${demande.dateCreation.month}/${demande.dateCreation.year}",
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                        ),
                      ],
                    );
                  },
                ),
              ),
    );
  }
}
