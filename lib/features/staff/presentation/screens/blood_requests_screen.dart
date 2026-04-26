import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_loading_view.dart';
import '../../application/staff_controller.dart';
import '../../data/models/blood_request_model.dart';

class BloodRequestsScreen extends ConsumerStatefulWidget {
  const BloodRequestsScreen({super.key});

  @override
  ConsumerState<BloodRequestsScreen> createState() =>
      _BloodRequestsScreenState();
}

class _BloodRequestsScreenState extends ConsumerState<BloodRequestsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(staffControllerProvider.notifier).loadBloodRequests();
    });
  }

  Future<void> _refresh() async {
    await ref.read(staffControllerProvider.notifier).loadBloodRequests();
  }

  Future<void> _updateStatusDialog(BloodRequestModel request) async {
    String selectedStatus = request.status;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final loading =
                ref.watch(staffControllerProvider).actionStatus.isLoading;

            return AlertDialog(
              title: const Text("Mettre à jour le statut"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Demande pour le groupe ${request.bloodGroup}",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    items: const [
                      DropdownMenuItem(
                        value: "pending",
                        child: Text("En attente"),
                      ),
                      DropdownMenuItem(
                        value: "approved",
                        child: Text("Approuvée"),
                      ),
                      DropdownMenuItem(
                        value: "rejected",
                        child: Text("Rejetée"),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setModalState(() {
                          selectedStatus = value;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: "Nouveau statut",
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed:
                      loading ? null : () => Navigator.pop(dialogContext),
                  child: const Text("Annuler"),
                ),
                ElevatedButton(
                  onPressed:
                      loading
                          ? null
                          : () async {
                            await ref
                                .read(staffControllerProvider.notifier)
                                .updateBloodRequestStatus(
                                  requestId: request.id,
                                  status: selectedStatus,
                                );

                            if (!mounted) return;

                            final state = ref.read(staffControllerProvider);

                            state.actionStatus.whenOrNull(
                              data: (_) {
                                Navigator.pop(dialogContext);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Statut mis à jour avec succès",
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              error: (e, _) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.toString()),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              },
                            );
                          },
                  child:
                      loading
                          ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text("Enregistrer"),
                ),
              ],
            );
          },
        );
      },
    );
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
                  Icons.bloodtype_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Demandes de sang",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                "Consultez les demandes en attente et mettez à jour leur statut rapidement.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Approuvée';
      case 'rejected':
        return 'Rejetée';
      case 'pending':
        return 'En attente';
      default:
        return status;
    }
  }

  Widget _buildRequestCard(BloodRequestModel request) {
    final statusColor = _statusColor(request.status);

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
                  child: const Icon(Icons.bloodtype, color: Colors.red),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    request.bloodGroup,
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
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    _statusLabel(request.status),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            _infoRow(
              icon: Icons.person_outline,
              label: "Patient",
              value: request.patientName ?? "Patient inconnu",
            ),
            const SizedBox(height: 8),
            _infoRow(
              icon: Icons.calendar_today_outlined,
              label: "Date",
              value:
                  request.createdAt != null
                      ? "${request.createdAt!.day.toString().padLeft(2, '0')}/"
                          "${request.createdAt!.month.toString().padLeft(2, '0')}/"
                          "${request.createdAt!.year}"
                      : "--",
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _updateStatusDialog(request),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.edit),
                label: const Text(
                  "Changer le statut",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
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
    final requests = state.bloodRequests;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text("Demandes de sang"),
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
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: requests.when(
            loading:
                () =>
                    const AppLoadingView(message: 'Chargement des demandes...'),
            error:
                (e, _) => ListView(
                  children: [
                    const SizedBox(height: 120),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          "Erreur lors du chargement des demandes",
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
            data: (data) {
              if (data.isEmpty) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildHeaderCard(),
                    const SizedBox(height: 50),
                    const Center(
                      child: Text(
                        "Aucune demande disponible",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: data.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  if (index == 0) return _buildHeaderCard();
                  final request = data[index - 1];
                  return _buildRequestCard(request);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
