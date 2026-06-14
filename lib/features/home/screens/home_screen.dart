import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/config/env.dart';
import '../../../core/config/api_endpoints.dart';


import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';

import '../../auth/application/auth_controller.dart';

import '../../alerts/presentation/providers/alerts_provider.dart';
import '../../collectes/presentation/providers/collectes_provider.dart';
import '../../centers/application/centers_provider.dart';
import '../../donations/application/donation_controller.dart';
import '../../donors/presentation/providers/nearby_donors_provider.dart';

import '../../donations/presentation/screens/demande_sang_screen.dart';
import '../../donations/presentation/screens/donation_details_screen.dart';
import '../../../l10n/app_localizations.dart';

import '../widgets/home_drawer.dart';
import '../widgets/home_header.dart';
import '../widgets/live_map_section.dart';
import '../widgets/national_impact_section.dart';
import '../widgets/next_collection_section.dart';
import '../widgets/urgent_request_card.dart';
import '../widgets/information_ticker.dart';
import '../../auth/presentation/widgets/set_password_modal.dart';

// import '../widgets/nearby_donor_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // final TextEditingController _searchController = TextEditingController();
  int unreadCount = 0;
  int unreadMessages = 0;
  bool passwordModalShown = false;

@override
void initState() {
  super.initState();
  loadUnreadCount();
  loadUnreadMessages();
}

Future<void> loadUnreadMessages() async {
    try {
      final token = ref.read(authControllerProvider).accessToken;

      final res = await http.get(
        Uri.parse("${Env.baseUrl}${ApiEndpoints.unreadMessages}"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        setState(() {
          unreadMessages = data["count"] ?? 0;
        });
      }
    } catch (e) {
      debugPrint("❌ unread error => $e");
    }
  }

Future<void> loadUnreadCount() async {
  try {
    setState(() {
      unreadCount = 0;
    });

    debugPrint('💬 unreadCount => $unreadCount');
  } catch (e) {
    debugPrint('❌ loadUnreadCount error => $e');
  }
}

  String selectedGroup = 'Tous';


  final List<String> bloodFilters = ['Tous', 'O+', 'O-', 'A+', 'B+', 'AB+'];
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final searchController = TextEditingController();
  String searchQuery = '';

  

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authControllerProvider);

    final user = authState.currentUser;
  /// ======================================
/// PASSWORD REQUIRED MODAL
/// ======================================

