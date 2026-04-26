import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_loading_view.dart';
import '../../../auth/application/auth_controller.dart';
import '../../application/staff_controller.dart';
import '../../data/models/donor_model.dart';

class NearbyDonorsScreen extends ConsumerStatefulWidget {
  const NearbyDonorsScreen({super.key});

  @override
  ConsumerState<NearbyDonorsScreen> createState() => _NearbyDonorsScreenState();
}

class _NearbyDonorsScreenState extends ConsumerState<NearbyDonorsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      _loadDonors();
    });
  }

  Future<void> _loadDonors() async {
    final authState = ref.read(authControllerProvider);
    final user = authState.currentUser;

    final ville = user?.ville;
    final groupe = user?.groupeSanguin;
    final latitude = user?.latitude;
    final longitude = user?.longitude;

    if (ville == null ||
        ville.isEmpty ||
        groupe == null ||
        groupe.isEmpty ||
        latitude == null ||
        longitude == null) {
      return;
    }

    await ref
        .read(staffControllerProvider.notifier)
        .loadNearbyDonors(
          ville: ville,
          groupe: groupe,
          latitude: latitude,
          longitude: longitude,
        );
  }

  Future<void> _refresh() async {
    await _loadDonors();
  }

  Widget _buildHeaderCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.94),
                Colors.red.shade50.withOpacity(0.88),
                Colors.blue.shade50.withOpacity(0.78),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.78),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.08),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.red.shade500, Colors.red.shade700],
                  ),
                ),
                child: const Icon(
                  Icons.people_alt_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Donneurs proches",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                "Consultez les donneurs disponibles à proximité selon votre localisation et votre groupe sanguin.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMissingDataCard() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeaderCard(),
        const SizedBox(height: 24),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              children: [
                Icon(Icons.info_outline, color: Colors.orange, size: 34),
                SizedBox(height: 12),
                Text(
                  "Informations insuffisantes",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  "La ville, le groupe sanguin ou la localisation de l'utilisateur connecté sont manquants. Impossible de rechercher les donneurs proches.",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDonorCard(DonorModel donor) {
    final distanceText =
        donor.distance != null
            ? "${donor.distance!.toStringAsFixed(2)} km"
            : "--";

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.red.shade50,
                  child: const Icon(Icons.person, color: Colors.red),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    donor.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    distanceText,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _infoRow(
              icon: Icons.phone_outlined,
              label: "Téléphone",
              value: donor.phone ?? "--",
            ),
            const SizedBox(height: 8),
            _infoRow(
              icon: Icons.bloodtype_outlined,
              label: "Groupe sanguin",
              value: donor.bloodGroup.isEmpty ? "--" : donor.bloodGroup,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade700),
        const SizedBox(width: 8),
        Text(
          "$label : ",
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w700,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffControllerProvider);
    final authState = ref.watch(authControllerProvider);
    final donorsState = state.nearbyDonors;

    final user = authState.currentUser;
    final hasRequiredData =
        user?.ville != null &&
        user!.ville!.isNotEmpty &&
        user.groupeSanguin != null &&
        user.groupeSanguin!.isNotEmpty &&
        user.latitude != null &&
        user.longitude != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text("Donneurs proches"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.red.shade50.withOpacity(0.55),
              Colors.green.shade50.withOpacity(0.30),
              Colors.blue.shade50.withOpacity(0.42),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child:
            !hasRequiredData
                ? _buildMissingDataCard()
                : RefreshIndicator(
                  onRefresh: _refresh,
                  child: donorsState.when(
                    loading:
                        () => const AppLoadingView(
                          message: 'Chargement des donneurs...',
                        ),
                    error:
                        (e, _) => ListView(
                          children: [
                            const SizedBox(height: 120),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Text(
                                  "Erreur chargement donneurs",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    data: (donors) {
                      if (donors.isEmpty) {
                        return ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            _buildHeaderCard(),
                            const SizedBox(height: 50),
                            const Center(
                              child: Text(
                                "Aucun donneur disponible",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        );
                      }

                      return ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: donors.length + 1,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          if (index == 0) return _buildHeaderCard();
                          final donor = donors[index - 1];
                          return _buildDonorCard(donor);
                        },
                      );
                    },
                  ),
                ),
      ),
    );
  }
}
