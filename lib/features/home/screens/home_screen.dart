import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../auth/application/auth_controller.dart';
import '../../../core/services/location_service.dart';
import '../../../app/router/route_names.dart';

import '../widgets/emergency_banner.dart';
import '../widgets/blood_status_banner.dart';

import '../../donations/presentation/screens/demande_sang_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  Timer? _debounce;

  List<dynamic> donors = [];
  bool isSearching = false;

  final String baseUrl =
      "https://lifelink-backend-3bgr.onrender.com/api/dons/donneurs";

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      _searchDonors(value);
    });
  }

  Future<void> _searchDonors(String query) async {
    if (query.isEmpty) {
      setState(() {
        donors = [];
        isSearching = false;
      });
      return;
    }

    setState(() => isSearching = true);

    try {
      final user = ref.read(authControllerProvider).currentUser;

      final uri = Uri.parse(baseUrl).replace(queryParameters: {
        "ville": user?.ville ?? "",
        "groupe_sanguin": query,
      });

      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        setState(() {
          donors = data["data"] ?? [];
          isSearching = false;
        });
      } else {
        setState(() {
          donors = [];
          isSearching = false;
        });
      }
    } catch (_) {
      setState(() {
        donors = [];
        isSearching = false;
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.currentUser;

    final isSearchingMode = searchController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Row(
          children: [

            /// 👤 PROFILE
            GestureDetector(
              onTap: () => context.push(RouteNames.profile),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.red),
              ),
            ),

            const SizedBox(width: 10),

            /// 🔎 SEARCH BAR
            Expanded(
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: _onSearchChanged,
                  decoration: const InputDecoration(
                    hintText: "Rechercher donneur (O+, A+, ville...)",
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => context.push('/chatbot'),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const DemandeSangScreen(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            children: [

              /// ================= SEARCH RESULTS =================
              if (isSearchingMode)
                Expanded(
                  child: isSearching
                      ? const Center(child: CircularProgressIndicator())
                      : donors.isEmpty
                          ? const Center(
                              child: Text("Aucun donneur trouvé"),
                            )
                          : ListView.builder(
                              itemCount: donors.length,
                              itemBuilder: (context, index) {
                                final d = donors[index];

                                return Card(
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.bloodtype,
                                      color: Colors.red,
                                    ),
                                    title: Text(
                                      "${d['nom']} ${d['prenom']}",
                                    ),
                                    subtitle: Text(
                                      "Groupe: ${d['groupe_sanguin']}",
                                    ),
                                    trailing: const Icon(Icons.chat),
                                    onTap: () {
                                      context.push(
                                        '/chat/${d['id_utilisateur']}',
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                )

              /// ================= NORMAL HOME =================
              else
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          'Bienvenue',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),

                        const SizedBox(height: 8),

                        Text(
                          user?.fullName ?? 'Utilisateur',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),

                        const SizedBox(height: 20),

                        EmergencyBanner(
                          title: 'Urgence don de sang',
                          description:
                              'Aidez rapidement en consultant les demandes urgentes.',
                          onTap: () =>
                              context.push(RouteNames.donations),
                        ),

                        const SizedBox(height: 20),

                        BloodStatusBanner(
                          bloodGroup:
                              user?.groupeSanguin ?? 'Non défini',
                          status: user?.statutGroupeSanguin == 'verifie'
                              ? 'Vérifié'
                              : 'Non vérifié',
                          statusColor:
                              user?.statutGroupeSanguin == 'verifie'
                                  ? Colors.green
                                  : Colors.orange,
                        ),

                        const SizedBox(height: 24),

                        /// 🔥 TES GRIDS RESTENT ICI (NON TOUCHÉ)
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.1,
                          children: [

                            _gridItem(
                              icon: Icons.favorite,
                              title: "Mes dons",
                              color: Colors.red,
                              onTap: () =>
                                  context.push(RouteNames.donations),
                            ),

                            _gridItem(
                              icon: Icons.workspace_premium,
                              title: "Certificats",
                              color: Colors.deepPurple,
                              onTap: () => context.push('/certificats'),
                            ),

                            _gridItem(
                              icon: Icons.location_on,
                              title: "Centres",
                              color: Colors.blue,
                              onTap: () =>
                                  context.push(RouteNames.centers),
                            ),

                            _gridItem(
                              icon: Icons.notifications,
                              title: "Notifications",
                              color: Colors.orange,
                              onTap: () => context.push(
                                  RouteNames.notifications),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gridItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.9),
              color.withOpacity(0.6),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 34),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}