import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_colors.dart';

import '../../application/centers_provider.dart';
import '../../data/models/center_model.dart';
import '../../../alerts/data/models/alert_model.dart';

import '../widgets/map_top_bar.dart';
import '../widgets/center_marker.dart';
import '../widgets/current_location_marker.dart';
import '../widgets/map_live_status_card.dart';
import '../widgets/map_floating_buttons.dart';
import '../widgets/map_bottom_sheet.dart';

import '../../../../l10n/app_localizations.dart';

class CentersMapScreen extends ConsumerStatefulWidget {
  final String? initialSearch;

  final AlertCenterModel? initialCenter;

  const CentersMapScreen({super.key, this.initialSearch, this.initialCenter});

  @override
  ConsumerState<CentersMapScreen> createState() => _CentersMapScreenState();
}

class _CentersMapScreenState extends ConsumerState<CentersMapScreen> {
  static const String appPackageName = 'com.example.thielal';

  final MapController _mapController = MapController();

  final TextEditingController _searchController = TextEditingController();

  LatLng _currentPosition = const LatLng(18.0735, -15.9582);

  bool _isLoading = true;

  bool _isSatellite = false;

  String? _errorMessage;

  String _currentCity = '';

  CenterModel? _selectedCenter;

  bool _hasFocusedCenter = false;

  List<CenterModel> _filteredCenters = [];

  List<LatLng> _routePoints = [];

