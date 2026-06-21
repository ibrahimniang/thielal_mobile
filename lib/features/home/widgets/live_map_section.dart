import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class LiveMapSection extends StatefulWidget {
  final List<dynamic> centers;

  final int urgentRequests;

  final String city;

  final VoidCallback? onTap;

  const LiveMapSection({
    super.key,
    required this.centers,
    required this.urgentRequests,
    required this.city,
    this.onTap,
  });

  @override
  State<LiveMapSection> createState() => _LiveMapSectionState();
}

class _LiveMapSectionState extends State<LiveMapSection> {
  double selectedRadius = 15;

  final MapController _mapController = MapController();

  Position? currentPosition;

  @override
  void initState() {
    super.initState();

    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition();

      setState(() {
        currentPosition = position;
      });

      _mapController.move(
        LatLng(position.latitude, position.longitude),
        zoomLevel,
      );
    } catch (e) {
      debugPrint('Erreur GPS : $e');
    }
  }

  double get zoomLevel {
    if (selectedRadius == 5) {
      return 15.5;
    }

    if (selectedRadius == 15) {
      return 13.8;
    }

    return 12.5;
  }

  List<dynamic> get filteredCenters {
    if (currentPosition == null) {
      return [];
    }

    return widget.centers.where((c) {
      final distance = Geolocator.distanceBetween(
        currentPosition!.latitude,
        currentPosition!.longitude,
        c.latitude,
        c.longitude,
      );

      return distance <= (selectedRadius * 1000);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark =
      Theme.of(context).brightness == Brightness.dark;

  final colors =
      Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        colors.surface,
                        colors.surfaceContainerHighest,
                        colors.surface,
                      ]
                    : const [
                        Color(0xFF101D46),
                        Color(0xFF162B69),
                        Color(0xFF243B87),
                      ],
              ),

          borderRadius: BorderRadius.circular(30),

          boxShadow: [
            BoxShadow(
              color: isDark
                ? Colors.black.withOpacity(0.40)
                : const Color(0xFF243B87).withOpacity(0.28),

              blurRadius: 30,

              offset: const Offset(0, 14),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// ==========================================
            /// TOP BAR
            /// ==========================================
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: isDark
                    ? colors.surfaceContainerHighest.withOpacity(0.7)
                    : Colors.white.withOpacity(0.10),

                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: Row(
                    children: [
                      Icon(
                        Icons.radio_button_checked,

                        color: Colors.red,

                        size: 10,
                      ),

                      SizedBox(width: 8),

                      Text(
                        l10n.realTimeSituation,

                        style: TextStyle(
                          color: isDark
                              ? colors.onSurface
                              : Colors.white,

                          fontWeight: FontWeight.w800,

                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.red,

                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: Text(
                    l10n.live.toUpperCase(),

                    style: TextStyle(
                      color: isDark
                        ? colors.onSurface
                        : Colors.white,

                      fontWeight: FontWeight.w800,

                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// ==========================================
            /// MINI MAP PREMIUM
            /// ==========================================
            Container(
              height: 190,

              clipBehavior: Clip.antiAlias,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),

                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),

              child: Stack(
                children: [
                  /// ==========================================
                  /// MAP
                  /// ==========================================
                  FlutterMap(
                    mapController: _mapController,

                    options: MapOptions(
                      initialCenter: LatLng(
                        currentPosition?.latitude ?? 18.0735,

                        currentPosition?.longitude ?? -15.9582,
                      ),

                      initialZoom: zoomLevel,

                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.none,
                      ),
                    ),

                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',

                        userAgentPackageName: 'com.thielal.lifelink',
                      ),

                      /// ==========================================
                      /// CENTERS MARKERS
                      /// ==========================================
                      MarkerLayer(
                        markers:
                            filteredCenters.map((center) {
                              return Marker(
                                point: LatLng(
                                  center.latitude,
                                  center.longitude,
                                ),
                                //taille localisation centre
                                width: 48,
                                height: 48,

                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,

                                    shape: BoxShape.circle,

                                    border: Border.all(
                                      color: Colors.white,

                                      width: 2.5,
                                    ),

                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.red.withOpacity(0.40),

                                        blurRadius: 18,
                                      ),
                                    ],
                                  ),

                                  child: const Icon(
                                    Icons.local_hospital,

                                    color: Colors.white,

                                    size: 22,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ),

                  /// ==========================================
                  /// BLUE OVERLAY
                  /// ==========================================
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,

                        end: Alignment.bottomCenter,

                        colors: isDark
                          ? [
                              Colors.black.withOpacity(0.10),
                              Colors.black.withOpacity(0.20),
                              Colors.black.withOpacity(0.35),
                            ]
                          : [
                              const Color(0xFF243B87).withOpacity(0.20),
                              const Color(0xFF162B69).withOpacity(0.30),
                              const Color(0xFF101D46).withOpacity(0.42),
                            ],
                      ),
                    ),
                  ),

                  /// ==========================================
                  /// CITY BADGE
                  /// ==========================================
                  Positioned(
                    top: 16,
                    left: 16,

                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),

                      decoration: BoxDecoration(
                        color: isDark
                        ? colors.surfaceContainerHighest.withOpacity(0.8)
                        : Colors.white.withOpacity(0.14),

                        borderRadius: BorderRadius.circular(30),

                        border: Border.all(
                          color: Colors.white.withOpacity(0.10),
                        ),
                      ),

                      child: Row(
                        children: [
                           Icon(
                            Icons.location_city,

                            color: isDark
                              ? colors.onSurface
                              : Colors.white,

                            size: 16,
                          ),

                          const SizedBox(width: 8),

                          Text(
                            widget.city,

                            style: TextStyle(
                              color: isDark
                                ? colors.surfaceContainerHighest
                                : Colors.white,

                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// ==========================================
                  /// VIEW MAP BUTTON
                  /// ==========================================
                  Positioned(
                    bottom: 16,
                    right: 16,

                    child: GestureDetector(
                      onTap: widget.onTap,

                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(30),
                        ),

                        child: Row(
                          children: [
                            Icon(
                              Icons.map_rounded,

                              size: 18,

                              color: isDark
                                ? colors.primary
                                : const Color(0xFF101D46),
                            ),

                            SizedBox(width: 8),

                            Text(
                              l10n.viewMap,

                              style: TextStyle(
                                color: isDark
                                  ? colors.primary
                                  : const Color(0xFF101D46),

                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ==========================================
            /// STATS
            /// ==========================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),

              decoration: BoxDecoration(
                color: isDark
                  ? colors.surfaceContainerHighest.withOpacity(0.60)
                  : Colors.white.withOpacity(0.06),

                borderRadius: BorderRadius.circular(22),

                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),

              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          '${filteredCenters.length}',

                          style: TextStyle(
                            color: isDark
                                ? colors.onSurface
                                : Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          l10n.nearbyCenters,

                          style: TextStyle(color: isDark
                            ? colors.onSurface.withOpacity(0.7)
                            : Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),

                    decoration: BoxDecoration(
                      color: colors.error.withOpacity(0.18),

                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: Text(
                      '${widget.urgentRequests} ${l10n.urgencies}',

                      style: TextStyle(
                          color: isDark
                              ? colors.onSurface
                              : Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            /// ==========================================
            /// RANGE FILTER
            /// ==========================================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRadius = 5;
                    });

                    _mapController.move(
                      LatLng(
                        currentPosition?.latitude ?? 18.0735,

                        currentPosition?.longitude ?? -15.9582,
                      ),

                      15.5,
                    );
                  },

                  child: _chip('5 km', selectedRadius == 5),
                ),

                const SizedBox(width: 10),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRadius = 15;
                    });

                    _mapController.move(
                      LatLng(
                        currentPosition?.latitude ?? 18.0735,

                        currentPosition?.longitude ?? -15.9582,
                      ),

                      13.8,
                    );
                  },

                  child: _chip('15 km', selectedRadius == 15),
                ),

                const SizedBox(width: 10),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRadius = 30;
                    });

                    _mapController.move(
                      LatLng(
                        currentPosition?.latitude ?? 18.0735,

                        currentPosition?.longitude ?? -15.9582,
                      ),

                      12.5,
                    );
                  },

                  child: _chip('30 km', selectedRadius == 30),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text, bool active) {
  final isDark =
      Theme.of(context).brightness == Brightness.dark;

  final colors = Theme.of(context).colorScheme;

  return AnimatedContainer(
    duration: const Duration(milliseconds: 220),

    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 9,
    ),

    decoration: BoxDecoration(
      color: active
          ? (isDark
              ? colors.primary
              : Colors.white)
          : (isDark
              ? colors.surfaceContainerHighest
              : Colors.white.withOpacity(0.06)),

      borderRadius: BorderRadius.circular(18),

      border: Border.all(
        color: active
            ? (isDark
                ? colors.primary
                : Colors.white)
            : (isDark
                ? colors.outline.withOpacity(0.20)
                : Colors.white.withOpacity(0.05)),
      ),
    ),

    child: Text(
      text,
      style: TextStyle(
        color: active
            ? (isDark
                ? colors.onPrimary
                : const Color(0xFF101D46))
            : (isDark
                ? colors.onSurface
                : Colors.white70),

        fontWeight: FontWeight.w700,
        fontSize: 13,
      ),
    ),
  );
}
}
