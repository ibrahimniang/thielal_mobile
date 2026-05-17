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
import '../../../../core/config/env.dart';

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

  // 🔥 badge messages non lus
  int unreadCount = 0;

  final String baseUrl =
      "https://lifelink-backend-3bgr.onrender.com/api/dons/donneurs";

  @override
  void initState() {
    super.initState();
    loadUnreadCount();
  }

  Future<void> loadUnreadCount() async {
    try {
      final token = ref.read(authControllerProvider).accessToken;

      final res = await http.get(
        Uri.parse("${Env.baseUrl}/chat/unread-count"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        setState(() {
          unreadCount = data["count"] ?? 0;
        });
      }
    } catch (e) {
      debugPrint("Erreur unread count: $e");
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(
      const Duration(milliseconds: 400),
      () {
        _searchDonors(value);
      },
    );
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

      final uri = Uri.parse(baseUrl).replace(
        queryParameters: {
          "ville": user?.ville ?? "",
          "groupe_sanguin": query,
        },
      );

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

    final isSearchingMode =
        searchController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => context.push(
                RouteNames.profile,
              ),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Colors.red,
                ),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: _onSearchChanged,
                  decoration: const InputDecoration(
                    hintText:
                        "Rechercher donneur (O+, A+, ville...)",
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.search,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () async {
              await context.push('/conversations');
              loadUnreadCount();
            },
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.chat_bubble_outline),

                if (unreadCount > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(5),

                      // 🔥 FIX ICI : badge rouge
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),

                      child: Text(
                        unreadCount > 9
                            ? "9+"
                            : "$unreadCount",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
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
          padding: const EdgeInsets.all(
            AppSpacing.screenPadding,
          ),
          child: Column(
            children: [
              if (isSearchingMode)
                Expanded(
                  child: isSearching
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
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
              else
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bienvenue',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user?.fullName ?? 'Utilisateur',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge,
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
                          status:
                              user?.statutGroupeSanguin == 'verifie'
                                  ? 'Vérifié'
                                  : 'Non vérifié',
                          statusColor:
                              user?.statutGroupeSanguin == 'verifie'
                                  ? Colors.green
                                  : Colors.orange,
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
}