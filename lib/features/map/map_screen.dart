import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  static const String appPackageName = 'com.example.thielal';

  @override
  Widget build(BuildContext context) {
    final nouakchott = LatLng(18.0735, -15.9582);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Carte des donneurs"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: FlutterMap(
        options: MapOptions(initialCenter: nouakchott, initialZoom: 13),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: appPackageName,
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: nouakchott,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Fonction à venir")));
        },
        child: const Icon(Icons.filter_alt),
      ),
    );
  }
}