  @override
  void initState() {
    super.initState();

    debugPrint('MAP CENTER => ${widget.initialCenter?.name}');

    _initializeMap();
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  /// ======================================
  /// FIND NEAREST CITY
  /// ======================================

  String _findNearestCity() {
    final centers = List<CenterModel>.from(_filteredCenters);

    if (centers.isEmpty) {
      return '';
    }

    centers.sort((a, b) {
      final distanceA = Geolocator.distanceBetween(
        _currentPosition.latitude,
        _currentPosition.longitude,
        a.latitude,
        a.longitude,
      );

      final distanceB = Geolocator.distanceBetween(
        _currentPosition.latitude,
        _currentPosition.longitude,
        b.latitude,
        b.longitude,
      );

      return distanceA.compareTo(distanceB);
    });

    return centers.first.ville;
  }

  /// ======================================
  /// NEARBY CENTERS
  /// ======================================

  List<CenterModel> _nearbyCenters(List<CenterModel> centers) {
    return centers.where((center) {
      final distance = Geolocator.distanceBetween(
        _currentPosition.latitude,
        _currentPosition.longitude,
        center.latitude,
        center.longitude,
      );

      return distance <= 30000;
    }).toList();
  }

  Future<void> _initializeMap() async {
    await _loadCurrentLocation();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final centers = ref.read(centersProvider);

      centers.whenData((data) {
        setState(() {
          _filteredCenters = data;
        });

        /// CENTER FROM DETAILS SCREEN

        if (widget.initialCenter != null) {
          debugPrint('CENTER RECEIVED => ${widget.initialCenter!.name}');

          _hasFocusedCenter = true;

          _loadAlertRoute(widget.initialCenter!);

          _mapController.move(
            LatLng(
              widget.initialCenter!.latitude,
              widget.initialCenter!.longitude,
            ),
            15,
          );
        }

        /// SEARCH FROM HOME

        if (widget.initialSearch != null &&
            widget.initialSearch!.trim().isNotEmpty) {
          _searchController.text = widget.initialSearch!;

          _filterCenters(widget.initialSearch!, data);

          final match =
              data.where((c) {
                return c.nom.toLowerCase().contains(
                  widget.initialSearch!.toLowerCase(),
                );
              }).toList();

          if (match.isNotEmpty) {
            _hasFocusedCenter = true;

            Future.delayed(const Duration(milliseconds: 700), () async {
              final center = match.first;

              setState(() {
                _selectedCenter = center;
              });

              await _loadRoute(center);

              _openCenterSheet(center);

              _mapController.move(
                LatLng(center.latitude, center.longitude),
                15,
              );
            });
          }
        }
      });
    });
  }

  /// ======================================
  /// LOAD LOCATION
  /// ======================================

  Future<void> _loadCurrentLocation() async {
    try {
      setState(() {
        _isLoading = true;

        _errorMessage = null;
      });

      final position = await _determinePosition();
      debugPrint(
        'GPS POSITION => '
        '${position.latitude}, '
        '${position.longitude}',
      );

      final latLng = LatLng(position.latitude, position.longitude);

      if (!mounted) return;

      setState(() {
        _currentPosition = latLng;

        _currentCity = _findNearestCity();

        _isLoading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_hasFocusedCenter) {
          _mapController.move(latLng, 15);
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;

        _errorMessage = e.toString();
      });
    }
  }

  /// ======================================
  /// GPS
  /// ======================================

  Future<Position> _determinePosition() async {
    bool serviceEnabled;

    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('GPS désactivé');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception('Permission refusée');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permission refusée définitivement');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// ======================================
  /// FILTER CENTERS
  /// ======================================

  void _filterCenters(String query, List<CenterModel> centers) {
    if (query.trim().isEmpty) {
      setState(() {
        _filteredCenters = centers;

        _currentCity = _findNearestCity();
      });

      return;
    }

    final filtered =
        centers.where((c) {
          return c.nom.toLowerCase().contains(query.toLowerCase()) ||
              c.ville.toLowerCase().contains(query.toLowerCase());
        }).toList();

    setState(() {
      _filteredCenters = filtered;

      _currentCity = _findNearestCity();
    });

    if (filtered.isNotEmpty) {
      final first = filtered.first;

      _mapController.move(LatLng(first.latitude, first.longitude), 15);
    }
  }

  /// ======================================
  /// TOGGLE MAP STYLE
  /// ======================================

  void _toggleMapStyle() {
    setState(() {
      _isSatellite = !_isSatellite;
    });
  }

  /// ======================================
  /// LOAD ROUTE
  /// ======================================

  Future<void> _loadAlertRoute(AlertCenterModel center) async {
    try {
      debugPrint(
        'ROUTE FROM => ${_currentPosition.latitude}, ${_currentPosition.longitude}',
      );

      debugPrint('ROUTE TO => ${center.latitude}, ${center.longitude}');
      final url =
          'https://router.project-osrm.org/route/v1/driving/'
          '${_currentPosition.longitude},${_currentPosition.latitude};'
          '${center.longitude},${center.latitude}'
          '?overview=full&geometries=geojson';

      final response = await http.get(Uri.parse(url));

      final data = jsonDecode(response.body);

      final coords = data['routes'][0]['geometry']['coordinates'] as List;

      final points =
          coords.map<LatLng>((c) {
            return LatLng(c[1], c[0]);
          }).toList();

      setState(() {
        _routePoints = points;
      });
    } catch (e) {
      debugPrint('❌ ALERT ROUTE ERROR => $e');
    }
  }

  Future<void> _loadRoute(CenterModel center) async {
    try {
      final url =
          'https://router.project-osrm.org/route/v1/driving/'
          '${_currentPosition.longitude},${_currentPosition.latitude};'
          '${center.longitude},${center.latitude}'
          '?overview=full&geometries=geojson';

      final response = await http.get(Uri.parse(url));

      final data = jsonDecode(response.body);

      final coords = data['routes'][0]['geometry']['coordinates'] as List;

      final points =
          coords.map<LatLng>((c) {
            return LatLng(c[1], c[0]);
          }).toList();

      setState(() {
        _routePoints = points;
      });
    } catch (e) {
      debugPrint('❌ ROUTE ERROR => $e');
    }
  }

  /// ======================================
  /// DISTANCE
  /// ======================================

  String _calculateDistance(double lat, double lng) {
    final l10n = AppLocalizations.of(context)!;

    final meters = Geolocator.distanceBetween(
      _currentPosition.latitude,
      _currentPosition.longitude,
      lat,
      lng,
    );

    final km = meters / 1000;

    return '${km.toStringAsFixed(1)} ${l10n.kilometers}';
  }

  /// ======================================
  /// GOOGLE MAPS
  /// ======================================

  Future<void> _openDirections(CenterModel center) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=${center.latitude},${center.longitude}';

    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// ======================================
  /// CALL CENTER
  /// ======================================

  Future<void> _callCenter(String phone) async {
    final uri = Uri.parse('tel:$phone');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// ======================================
  /// BOTTOM SHEET
  /// ======================================

  void _openCenterSheet(CenterModel center) {
    final distance = _calculateDistance(center.latitude, center.longitude);

    showModalBottomSheet(
      context: context,

      backgroundColor: Colors.transparent,

      isScrollControlled: true,

      builder: (_) {
        return MapBottomSheet(
          centerName: center.nom,

          address: '${center.adresse}, ${center.ville}',

          distance: distance,

          onCallTap: () {
            _callCenter(center.telephone ?? '');
          },

          onDirectionsTap: () async {
            Navigator.pop(context);

            setState(() {
              _selectedCenter = center;
            });

            await _loadRoute(center);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final centersAsync = ref.watch(centersProvider);

    return Scaffold(
      backgroundColor: AppColors.silverBackground,

      body: Stack(
        children: [
          /// ==================================
          /// MAP
          /// ==================================
          centersAsync.when(
            data: (List<CenterModel> centers) {
              if (_filteredCenters.isEmpty) {
                _filteredCenters = centers;
              }

              return FlutterMap(
                mapController: _mapController,

                options: MapOptions(
                  initialCenter: _currentPosition,

                  initialZoom: 13,
                ),

                children: [
                  /// ==================================
                  /// TILE LAYER
                  /// ==================================
                  TileLayer(
                    urlTemplate:
                        _isSatellite
                            ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                            : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',

                    userAgentPackageName: appPackageName,
                  ),

                  /// ==================================
                  /// ROUTE
                  /// ==================================
                  if (_routePoints.isNotEmpty)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _routePoints,

                          strokeWidth: 6,

                          color: Colors.blue,

                          borderStrokeWidth: 2,

                          borderColor: Colors.white,
                        ),
                      ],
                    ),

                  /// ==================================
                  /// MARKERS
                  /// ==================================
                  MarkerLayer(
                    markers: [
                      /// USER
                      Marker(
                        point: _currentPosition,

                        width: 90,
                        height: 90,

                        child: const CurrentLocationMarker(),
                      ),

                      /// CENTERS
                      ..._filteredCenters.map((CenterModel center) {
                        return Marker(
                          point: LatLng(center.latitude, center.longitude),

                          width: 90,
                          height: 90,

                          child: CenterMarker(
                            selected: _selectedCenter?.id == center.id,

                            onTap: () async {
                              setState(() {
                                _selectedCenter = center;
                              });

                              await _loadRoute(center);

                              _openCenterSheet(center);

                              _mapController.move(
                                LatLng(center.latitude, center.longitude),
                                15,
                              );
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              );
            },

            loading:
                () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primaryRed),
                ),

            error: (e, _) {
              return Center(child: Text('${l10n.error} : $e'));
            },
          ),

          /// ==================================
          /// TOP BAR
          /// ==================================
          centersAsync.when(
            data: (List<CenterModel> centers) {
              return MapTopBar(
                controller: _searchController,

                onChanged: (value) {
                  _filterCenters(value, centers);
                },
              );
            },

            loading: () => const SizedBox(),

            error: (_, __) => const SizedBox(),
          ),

          /// ==================================
          /// LIVE STATUS
          /// ==================================
          MapLiveStatusCard(
            centersCount: _nearbyCenters(_filteredCenters).length,

            city: _currentCity,
          ),

          /// ==================================
          /// FLOATING BUTTONS
          /// ==================================
          MapFloatingButtons(
            onGpsTap: _loadCurrentLocation,

            onLayersTap: _toggleMapStyle,
          ),

          /// ==================================
          /// LOADING
          /// ==================================
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.12),

              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primaryRed),
              ),
            ),

          /// ==================================
          /// ERROR
          /// ==================================
          if (_errorMessage != null && !_isLoading)
            Positioned(
              left: 20,
              right: 20,
              bottom: 40,

              child: Container(
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(22),
                ),

                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        _errorMessage!,

                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
