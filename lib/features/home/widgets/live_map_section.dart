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
  State<LiveMapSection> createState() =>
      _LiveMapSectionState();
}

class _LiveMapSectionState
    extends State<LiveMapSection> {
  double selectedRadius = 15;

  final MapController _mapController =
      MapController();

  Position? currentPosition;

  @override
  void initState() {
    super.initState();

    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {
    try {
      bool serviceEnabled =
          await Geolocator
              .isLocationServiceEnabled();

      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission ==
          LocationPermission.denied) {
        permission =
            await Geolocator
                .requestPermission();
      }

      if (permission ==
              LocationPermission.denied ||
          permission ==
              LocationPermission
                  .deniedForever) {
        return;
      }

      final position =
          await Geolocator
              .getCurrentPosition();

      setState(() {
        currentPosition = position;
      });

      _mapController.move(
        LatLng(
          position.latitude,
          position.longitude,
        ),
        zoomLevel,
      );
    } catch (e) {
      debugPrint(
        'Erreur GPS : $e',
      );
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
      final distance =
          Geolocator.distanceBetween(
            currentPosition!.latitude,
            currentPosition!.longitude,
            c.latitude,
            c.longitude,
          );

      return distance <=
          (selectedRadius * 1000);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal:
            AppSpacing.screenPadding,
      ),

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(
          AppSpacing.xl,
        ),

        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [
              Color(0xFF101D46),
              Color(0xFF162B69),
              Color(0xFF243B87),
            ],
          ),

          borderRadius:
              BorderRadius.circular(30),

          boxShadow: [
            BoxShadow(
              color: const Color(
                0xFF243B87,
              ).withOpacity(0.28),

              blurRadius: 30,

              offset: const Offset(
                0,
                14,
              ),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            /// ==========================================
            /// TOP BAR
            /// ==========================================

            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),

                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.10),

                    borderRadius:
                        BorderRadius.circular(
                          30,
                        ),
                  ),

                  child:  Row(
                    children: [
                      Icon(
                        Icons
                            .radio_button_checked,

                        color: Colors.red,

                        size: 10,
                      ),

                      SizedBox(width: 8),

                      Text(
                        l10n.realTimeSituation,

                        style: TextStyle(
                          color:
                              Colors.white,

                          fontWeight:
                              FontWeight
                                  .w800,

                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),

                  decoration: BoxDecoration(
                    color: Colors.red,

                    borderRadius:
                        BorderRadius.circular(
                          30,
                        ),
                  ),

                  child:Text(
  l10n.live.toUpperCase(),

                    style: TextStyle(
                      color: Colors.white,

                      fontWeight:
                          FontWeight.w800,

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
              height: 230,

              clipBehavior: Clip.antiAlias,

              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(
                      28,
                    ),

                border: Border.all(
                  color: Colors.white
                      .withOpacity(0.08),
                ),
              ),

              child: Stack(
                children: [
                  /// ==========================================
                  /// MAP
                  /// ==========================================

                  FlutterMap(
                    mapController:
                        _mapController,

                    options: MapOptions(
                      initialCenter: LatLng(
                        currentPosition
                                ?.latitude ??
                            18.0735,

                        currentPosition
                                ?.longitude ??
                            -15.9582,
                      ),

                      initialZoom: zoomLevel,

                      interactionOptions:
                          const InteractionOptions(
                            flags:
                                InteractiveFlag.none,
                          ),
                    ),

                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      ),

                      /// ==========================================
                      /// CENTERS MARKERS
                      /// ==========================================

                      MarkerLayer(
                        markers:
                            filteredCenters.map((
                              center,
                            ) {
                              return Marker(
                                point: LatLng(
                                  center.latitude,
                                  center.longitude,
                                ),

                                width: 65,
                                height: 65,

                                child: Container(
                                  decoration:
                                      BoxDecoration(
                                        color:
                                            Colors.red,

                                        shape:
                                            BoxShape
                                                .circle,

                                        border:
                                            Border.all(
                                              color:
                                                  Colors
                                                      .white,

                                              width:
                                                  4,
                                            ),

                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors
                                                .red
                                                .withOpacity(
                                                  0.40,
                                                ),

                                            blurRadius:
                                                18,
                                          ),
                                        ],
                                      ),

                                  child: const Icon(
                                    Icons
                                        .local_hospital,

                                    color:
                                        Colors
                                            .white,

                                    size: 28,
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
                        begin:
                            Alignment.topCenter,

                        end:
                            Alignment.bottomCenter,

                        colors: [
                          const Color(
                            0xFF243B87,
                          ).withOpacity(0.20),

                          const Color(
                            0xFF162B69,
                          ).withOpacity(0.30),

                          const Color(
                            0xFF101D46,
                          ).withOpacity(0.42),
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
                      padding:
                          const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),

                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.14),

                        borderRadius:
                            BorderRadius.circular(
                              30,
                            ),

                        border: Border.all(
                          color: Colors.white
                              .withOpacity(
                                0.10,
                              ),
                        ),
                      ),

                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_city,

                            color:
                                Colors.white,

                            size: 16,
                          ),

                          const SizedBox(
                            width: 8,
                          ),

                          Text(
                            widget.city,

                            style:
                                const TextStyle(
                                  color:
                                      Colors
                                          .white,

                                  fontWeight:
                                      FontWeight
                                          .w700,
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
                        padding:
                            const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(
                                30,
                              ),
                        ),

                        child:  Row(
                          children: [
                            Icon(
                              Icons.map_rounded,

                              size: 18,

                              color: Color(
                                0xFF101D46,
                              ),
                            ),

                            SizedBox(width: 8),

                            Text(
                              l10n.viewMap,

                              style: TextStyle(
                                color: Color(
                                  0xFF101D46,
                                ),

                                fontWeight:
                                    FontWeight
                                        .w800,
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

            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,

              children: [
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      '${filteredCenters.length}',

                      style: const TextStyle(
                        color: Colors.white,

                        fontSize: 40,

                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),

                     Text(
                      l10n.nearbyCenters,

                      style: TextStyle(
                        color: Colors.white70,

                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),

                  decoration: BoxDecoration(
                    color: Colors.red
                        .withOpacity(0.18),

                    borderRadius:
                        BorderRadius.circular(
                          30,
                        ),
                  ),

                  child: Text(
                    '${widget.urgentRequests} ${l10n.urgencies}',

                    style: const TextStyle(
                      color: Colors.redAccent,

                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            /// ==========================================
            /// RANGE FILTER
            /// ==========================================

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRadius = 5;
                    });

                    _mapController.move(
                      LatLng(
                        currentPosition
                                ?.latitude ??
                            18.0735,

                        currentPosition
                                ?.longitude ??
                            -15.9582,
                      ),

                      15.5,
                    );
                  },

                  child: _chip(
                    '5 km',
                    selectedRadius == 5,
                  ),
                ),

                const SizedBox(width: 10),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRadius = 15;
                    });

                    _mapController.move(
                      LatLng(
                        currentPosition
                                ?.latitude ??
                            18.0735,

                        currentPosition
                                ?.longitude ??
                            -15.9582,
                      ),

                      13.8,
                    );
                  },

                  child: _chip(
                    '15 km',
                    selectedRadius == 15,
                  ),
                ),

                const SizedBox(width: 10),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRadius = 30;
                    });

                    _mapController.move(
                      LatLng(
                        currentPosition
                                ?.latitude ??
                            18.0735,

                        currentPosition
                                ?.longitude ??
                            -15.9582,
                      ),

                      12.5,
                    );
                  },

                  child: _chip(
                    '30 km',
                    selectedRadius == 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(
    String text,
    bool active,
  ) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 250,
      ),

      padding:
          const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 10,
          ),

      decoration: BoxDecoration(
        color:
            active
                ? Colors.red
                : Colors.white
                    .withOpacity(0.08),

        borderRadius:
            BorderRadius.circular(30),

        border: Border.all(
          color:
              active
                  ? Colors.red
                  : Colors.white
                      .withOpacity(0.08),
        ),
      ),

      child: Text(
        text,

        style: TextStyle(
          color:
              active
                  ? Colors.white
                  : Colors.white70,

          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}