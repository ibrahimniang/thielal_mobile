import 'dart:convert';

import 'dart:math' as math;
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
  ConsumerState<DemandeSangScreen> createState() =>
      _DemandeSangScreenState();
}

class _DemandeSangScreenState
    extends ConsumerState<DemandeSangScreen> {

  /// ==========================================
  /// CONTROLLERS
  /// ==========================================

  final villeController = TextEditingController();


  String? selectedGroupe;

  int quantite = 1;

  bool isLoading = false;

  /// ==========================================
  /// CENTRES
  /// ==========================================

  List<Map<String, dynamic>> centres = [];


  Map<String, dynamic>? selectedCentre;

  bool loadingCentres = true;

  /// ==========================================
  /// VILLES MAURITANIE
  /// ==========================================

  final List<String> mauritanieVilles = [
    "Nouakchott",
    "Nouadhibou",
    "Rosso",
    "Kaédi",
    "Kiffa",
    "Sélibaby",
    "Atar",
    "Zouerate",
    "Aioun",
    "Néma",
    "Aleg",
    "Akjoujt",
    "Tidjikja",
    "Boghé",
    "Boutilimit",
  ];

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

  @override
  void initState() {
    super.initState();

    chargerCentres();
  }

  /// ==========================================
  /// DISTANCE ENTRE USER ET CENTRE
  /// ==========================================

  double calculateDistance(
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  const p = 0.017453292519943295;

  final a =
      0.5 -
      math.cos((lat2 - lat1) * p) / 2 +
      math.cos(lat1 * p) *
          math.cos(lat2 * p) *
          (1 -
                  math.cos(
                    (lon2 - lon1) * p,
                  )) /
              2;

  return 12742 *
      math.asin(math.sqrt(a));
}

  /// ==========================================
  /// CHARGER CENTRES
  /// ==========================================

  Future<void> chargerCentres() async {
    try {
      final token =
          ref.read(authControllerProvider).accessToken;

      final response = await http.get(
        Uri.parse("${Env.baseUrl}/centres"),

        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      debugPrint(
        "🏥 CENTRES STATUS => ${response.statusCode}",
      );

      debugPrint(
        "🏥 CENTRES BODY => ${response.body}",
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200 &&
          data["success"] == true) {

        List<Map<String, dynamic>> centresData =
          List<Map<String, dynamic>>.from(
            data["data"],
          );

        /// ==========================================
        /// TRI CENTRES PLUS PROCHES
        /// ==========================================

        final currentUser =
           ref.read(authControllerProvider).currentUser;

        final userLat =
            currentUser?.latitude;

        final userLng =
            currentUser?.longitude;

        if (userLat != null &&
            userLng != null) {

          for (var centre in centresData) {

            final centreLat =
                centre["latitude"];

            final centreLng =
                centre["longitude"];

            if (centreLat != null &&
                centreLng != null) {

              centre["distance"] =
                  calculateDistance(
                userLat.toDouble(),
                userLng.toDouble(),
                centreLat.toDouble(),
                centreLng.toDouble(),
              );
            } else {
              centre["distance"] = 9999;
            }
          }

          centresData.sort(
            (a, b) =>
                (a["distance"] as double)
                    .compareTo(
              b["distance"] as double,
            ),
          );
        }

        setState(() {
          centres = centresData;
          loadingCentres = false;
        });

      } else {
        setState(() {
          loadingCentres = false;
        });
      }
    } catch (e) {
      debugPrint("❌ ERREUR CENTRES => $e");

      if (!mounted) return;

      setState(() {
        loadingCentres = false;
      });
    }
  }

 
  /// ==========================================
  /// ENVOYER DEMANDE
  /// ==========================================

  Future<void> envoyerDemande() async {
    final l10n = AppLocalizations.of(context)!;

    if (selectedGroupe == null ||
        villeController.text.trim().isEmpty ||
        selectedCentre == null) {
      _showErrorDialog(l10n.fillAllFields);

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final token =
          ref.read(authControllerProvider).accessToken;

      if (token == null || token.isEmpty) {
        throw Exception(l10n.sessionExpired);
      }

      final cleanToken =
          token.replaceAll("Bearer ", "");

      final response = await http.post(
        Uri.parse(
          "${Env.baseUrl}${ApiEndpoints.demandeSang}",
        ),

        headers: {
          "Content-Type": "application/json",

          "Accept": "application/json",

          "Authorization":
              "Bearer $cleanToken",
        },

        body: jsonEncode({
          "groupe_sanguin": selectedGroupe,

          "ville":
              villeController.text.trim(),

          "quantite": quantite,

          "centre_id":
              selectedCentre?["id_centre"],
        }),
      );

      debugPrint(
        '🩸 STATUS => ${response.statusCode}',
      );

      debugPrint(
        '🩸 RESPONSE => ${response.body}',
      );

      if (!mounted) return;

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        _showSuccessDialog();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      debugPrint(
        '❌ DEMANDE ERROR => $e',
      );

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
     final isDark =
      Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,

      barrierDismissible: false,

      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,

          child: Container(
            padding: const EdgeInsets.all(28),

            decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E293B)
                : Colors.white,

              borderRadius:
                  BorderRadius.circular(30),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [

                /// ICON
                Container(
                  height: 84,
                  width: 84,

                  decoration: BoxDecoration(
                    color: Colors.green
                        .withOpacity(0.10),

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

                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 12),

                /// TEXT
                Text(
                  l10n.nearbyDonorsAlerted,

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 26),

                /// BUTTON
                SizedBox(
                  width: double.infinity,

                  height: 54,

                  child: ElevatedButton(
                    onPressed: () {

                      if (context.canPop()) {
                        context.pop();
                      }

                      setState(() {

                        selectedGroupe = null;

                        quantite = 1;

                        selectedCentre = null;

                        villeController.clear();

                      });
                    },

                    style: ElevatedButton.styleFrom(
                      elevation: 0,

                      backgroundColor:
                          const Color(0xFFC1121F),

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                    ),

                    child: Text(
                      l10n.continueText,

                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
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
            borderRadius:
                BorderRadius.circular(24),
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

              child: Text(l10n.ok),
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

    final l10n =
        AppLocalizations.of(context)!;
          final isDark =
      Theme.of(context).brightness == Brightness.dark;

  final colors =
      Theme.of(context).colorScheme;

    return Scaffold(
     backgroundColor: isDark
      ? const Color(0xFF0F172A)
      : const Color(0xFFF7F8FA),

      appBar: AppBar(
        elevation: 0,

        backgroundColor: Colors.transparent,
        foregroundColor:
            isDark ? Colors.white : Colors.black,

        centerTitle: true,

        title: Text(
          l10n.urgentRequest,

          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              /// ======================================
              /// HEADER
              /// ======================================
              Container(
                width: double.infinity,

                padding:
                    const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(
                    begin: Alignment.topLeft,

                    end:
                        Alignment.bottomRight,

                    colors: [
                      Color(0xFFE53946),
                      Color(0xFFC1121F),
                    ],
                  ),

                  borderRadius:
                      BorderRadius.circular(32),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.red
                          .withOpacity(0.20),

                      blurRadius: 30,

                      offset:
                          const Offset(0, 14),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.14),

                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                      ),

                      child: Text(
                        l10n.urgentNeed,

                        style: const TextStyle(
                          color: Colors.white,

                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      l10n.sendBloodRequest,

                      style: const TextStyle(
                        color: Colors.white,

                        fontSize: 30,

                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      l10n.donorsReceiveAlert,

                      style: const TextStyle(
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
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : Colors.white,

                  borderRadius:
                      BorderRadius.circular(30),

                  boxShadow: [
                    BoxShadow(
                      color: isDark
                        ? Colors.white
                        : Colors.black87
                          .withOpacity(0.04),

                      blurRadius: 24,

                      offset:
                          const Offset(0, 10),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    /// ==================================
                    /// GROUPES
                    /// ==================================
                    Text(
                      l10n.bloodGroup,

                      style: const TextStyle(
                        fontWeight:
                            FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 12,
                      runSpacing: 12,

                      children:
                          groupes.map((groupe) {

                        final selected =
                            selectedGroupe ==
                                groupe;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedGroupe =
                                  groupe;
                            });
                          },

                          child:
                              AnimatedContainer(
                            duration:
                                const Duration(
                              milliseconds: 220,
                            ),

                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 18,

                              vertical: 14,
                            ),

                            decoration:
                                BoxDecoration(
                              color: selected
                              ? const Color(0xFFC1121F)
                              : isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFF5F6FA),

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                18,
                              ),
                            ),

                            child: Text(
                              groupe,

                              style: TextStyle(
                                color: selected
                                ? Colors.white
                                : isDark
                                    ? Colors.white
                                    : Colors.black87,

                                fontWeight:
                                    FontWeight
                                        .w800,

                                fontSize: 15,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 28),

                    /// ==================================
                    /// VILLE AUTOCOMPLETE
                    /// ==================================
                    Text(
                      l10n.city,

                      style: const TextStyle(
                        fontWeight:
                            FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Autocomplete<String>(
                      optionsBuilder:
                          (TextEditingValue value) {

                        if (value.text.isEmpty) {
                          return mauritanieVilles;
                        }

                        return mauritanieVilles.where(
                          (ville) {
                            return ville
                                .toLowerCase()
                                .contains(
                                  value.text
                                      .toLowerCase(),
                                );
                          },
                        );
                      },

                      onSelected: (value) {
                        villeController.text =
                            value;
                      },

                      fieldViewBuilder: (
                        context,
                        controller,
                        focusNode,
                        onFieldSubmitted,
                      ) {

                        controller.text =
                            villeController.text;

                        return TextField(
                          controller: controller,

                          focusNode: focusNode,

                          decoration:
                              InputDecoration(
                            hintText:
                                l10n.enterYourCity,

                            prefixIcon:
                                const Icon(
                              Icons
                                  .location_on_rounded,
                            ),

                            filled: true,

                            fillColor: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFF5F6FA),

                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(20),

                              borderSide:
                                  BorderSide.none,
                            ),
                          ),

                          onChanged: (value) {
                            villeController.text =
                                value;
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 28),

                   /// ==================================
/// CENTRE DE DON
/// ==================================
const Text(
  "Centre de don",

  style: TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 16,
  ),
),

const SizedBox(height: 8),

const Text(
  "3 centres proches affichés • recherchez pour voir tous les centres",

  style: TextStyle(
    color: Colors.grey,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  ),
),

const SizedBox(height: 14),

loadingCentres
    ? const Center(
        child: CircularProgressIndicator(),
      )
    : Autocomplete<Map<String, dynamic>>(
        optionsBuilder: (
          TextEditingValue value,
        ) {

          /// SI VIDE => 3 PROCHES
          if (value.text.trim().isEmpty) {
            return centres.take(3).toList();
          }

          final search =
              value.text.toLowerCase();

          /// RECHERCHE TOUS LES CENTRES
          return centres.where((centre) {

            final nom =
                centre["nom"]
                    .toString()
                    .toLowerCase();

            final ville =
                centre["ville"]
                    .toString()
                    .toLowerCase();

            return nom.contains(search) ||
                ville.contains(search);

          }).toList();
        },

        displayStringForOption:
            (centre) => centre["nom"],

        onSelected: (centre) {

          setState(() {
            selectedCentre = centre;
          });
        },

        fieldViewBuilder: (
          context,
          controller,
          focusNode,
          onFieldSubmitted,
        ) {

          if (selectedCentre != null) {
           controller.text =
              selectedCentre?["nom"] ?? "";
          }

          return TextField(
            controller: controller,
            focusNode: focusNode,

            decoration: InputDecoration(
              hintText:
                  "Rechercher ou choisir un centre",

              prefixIcon: const Icon(
                Icons.local_hospital,
              ),

              filled: true,

              fillColor: isDark
                ? const Color(0xFF334155)
                : const Color(0xFFF5F6FA),

              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),

                borderSide:
                    BorderSide.none,
              ),
            ),
          );
        },

        optionsViewBuilder: (
          context,
          onSelected,
          options,
        ) {

          return Align(
            alignment: Alignment.topLeft,

            child: Material(
              elevation: 8,

              borderRadius:
                  BorderRadius.circular(20),

              child: Container(
                width:
                    MediaQuery.of(context)
                        .size
                        .width - 40,

                constraints:
                    const BoxConstraints(
                  maxHeight: 320,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),

                child: ListView.builder(
                  padding:
                      const EdgeInsets.all(8),

                  itemCount:
                      options.length,

                  itemBuilder:
                      (context, index) {

                    final centre =
                        options.elementAt(index);

                    final distance =
                        centre["distance"];

                    return InkWell(
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),

                      onTap: () {
                        onSelected(centre);
                      },

                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),

                        child: Row(
                          children: [

                            Container(
                              padding:
                                  const EdgeInsets.all(10),

                              decoration:
                                  BoxDecoration(
                                color:
                                    const Color(
                                  0xFFC1121F,
                                ).withOpacity(0.08),

                                borderRadius:
                                    BorderRadius.circular(
                                  14,
                                ),
                              ),

                              child: const Icon(
                                Icons.local_hospital,
                                color:
                                    Color(0xFFC1121F),
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                children: [

                                  Text(
                                    centre["nom"],

                                    maxLines: 1,

                                    overflow:
                                        TextOverflow.ellipsis,

                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight.w800,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    centre["ville"],

                                    style:
                                        const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            if (distance != null)
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color:
                                      Colors.red.withOpacity(
                                    0.08,
                                  ),

                                  borderRadius:
                                      BorderRadius.circular(
                                    30,
                                  ),
                                ),

                                child: Text(
                                  "${distance.toStringAsFixed(1)} km",

                                  style:
                                      const TextStyle(
                                    color:
                                        Color(0xFFC1121F),

                                    fontWeight:
                                        FontWeight.w700,

                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),

         const SizedBox(height: 28),
                    /// ==================================
                    /// QUANTITE
                    /// ==================================
                    Text(
                      l10n.requestedQuantity,

                      style: const TextStyle(
                        fontWeight:
                            FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),

                      decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFF5F6FA),

                        borderRadius:
                            BorderRadius
                                .circular(20),
                      ),

                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,

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
                              padding:
                                  const EdgeInsets
                                      .all(6),

                              decoration:
                                  BoxDecoration(
                                color: isDark
                                  ? const Color(0xFF475569)
                                  : Colors.white,

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  12,
                                ),
                              ),

                              child:
                                  const Icon(
                                Icons.remove,
                              ),
                            ),
                          ),

                          /// VALUE
                          Text(
                            "$quantite ${l10n.bags}",

                            style:
                                const TextStyle(
                              fontSize: 18,

                              fontWeight:
                                  FontWeight
                                      .w900,
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
                              padding:
                                  const EdgeInsets
                                      .all(6),

                              decoration:
                                  BoxDecoration(
                                color:
                                    const Color(
                                  0xFFC1121F,
                                ),

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  12,
                                ),
                              ),

                              child:
                                  const Icon(
                                Icons.add,
                                color:
                                    Colors.white,
                              ),
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
                  onPressed:
                      isLoading
                          ? null
                          : envoyerDemande,

                  style:
                      ElevatedButton.styleFrom(
                    elevation: 0,

                    backgroundColor:
                        const Color(
                      0xFFC1121F,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(22),
                    ),
                  ),

                  child:
                      isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,

                              child:
                                  CircularProgressIndicator(
                                color:
                                    Colors.white,
                              ),
                            )
                          : Text(
                              l10n.sendNow,

                              style:
                                  const TextStyle(
                                fontSize: 16,

                                fontWeight:
                                    FontWeight
                                        .w800,
                              ),
                            ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