WidgetsBinding.instance.addPostFrameCallback((_) {
  if (!mounted) return;

  /// déjà affiché
  if (passwordModalShown) return;

  final pendingUserId =
      authState.pendingUserId;

  /// pas onboarding
  if (pendingUserId == null) return;

  passwordModalShown = true;

  showDialog(
    context: context,

    barrierDismissible: false,

    builder: (_) {
      return SetPasswordModal(
        onSuccess: () async {
          /// CLEAR PENDING
          ref
              .read(
                authControllerProvider
                    .notifier,
              )
              .clearPendingUser();

          if (!mounted) return;

          ScaffoldMessenger.of(context)
              .showSnackBar(
            const SnackBar(
              content: Text(
                'Compte sécurisé avec succès 🔐',
              ),
            ),
          );
        },
      );
    },
  );
});

    final alertsAsync = ref.watch(alertsProvider);

    final collectesAsync = ref.watch(collectesProvider);

    final centersAsync = ref.watch(centersProvider);

    final myDonationsAsync = ref.watch(myDonationsProvider);

    /// ======================================
    /// NEARBY DONORS
    /// ======================================

    final nearbyDonorsAsync =
        searchQuery.trim().isEmpty
            ? null
            : ref.watch(
              nearbyDonorsProvider((
                ville: user?.ville ?? '',

                groupe: searchQuery.trim().toUpperCase(),

                latitude: user?.latitude ?? 0.0,

                longitude: user?.longitude ?? 0.0,
                utilisateurId: user?.idUtilisateur ?? 0,
              )),
            );

    /// DEBUG
    debugPrint('👤 USER CITY => ${user?.ville}');

    debugPrint('👤 USER LAT => ${user?.latitude}');

    debugPrint('👤 USER LNG => ${user?.longitude}');

    debugPrint('🩸 SEARCH QUERY => $searchQuery');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      drawer: HomeDrawer(firstName: user?.nom),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 12),

              /// =====================================================
              /// HEADER
              /// =====================================================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),

                child: Builder(
                  builder: (context) {
                    return HomeHeader(
                      unreadMessages: unreadMessages,
                      controller: searchController,

                      /// 🔥 prénom utilisateur
                      firstName: user?.nom,

                      /// 🔥 suggestions live
                      suggestions:
                          <String>[
                                /// ======================================
                                /// DONNEURS PROCHES
                                /// ======================================
                                ...nearbyDonorsAsync?.maybeWhen(
                                      data: (donors) {
                                        return donors
                                            .map(
                                              (d) =>
                                                  '🩸 ${d.prenom} ${d.nom} • ${d.groupeSanguin} • ${d.distance} km',
                                            )
                                            .cast<String>()
                                            .toList();
                                      },

                                      orElse: () => <String>[],
                                    ) ??
                                    [],

                                /// ======================================
                                /// CENTRES
                                /// ======================================
                                ...centersAsync.maybeWhen(
                                  data: (centers) {
                                    return centers
                                        .map<String>((c) => c.nom)
                                        .toList();
                                  },

                                  orElse: () => <String>[],
                                ),

                                /// ======================================
                                /// ALERTES
                                /// ======================================
                                ...alertsAsync.maybeWhen(
                                  data: (alerts) {
                                    return alerts
                                        .map<String>(
                                          (a) =>
                                              '${a.center?.name ?? a.city} - ${a.bloodGroup}',
                                        )
                                        .toList();
                                  },

                                  orElse: () => <String>[],
                                ),

                                /// ======================================
                                /// COLLECTES
                                /// ======================================
                                ...collectesAsync.maybeWhen(
                                  data: (collectes) {
                                    return collectes
                                        .map<String>((c) => c.title)
                                        .toList();
                                  },

                                  orElse: () => <String>[],
                                ),
                              ]
                              .where(
                                (item) =>
                                    item.toLowerCase().contains(searchQuery),
                              )
                              .toSet()
                              .toList(),

                      /// 🔥 SEARCH
                      onChanged: (value) {
                        debugPrint('🔍 SEARCH => $value');

                        setState(() {
                          searchQuery = value.toLowerCase();
                        });

                        debugPrint('🩸 CURRENT QUERY => $searchQuery');
                      },

                      /// 🔥 CLICK SUGGESTION
                      onSuggestionTap: (value) {
                        // debugPrint('✅ SUGGESTION => $value');

                        context.push(RouteNames.map, extra: value);
                      },

                      /// 🔥 MENU
                      onMenuTap: () {
                        Scaffold.of(context).openDrawer();
                      },

                      
                      onChatTap: () async {
                          await context.push('/conversations');

                          if (mounted) {
                            loadUnreadCount();
                          }
                        },

                      /// 🔥 PROFILE
                      onProfileTap: () {
                        context.push(RouteNames.profile);
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              /// =====================================================
              /// LIVE MAP
              /// =====================================================
              centersAsync.when(
                data: (centers) {
                  /// ==========================================
                  /// CENTRES DISPONIBLES
                  /// ==========================================

                  final displayCenters = centers;

                  /// ==========================================
                  /// PREMIER CENTRE
                  /// ==========================================

                  // final firstCenter =
                  //     displayCenters.isNotEmpty ? displayCenters.first : null;

                  return alertsAsync.when(
                    data: (alerts) {
                      return LiveMapSection(
                        /// 🔥 liste réelle centres backend
                        centers: displayCenters,

                        /// 🔥 urgences backend
                        urgentRequests: alerts.length,

                        /// 🔥 ville utilisateur
                        city:
                            (user?.ville != null &&
                                    user!.ville!.trim().isNotEmpty)
                                ? user.ville!
                                : 'Nouakchott',

                        /// 🔥 ouvrir grande map
                        onTap: () {
                          context.push(RouteNames.map);
                        },
                      );
                    },

                    loading:
                        () => const Center(child: CircularProgressIndicator()),

                    error: (e, _) {
                      return Center(child: Text(e.toString()));
                    },
                  );
                },

                loading: () => const Center(child: CircularProgressIndicator()),

                error: (e, _) {
                  return Center(child: Text(e.toString()));
                },
              ),

              const SizedBox(height: 24),

              /// =====================================================
              /// MAIN ACTION
              /// =====================================================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),

                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => const DemandeSangScreen(),
                      ),
                    );
                  },

                  child: Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(22),

                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE53946), Color(0xFFC1121F)],
                      ),

                      borderRadius: BorderRadius.circular(28),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.22),

                          blurRadius: 28,

                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),

                    child: Row(
                      children: [
                        Container(
                          height: 64,
                          width: 64,

                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.14),

                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.bloodtype_rounded,

                            color: Colors.white,

                            size: 34,
                          ),
                        ),

                        const SizedBox(width: 18),

                         Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                '',

                                style: TextStyle(
                                  color: Colors.white70,

                                  fontWeight: FontWeight.w700,

                                  letterSpacing: 1,
                                ),
                              ),

                              SizedBox(height: 8),

                              Text(
                                l10n.iNeedBlood,

                                style: TextStyle(
                                  color: Colors.white,

                                  fontSize: 22,

                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Icon(
                          Icons.arrow_forward_ios_rounded,

                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 26),

              /// =====================================================
              /// IMPACT NATIONAL
              /// =====================================================
              myDonationsAsync.when(
                data: (donations) {
                  return NationalImpactSection(
                    donations: donations.length,

                    livesSaved: donations.length * 3,

                    averageDelay: 38,

                    latestDonation:
                        donations.isNotEmpty ? donations.first : null,
                  );
                },

                loading: () => const Center(child: CircularProgressIndicator()),

                error: (e, _) {
                  return Center(child: Text(e.toString()));
                },
              ),

              /// =====================================================
              /// ALERTES + INFORMATIONS
              /// =====================================================
              alertsAsync.when(
                data: (alerts) {
                  return Column(
                    children: [
                      /// ======================================
                      /// HEADER
                      /// ======================================
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenPadding,
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                             Text(
                              l10n.urgentRequests,

                              style: TextStyle(
                                fontSize: 22,

                                fontWeight: FontWeight.w900,
                              ),
                            ),

                            TextButton(
                              onPressed: () {
                                context.push(RouteNames.alerts);
                              },

                              child:  Text(l10n.seeAll),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),
                    ],
                  );
                },

                loading: () => const SizedBox(),

                error: (_, __) => const SizedBox(),
              ),

              /// =====================================================
              /// FILTERS
              /// =====================================================
              SizedBox(
                height: 42,

                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),

                  scrollDirection: Axis.horizontal,

                  itemBuilder: (_, index) {
                    final filter = bloodFilters[index];

                    final selected = selectedGroup == filter;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGroup = filter;
                        });
                      },

                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 240),

                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),

                        decoration: BoxDecoration(
                          color: selected ? AppColors.primaryRed : Colors.white,

                          borderRadius: BorderRadius.circular(30),

                          border: Border.all(
                            color:
                                selected
                                    ? AppColors.primaryRed
                                    : Colors.grey.withOpacity(0.15),
                          ),
                        ),

                        child: Text(
                          filter,

                          style: TextStyle(
                            color: selected ? Colors.white : Colors.black87,

                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  },

                  separatorBuilder: (_, __) => const SizedBox(width: 10),

                  itemCount: bloodFilters.length,
                ),
              ),

              const SizedBox(height: 22),

              /// =====================================================
              /// ALERTS LIST
              /// =====================================================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),

                child: alertsAsync.when(
                  data: (alerts) {
                    final infoAlerts =
                        alerts.where((a) {
                          final type = a.type.trim().toLowerCase();

                          return type == 'info' || type == 'information';
                        }).toList();

                    /// ==========================================
                    /// FILTRAGE GROUPES
                    /// ==========================================

                    final userCity = user?.ville?.trim().toLowerCase() ?? '';

                    /// ==========================================
                    /// ALERTES DE LA VILLE UTILISATEUR
                    /// ==========================================

                    final cityAlerts =
                        alerts.where((a) {
                          final type = a.type.trim().toLowerCase();

                          final isInfo =
                              type == 'info' || type == 'information';

                          if (isInfo) return false;

                          final alertCity = a.city.trim().toLowerCase();

                          final matchGroup =
                              selectedGroup == 'Tous'
                                  ? true
                                  : a.bloodGroup.trim().toUpperCase() ==
                                      selectedGroup.trim().toUpperCase();

                          final pending =
                              a.status.trim().toLowerCase() == 'en attente';

                          return alertCity == userCity && matchGroup && pending;
                        }).toList();

                    /// ==========================================
                    /// FALLBACK NATIONAL
                    /// ==========================================

                    final filteredAlerts =
                        cityAlerts.isNotEmpty
                            ? cityAlerts
                            : alerts.where((a) {
                              final type = a.type.trim().toLowerCase();

                              final isInfo =
                                  type == 'info' || type == 'information';

                              if (isInfo) return false;

                              final matchGroup =
                                  selectedGroup == 'Tous'
                                      ? true
                                      : a.bloodGroup.trim().toUpperCase() ==
                                          selectedGroup.trim().toUpperCase();

                              final pending =
                                  a.status.trim().toLowerCase() == 'en attente';

                              return pending && matchGroup;
                            }).toList();

                    /// ==========================================
                    /// AUCUNE ALERTE
                    /// ==========================================

                    if (filteredAlerts.isEmpty) {
                      return  Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),

                          child: Text(l10n.noUrgencyAvailable),
                        ),
                      );
                    }

                    /// ==========================================
                    /// ALERTES BACKEND
                    /// ==========================================

                    return Column(
                      children:
                          filteredAlerts
                              .take(3)
                              .map(
                                (alert) => UrgentRequestCard(
                                  /// 🔥 BACKEND
                                  hospital: alert.center?.name ?? alert.city,

                                  bloodGroup: alert.bloodGroup,

                                  urgency:
                                      alert.type.toLowerCase() == 'urgent'
                                          ? 'Urgent'
                                          : 'Normal',

                                  quantity: '${alert.quantity ?? 1} poche(s)',

                                  distance:
                                      '${alert.city} • ${alert.quantity ?? 1} poche(s)',

                                  critical:
                                      alert.type.toLowerCase() == 'urgent',

                                  /// 🔥 ACTION
                                  onTap: () {
                                    /// ==========================================
                                    /// MESSAGE INDISPONIBILITÉ
                                    /// ==========================================

                                    if (user?.dateProchainDon != null) {
                                      final unavailable = DateTime.now()
                                          .isBefore(user!.dateProchainDon!);

                                      if (unavailable) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            behavior: SnackBarBehavior.floating,

                                            backgroundColor: Colors.orange,

                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),

                                            content: Text(
                                              'Vous êtes actuellement en période de récupération ❤️\n\nProchain don possible : ${user.dateProchainDon!.day}/${user.dateProchainDon!.month}/${user.dateProchainDon!.year}',
                                            ),

                                            duration: const Duration(
                                              seconds: 4,
                                            ),
                                          ),
                                        );
                                      }
                                    }

                                    /// ==========================================
                                    /// OUVERTURE ÉCRAN DÉTAIL
                                    /// ==========================================

                                    Navigator.push(
                                      context,

                                      MaterialPageRoute(
                                        builder:
                                            (_) => DonationDetailsScreen(
                                              alert: alert,

                                              user: user,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              )
                              .toList(),
                    );
                  },

                  loading:
                      () => const Center(child: CircularProgressIndicator()),

                  error: (e, _) {
                    return Center(child: Text(e.toString()));
                  },
                ),
              ),

              const SizedBox(height: 34),

              /// =====================================================
              /// COLLECTION
              /// =====================================================
              collectesAsync.when(
                data: (collectes) {
                  /// ==========================================
                  /// DEBUG USER
                  /// ==========================================

                  // debugPrint('👤 USER CITY => ${user?.ville}');

                  // debugPrint('📦 COLLECTES COUNT => ${collectes.length}');

                  /// ==========================================
                  /// VILLE UTILISATEUR
                  /// ==========================================

                  final userCity = user?.ville?.toLowerCase().trim() ?? '';

                  /// ==========================================
                  /// DEBUG COLLECTES
                  /// ==========================================

                  for (final c in collectes) {
                    // debugPrint('🩸 COLLECTE => ${c.title}');

                    // debugPrint('🏙️ CITY => ${c.city}');

                    // debugPrint('📍 STATUS => ${c.status}');
                  }

                  /// ==========================================
                  /// COLLECTES ACTIVES
                  /// ==========================================

                  /// ==========================================
                  /// COLLECTES VILLE UTILISATEUR
                  /// ==========================================

                  final cityCollectes =
                      collectes.where((c) {
                        final city = c.city.toLowerCase().trim();

                        final status = c.status.toLowerCase().trim();

                        final active = status == 'active';

                        return active && city.contains(userCity);
                      }).toList();

                  /// ==========================================
                  /// FALLBACK NATIONAL
                  /// ==========================================

                  final activeCollectes =
                      cityCollectes.isNotEmpty
                          ? cityCollectes
                          : collectes.where((c) {
                            final status = c.status.toLowerCase().trim();

                            return status == 'active';
                          }).toList();

                  /// ==========================================
                  /// DEBUG RESULT
                  /// ==========================================

                  debugPrint(
                    '🔥 ACTIVE COLLECTES => ${activeCollectes.length}',
                  );

                  /// ==========================================
                  /// AUCUNE COLLECTE
                  /// ==========================================

                  if (activeCollectes.isEmpty) {
                    debugPrint('❌ AUCUNE COLLECTE TROUVÉE');

                    return const SizedBox();
                  }

                  /// ==========================================
                  /// COLLECTE UTILISATEUR
                  /// ==========================================

                  final collecte = activeCollectes.first;

                  debugPrint('🚑 COLLECTE CHOISIE => ${collecte.title}');

                  /// ==========================================
                  /// UTILISATEUR DÉJÀ INSCRIT
                  /// ==========================================

                  final alreadyRegistered = collecte.inscriptions.any(
                    (i) => i['utilisateur_id'] == user?.idUtilisateur,
                  );

                  debugPrint('🩸 ALREADY REGISTERED => $alreadyRegistered');

                  return PremiumCollectionSection(
                    /// 🔥 BACKEND
                    title: collecte.title,

                    location: '${collecte.location}, ${collecte.city}',

                    date: collecte.date,

                    participants: collecte.participants,

                    maxPlaces: collecte.maxPlaces ?? 0,

                    /// 🔥 INSCRIPTION
                    alreadyRegistered: alreadyRegistered,

                    /// 🔥 ACTION
                    onTap: () async {
                      try {
                        debugPrint('🚀 PARTICIPATION START');

                        /// ======================================
                        /// API PARTICIPATION
                        /// ======================================

                        await ref
                            .read(collectesRepositoryProvider)
                            .participer(
                              collecteId: collecte.id,

                              utilisateurId: user!.idUtilisateur,
                            );

                        debugPrint('✅ PARTICIPATION SUCCESS');

                        if (!context.mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,

                            backgroundColor: Colors.green,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),

                            content: Text(
                              'Inscription à "${collecte.title}" réussie 🚑',
                            ),
                          ),
                        );

                        /// ======================================
                        /// REFRESH
                        /// ======================================

                        // ref.refresh(collectesProvider);
                      } catch (e) {
                        debugPrint('❌ PARTICIPATION ERROR => $e');

                        if (!context.mounted) {
                          return;
                        }

                        /// ======================================
                        /// DÉJÀ INSCRIT
                        /// ======================================

                        final message = e.toString();

                        final already = message.contains('Déjà inscrit');

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,

                            backgroundColor:
                                already ? Colors.orange : Colors.red,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),

                            content: Text(
                              already
                                  ? 'Vous êtes déjà inscrit à cette collecte 🚑'
                                  : 'Erreur lors de l’inscription',
                            ),
                          ),
                        );
                      }
                    },
                  );
                },

                loading: () => const Center(child: CircularProgressIndicator()),

                error: (e, _) {
                  debugPrint('❌ COLLECTES ERROR => $e');

                  return Center(child: Text(e.toString()));
                },
              ),

              
              /// =====================================================
              /// INFORMATIONS
              /// =====================================================
              alertsAsync.when(
                data: (alerts) {
                  final infoAlerts =
                      alerts.where((a) {
                        final type = a.type.trim().toLowerCase();

                        return type == 'info' || type == 'information';
                      }).toList();

                  /// AUCUNE INFO
                  if (infoAlerts.isEmpty) {
                    return const SizedBox();
                  }

                  /// PREMIÈRE INFO
                  final info = infoAlerts.first;

                  debugPrint('📢 INFO ALERT => ${info.message}');

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: InformationTicker(text: info.message),
                  );
                },

                loading: () => const SizedBox(),

                error: (_, __) => const SizedBox(),
              ),

              const SizedBox(height: 21),
            ],
            
          ),
        ),
      ),
    );
  }
}

