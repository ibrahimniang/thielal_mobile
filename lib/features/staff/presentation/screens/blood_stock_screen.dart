import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../shared/widgets/app_loading_view.dart';
import '../../../auth/application/auth_controller.dart';

class BloodStockScreen extends ConsumerStatefulWidget {
  const BloodStockScreen({super.key});

  @override
  ConsumerState<BloodStockScreen> createState() => _BloodStockScreenState();
}

class _BloodStockScreenState extends ConsumerState<BloodStockScreen> {
  final Dio _dio = ApiClient().dio;

  bool _loading = true;
  bool _updating = false;
  String? _errorMessage;

  List<Map<String, dynamic>> _stocks = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadStocks);
  }

  Future<void> _loadStocks() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final authState = ref.read(authControllerProvider);
      final user = authState.currentUser;
      final roleId = user?.roleId;
      final centreId = user?.centreId;

      Response response;

      // ✅ Admin peut voir tous les stocks
      if (roleId == 1) {
        response = await _dio.get(
          'https://lifelink-backend-3bgr.onrender.com/api/banque',
        );
      } else {
        // ✅ Staff / Directeur : stock de leur centre
        if (centreId == null) {
          throw Exception("Centre introuvable pour cet utilisateur");
        }

        response = await _dio.get(
          'https://lifelink-backend-3bgr.onrender.com/api/banque/centre/$centreId',
        );
      }

      final payload = response.data;
      final rawList = payload['data'];

      if (rawList is List) {
        _stocks =
            rawList.map<Map<String, dynamic>>((item) {
              return Map<String, dynamic>.from(item as Map);
            }).toList();
      } else {
        _stocks = [];
      }

      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _openUpdateStockDialog({
    Map<String, dynamic>? existingStock,
  }) async {
    final authState = ref.read(authControllerProvider);
    final user = authState.currentUser;
    final roleId = user?.roleId;

    final centreIdController = TextEditingController(
      text:
          roleId == 1
              ? (existingStock?['centre_id']?.toString() ?? '')
              : (user?.centreId?.toString() ?? ''),
    );

    final quantityController = TextEditingController(
      text:
          existingStock?['quantite']?.toString() ??
          existingStock?['quantity']?.toString() ??
          '',
    );

    String? selectedGroup =
        existingStock?['groupe_sanguin']?.toString() ??
        existingStock?['group']?.toString();

    final bloodGroups = const [
      'O+',
      'O-',
      'A+',
      'A-',
      'B+',
      'B-',
      'AB+',
      'AB-',
    ];

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text(
                existingStock == null
                    ? 'Ajouter / Mettre à jour stock'
                    : 'Modifier stock',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (roleId == 1) ...[
                      TextField(
                        controller: centreIdController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Centre ID',
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    DropdownButtonFormField<String>(
                      value: selectedGroup,
                      items:
                          bloodGroups
                              .map(
                                (g) =>
                                    DropdownMenuItem(value: g, child: Text(g)),
                              )
                              .toList(),
                      onChanged: (value) {
                        setModalState(() {
                          selectedGroup = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Groupe sanguin',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Quantité'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed:
                      _updating ? null : () => Navigator.pop(dialogContext),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed:
                      _updating
                          ? null
                          : () async {
                            final centreId = int.tryParse(
                              centreIdController.text.trim(),
                            );
                            final quantity = int.tryParse(
                              quantityController.text.trim(),
                            );

                            if (selectedGroup == null ||
                                selectedGroup!.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Choisissez un groupe sanguin'),
                                ),
                              );
                              return;
                            }

                            if (centreId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Centre ID invalide'),
                                ),
                              );
                              return;
                            }

                            setState(() => _updating = true);

                            try {
                              await _dio.post(
                                'https://lifelink-backend-3bgr.onrender.com/api/banque',
                                data: {
                                  'centre_id': centreId,
                                  'groupe_sanguin': selectedGroup,
                                  'quantite': quantity ?? 0,
                                },
                              );

                              if (!mounted) return;
                              Navigator.pop(dialogContext);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Stock mis à jour avec succès'),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              await _loadStocks();
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } finally {
                              if (mounted) {
                                setState(() => _updating = false);
                              }
                            }
                          },
                  child:
                      _updating
                          ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text('Enregistrer'),
                ),
              ],
            );
          },
        );
      },
    );

    centreIdController.dispose();
    quantityController.dispose();
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
                  Icons.water_drop_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Stock de sang",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                "Consultez et mettez à jour le stock disponible selon votre centre.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockCard(Map<String, dynamic> stock) {
    final group =
        stock['groupe_sanguin']?.toString() ??
        stock['group']?.toString() ??
        'Inconnu';

    final quantity =
        stock['quantite'] ?? stock['quantity'] ?? stock['stock'] ?? 0;

    final centreId = stock['centre_id']?.toString() ?? '--';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.red.shade50,
          child: const Icon(Icons.water_drop, color: Colors.red),
        ),
        title: Text(group, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Centre: $centreId'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$quantity',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () => _openUpdateStockDialog(existingStock: stock),
              icon: const Icon(Icons.edit, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final roleId = authState.currentUser?.roleId;
    final canManageStock = roleId == 1 || roleId == 3 || roleId == 4;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text("Stock de sang"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: _loadStocks, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton:
          canManageStock
              ? FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () => _openUpdateStockDialog(),
                child: const Icon(Icons.add),
              )
              : null,
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
          onRefresh: _loadStocks,
          child:
              _loading
                  ? const AppLoadingView(message: 'Chargement du stock...')
                  : _errorMessage != null
                  ? ListView(
                    children: [
                      const SizedBox(height: 120),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                  : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildHeaderCard(),
                      const SizedBox(height: 20),
                      if (_stocks.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text(
                              "Aucun stock disponible",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      else
                        ..._stocks.map(_buildStockCard),
                    ],
                  ),
        ),
      ),
    );
  }
}
