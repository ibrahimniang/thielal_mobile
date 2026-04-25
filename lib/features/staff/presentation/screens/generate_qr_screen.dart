import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/staff_controller.dart';
import '../../../../shared/widgets/app_loading_view.dart';

class QrGenerateScreen extends ConsumerStatefulWidget {
  const QrGenerateScreen({super.key});

  @override
  ConsumerState<QrGenerateScreen> createState() => _QrGenerateScreenState();
}

class _QrGenerateScreenState extends ConsumerState<QrGenerateScreen> {
  final TextEditingController userIdController = TextEditingController();

  @override
  void dispose() {
    userIdController.dispose();
    super.dispose();
  }

  Future<void> _generateQr() async {
    final text = userIdController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User ID requis")));
      return;
    }

    final userId = int.tryParse(text);

    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User ID invalide")));
      return;
    }

    await ref.read(staffControllerProvider.notifier).generateQr(userId);
  }

  Uint8List? _decodeBase64Qr(String? qrData) {
    if (qrData == null || qrData.isEmpty) return null;

    try {
      final base64String =
          qrData.contains(',') ? qrData.split(',').last : qrData;

      return base64Decode(base64String);
    } catch (_) {
      return null;
    }
  }

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: Colors.white.withOpacity(0.86),
            border: Border.all(color: Colors.white.withOpacity(0.76)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffControllerProvider);
    final qrState = state.generatedQr;
    final actionState = state.actionStatus;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text("Générer QR"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildGlassCard(
                  child: Column(
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.red.shade500, Colors.red.shade700],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.20),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.qr_code_2_rounded,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        "Créer un QR code donneur",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Entrez l'identifiant utilisateur pour générer un vrai QR code scannable.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: userIdController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "User ID",
                          hintText: "Ex: 12",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed:
                              actionState.isLoading
                                  ? null
                                  : () => _generateQr(),
                          child:
                              actionState.isLoading
                                  ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.4,
                                    ),
                                  )
                                  : const Text(
                                    "Générer QR",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                qrState.when(
                  loading:
                      () => const AppLoadingView(
                        message: 'Génération du QR code...',
                        size: 90,
                      ),
                  error:
                      (e, _) => _buildGlassCard(
                        child: const Text(
                          "Erreur génération QR",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  data: (qr) {
                    if (qr == null || qr.isEmpty) {
                      return const SizedBox();
                    }

                    final bytes = _decodeBase64Qr(qr);

                    if (bytes == null) {
                      return _buildGlassCard(
                        child: const Text(
                          "QR invalide ou impossible à afficher.",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    }

                    return _buildGlassCard(
                      child: Column(
                        children: [
                          const Text(
                            "QR Code généré",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Image.memory(
                              bytes,
                              width: 220,
                              height: 220,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            "Ce QR code est prêt à être scanné.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
