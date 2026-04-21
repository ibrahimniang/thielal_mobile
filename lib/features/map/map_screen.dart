import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nouakchott = LatLng(18.0735, -15.9582);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Carte des donneurs"),
        backgroundColor: Colors.red,
      ),

      body: FlutterMap(
        options: MapOptions(initialCenter: nouakchott, initialZoom: 13),

        children: [
          // 🗺️ Fond carte (OpenStreetMap GRATUIT)
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),

          // 📍 Marker exemple (à remplacer par backend plus tard)
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

      // ➕ bouton futur (urgence / filtre)
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
