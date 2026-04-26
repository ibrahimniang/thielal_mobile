import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_loading_view.dart';
import '../../../../app/router/route_names.dart';
import '../../../auth/application/auth_controller.dart';
import '../../application/staff_controller.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/blood_group_chip.dart';
import '../widgets/verify_blood_group_modal.dart';

class DirectorDashboardScreen extends ConsumerStatefulWidget {
  const DirectorDashboardScreen({super.key});

  @override
  ConsumerState<DirectorDashboardScreen> createState() =>
      _DirectorDashboardScreenState();
}

class _DirectorDashboardScreenState
    extends ConsumerState<DirectorDashboardScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await _loadDashboardData();
    });
  }

  Future<void> _loadDashboardData() async {
    final controller = ref.read(staffControllerProvider.notifier);
    final authState = ref.read(authControllerProvider);
    final user = authState.currentUser;

    final futures = <Future<void>>[
      controller.loadBloodRequests(),
      controller.loadBloodStock(),
    ];

    final hasNearbyParams =
        user?.ville != null &&
        user!.ville!.isNotEmpty &&
        user.groupeSanguin != null &&
        user.groupeSanguin!.isNotEmpty &&
        user.latitude != null &&
        user.longitude != null;

    if (hasNearbyParams) {
      futures.add(
        controller.loadNearbyDonors(
          ville: user.ville!,
          groupe: user.groupeSanguin!,
          latitude: user.latitude!,
          longitude: user.longitude!,
        ),
      );
    }

    await Future.wait(futures);
  }

  Future<void> _refresh() async {
    await _loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffControllerProvider);
    final authState = ref.watch(authControllerProvider);
    final user = authState.currentUser;

    final hasNearbyParams =
        user?.ville != null &&
        user!.ville!.isNotEmpty &&
        user.groupeSanguin != null &&
        user.groupeSanguin!.isNotEmpty &&
        user.latitude != null &&
        user.longitude != null;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Director Dashboard"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              context.push(RouteNames.notifications);
            },
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refresh),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Bienvenue Directeur 👨‍⚕️",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: "Donneurs",
                      value:
                          hasNearbyParams
                              ? state.nearbyDonors.maybeWhen(
                                data: (d) => "${d.length}",
                                loading: () => "...",
                                orElse: () => "0",
                              )
                              : "--",
                      icon: Icons.people,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      title: "Dons",
                      value: state.bloodRequests.maybeWhen(
                        data: (d) => "${d.length}",
                        loading: () => "...",
                        orElse: () => "0",
                      ),
                      icon: Icons.bloodtype,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              const Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: "Staff",
                      value: "18",
                      icon: Icons.badge,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      title: "Demandes",
                      value: "32",
                      icon: Icons.warning,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              const Text(
                "Gestion rapide",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              DashboardCard(
                title: "Créer un Staff",
                subtitle: "Ajouter un nouveau membre staff",
                icon: Icons.person_add,
                color: Colors.blue,
                onTap: () {
                  context.push(RouteNames.createStaff);
                },
              ),

              const SizedBox(height: 10),

              DashboardCard(
                title: "Demandes de sang",
                subtitle: "Voir et gérer les demandes urgentes",
                icon: Icons.local_hospital,
                color: Colors.red,
                onTap: () {
                  context.push(RouteNames.staffRequests);
                },
              ),

              const SizedBox(height: 10),

              DashboardCard(
                title: "Donneurs proches",
                subtitle:
                    hasNearbyParams
                        ? "Localisation des donneurs disponibles"
                        : "Localisation utilisateur incomplète",
                icon: Icons.location_on,
                color: Colors.green,
                onTap: () {
                  context.push(RouteNames.staffDonors);
                },
              ),

              const SizedBox(height: 10),

              DashboardCard(
                title: "Vérifier groupe sanguin",
                subtitle: "Valider ou corriger le groupe d’un utilisateur",
                icon: Icons.verified_user,
                color: Colors.teal,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => const VerifyBloodGroupModal(),
                  );
                },
              ),

              DashboardCard(
                title: "Stock de sang",
                subtitle: "Gestion des groupes sanguins",
                icon: Icons.water_drop,
                color: Colors.redAccent,
                onTap: () {
                  context.push(RouteNames.bloodStock);
                },
              ),

              const SizedBox(height: 25),

              const Text(
                "Stock de sang",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              state.bloodStock.when(
                loading:
                    () =>
                        const AppLoadingView(message: 'Chargement du stock...'),
                error: (e, _) => Text("Erreur stock: $e"),
                data: (data) {
                  if (data.isEmpty) {
                    return const Text("Aucun stock disponible");
                  }

                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        data
                            .map(
                              (s) => BloodGroupChip(
                                group: s.group ?? "N/A",
                                count: s.quantity ?? 0,
                              ),
                            )
                            .toList(),
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
