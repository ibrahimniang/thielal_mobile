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

class StaffDashboardScreen extends ConsumerStatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  ConsumerState<StaffDashboardScreen> createState() =>
      _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends ConsumerState<StaffDashboardScreen> {
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
        title: const Text("Staff Dashboard"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refresh),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text('Déconnexion'),
                      content: const Text(
                        'Voulez-vous vraiment vous déconnecter ?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Annuler'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Déconnexion'),
                        ),
                      ],
                    ),
              );

              if (confirmed == true) {
                await ref.read(authControllerProvider.notifier).logout();
                if (!mounted) return;
                context.go(RouteNames.loginUser);
              }
            },
          ),
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
                "Bienvenue Staff 👨‍⚕️",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: "Demandes",
                      value: state.bloodRequests.when(
                        data: (d) => "${d.length}",
                        loading: () => "...",
                        error: (_, __) => "0",
                      ),
                      icon: Icons.warning,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      title: "Donneurs",
                      value:
                          hasNearbyParams
                              ? state.nearbyDonors.when(
                                data: (d) => "${d.length}",
                                loading: () => "...",
                                error: (_, __) => "0",
                              )
                              : "--",
                      icon: Icons.people,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: "Stock",
                      value: state.bloodStock.when(
                        data: (d) => "${d.length}",
                        loading: () => "...",
                        error: (_, __) => "0",
                      ),
                      icon: Icons.water_drop,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: StatCard(
                      title: "QR",
                      value: "OK",
                      icon: Icons.qr_code,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              const Text(
                "Actions rapides",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              DashboardCard(
                title: "Demandes de sang",
                subtitle: "Gérer les demandes urgentes",
                icon: Icons.local_hospital,
                color: Colors.red,
                onTap: () => context.push(RouteNames.staffRequests),
              ),

              const SizedBox(height: 10),

              DashboardCard(
                title: "Donneurs proches",
                subtitle:
                    hasNearbyParams
                        ? "Voir les donneurs disponibles"
                        : "Localisation utilisateur incomplète",
                icon: Icons.location_on,
                color: Colors.blue,
                onTap: () => context.push(RouteNames.staffDonors),
              ),

              const SizedBox(height: 10),

              DashboardCard(
                title: "Stock de sang",
                subtitle: "Gestion du stock",
                icon: Icons.water_drop,
                color: Colors.green,
                onTap: () => context.push(RouteNames.bloodStock),
              ),

              const SizedBox(height: 10),

              DashboardCard(
                title: "Scanner QR",
                subtitle: "Scanner un donneur",
                icon: Icons.qr_code_scanner,
                color: Colors.orange,
                onTap: () => context.push(RouteNames.qrScan),
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
                title: "Générer QR",
                subtitle: "Créer un QR code",
                icon: Icons.qr_code,
                color: Colors.purple,
                onTap: () => context.push(RouteNames.qrGenerate),
              ),

              const SizedBox(height: 25),

              const Text(
                "Aperçu stock",
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
                        data.map((s) {
                          return BloodGroupChip(
                            group: s.group ?? "N/A",
                            count: s.quantity ?? 0,
                          );
                        }).toList(),
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
