import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../../../core/config/api_endpoints.dart';
import '../../../../core/config/env.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../../l10n/app_localizations.dart';

class DemandeSangScreen extends ConsumerStatefulWidget {
  const DemandeSangScreen({super.key});

  @override
  ConsumerState<DemandeSangScreen> createState() => _DemandeSangScreenState();
}

class _DemandeSangScreenState extends ConsumerState<DemandeSangScreen> {
  /// ==========================================
  /// CONTROLLERS
  /// ==========================================

  final villeController = TextEditingController();

  String? selectedGroupe;

  int quantite = 1;

  bool isLoading = false;

  /// ==========================================
  /// GROUPES
  /// ==========================================

  final List<String> groupes = [
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-",
  ];

  /// ==========================================
  /// ENVOYER DEMANDE
  /// ==========================================

  Future<void> envoyerDemande() async {
    final l10n = AppLocalizations.of(context)!;
    if (selectedGroupe == null || villeController.text.trim().isEmpty) {
      _showErrorDialog(l10n.fillAllFields);

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final token = ref.read(authControllerProvider).accessToken;

      if (token == null || token.isEmpty) {
        throw Exception(l10n.sessionExpired);
      }

      final cleanToken = token.replaceAll("Bearer ", "");

      final response = await http.post(
        Uri.parse("${Env.baseUrl}${ApiEndpoints.demandeSang}"),

        headers: {
          "Content-Type": "application/json",

          "Accept": "application/json",

          "Authorization": "Bearer $cleanToken",
        },

        body: jsonEncode({
          "groupe_sanguin": selectedGroupe,

          "ville": villeController.text.trim(),

          "quantite": quantite,
        }),
      );

      debugPrint('🩸 STATUS => ${response.statusCode}');

      debugPrint('🩸 RESPONSE => ${response.body}');

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessDialog();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      debugPrint('❌ DEMANDE ERROR => $e');

      if (!mounted) return;

      _showErrorDialog(e.toString());
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  /// ==========================================
  /// SUCCESS DIALOG
  /// ==========================================

  void _showSuccessDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,

      barrierDismissible: false,

      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,

          child: Container(
            padding: const EdgeInsets.all(28),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(30),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                /// ICON
                Container(
                  height: 84,
                  width: 84,

                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.10),

                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.check_rounded,

                    color: Colors.green,

                    size: 46,
                  ),
                ),

                const SizedBox(height: 22),

                /// TITLE
                 Text(
                  l10n.requestSent,

                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),

                const SizedBox(height: 12),

                /// TEXT
                 Text(
                  l10n.nearbyDonorsAlerted,

                  textAlign: TextAlign.center,

                  style: TextStyle(color: Colors.grey, height: 1.5),
                ),

                const SizedBox(height: 26),

                /// BUTTON
                SizedBox(
                  width: double.infinity,

                  height: 54,

                  child: ElevatedButton(
                    onPressed: () {
                      /// 🔥 ferme uniquement le dialog
                      if (context.canPop()) {
                        context.pop();
                      }

                      /// 🔥 reset formulaire
                      setState(() {
                        selectedGroupe = null;

                        quantite = 1;

                        villeController.clear();
                      });
                    },

                    style: ElevatedButton.styleFrom(
                      elevation: 0,

                      backgroundColor: const Color(0xFFC1121F),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    child: Text(
                      l10n.continueText,

                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ==========================================
  /// ERROR DIALOG
  /// ==========================================

  void _showErrorDialog(String message) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,

      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),

          title: Text(l10n.error),

          content: Text(message),

          actions: [
            TextButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                }
              },

              child:  Text(l10n.ok),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    villeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        elevation: 0,

        backgroundColor: Colors.transparent,

        foregroundColor: Colors.black,

        centerTitle: true,

        title:  Text(
         l10n.urgentRequest,

          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// ======================================
            /// HEADER
            /// ======================================
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,

                  end: Alignment.bottomRight,

                  colors: [Color(0xFFE53946), Color(0xFFC1121F)],
                ),

                borderRadius: BorderRadius.circular(32),

                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.20),

                    blurRadius: 30,

                    offset: const Offset(0, 14),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),

                      borderRadius: BorderRadius.circular(16),
                    ),

                    child:  Text(
                     l10n.urgentNeed,

                      style: TextStyle(
                        color: Colors.white,

                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                   Text(
                   l10n.sendBloodRequest,

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 30,

                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 14),

                   Text(
                   l10n.donorsReceiveAlert,

                    style: TextStyle(
                      color: Colors.white70,

                      fontSize: 15,

                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            /// ======================================
            /// FORM
            /// ======================================
            Container(
              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(30),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),

                    blurRadius: 24,

                    offset: const Offset(0, 10),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  /// ==================================
                  /// GROUPES
                  /// ==================================
                   Text(
                    l10n.bloodGroup,

                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),

                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,

                    children:
                        groupes.map((groupe) {
                          final selected = selectedGroupe == groupe;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedGroupe = groupe;
                              });
                            },

                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),

                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,

                                vertical: 14,
                              ),

                              decoration: BoxDecoration(
                                color:
                                    selected
                                        ? const Color(0xFFC1121F)
                                        : const Color(0xFFF5F6FA),

                                borderRadius: BorderRadius.circular(18),
                              ),

                              child: Text(
                                groupe,

                                style: TextStyle(
                                  color:
                                      selected ? Colors.white : Colors.black87,

                                  fontWeight: FontWeight.w800,

                                  fontSize: 15,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 28),

                  /// ==================================
                  /// VILLE
                  /// ==================================
                   Text(
                   l10n.city,

                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),

                  const SizedBox(height: 14),

                  TextField(
                    controller: villeController,

                    decoration: InputDecoration(
                      hintText:l10n.enterYourCity,

                      prefixIcon: const Icon(Icons.location_on_rounded),

                      filled: true,

                      fillColor: const Color(0xFFF5F6FA),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),

                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// ==================================
                  /// QUANTITE
                  /// ==================================
                   Text(
                    l10n.requestedQuantity,

                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),

                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),

                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F6FA),

                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        /// MINUS
                        IconButton(
                          onPressed: () {
                            if (quantite > 1) {
                              setState(() {
                                quantite--;
                              });
                            }
                          },

                          icon: Container(
                            padding: const EdgeInsets.all(6),

                            decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius: BorderRadius.circular(12),
                            ),

                            child: const Icon(Icons.remove),
                          ),
                        ),

                        /// VALUE
                        Text(
                          "$quantite ${l10n.bags}",

                          style: const TextStyle(
                            fontSize: 18,

                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        /// PLUS
                        IconButton(
                          onPressed: () {
                            setState(() {
                              quantite++;
                            });
                          },

                          icon: Container(
                            padding: const EdgeInsets.all(6),

                            decoration: BoxDecoration(
                              color: const Color(0xFFC1121F),

                              borderRadius: BorderRadius.circular(12),
                            ),

                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 34),

            /// ======================================
            /// BUTTON
            /// ======================================
            SizedBox(
              width: double.infinity,

              height: 58,

              child: ElevatedButton(
                onPressed: isLoading ? null : envoyerDemande,

                style: ElevatedButton.styleFrom(
                  elevation: 0,

                  backgroundColor: const Color(0xFFC1121F),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),

                child:
                    isLoading
                        ? const SizedBox(
                          height: 24,
                          width: 24,

                          child: CircularProgressIndicator(color: Colors.white),
                        )
                        :  Text(
                          l10n.sendNow,

                          style: TextStyle(
                            fontSize: 16,

                            fontWeight: FontWeight.w800,
                          ),
                        ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
