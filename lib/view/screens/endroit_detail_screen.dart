import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../model/endroit.dart';

/// Écran de détail : photo, nom, adresse et carte Google Maps.
class EndroitDetailScreen extends StatelessWidget {
  const EndroitDetailScreen({super.key, required this.endroit});
  final Endroit endroit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar avec photo en arrière-plan (SliverAppBar)
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                endroit.nom,
                style: const TextStyle(shadows: [Shadow(blurRadius: 8)]),
              ),
              background: Image.file(
                File(endroit.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Adresse
                if (endroit.adresse != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            endroit.adresse!,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Carte Google Maps (uniquement si coordonnées disponibles)
                if (endroit.aLocalisation)
                  SizedBox(
                    height: 320,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(endroit.latitude!, endroit.longitude!),
                        zoom: 15,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('detail'),
                          position: LatLng(
                            endroit.latitude!,
                            endroit.longitude!,
                          ),
                          infoWindow: InfoWindow(title: endroit.nom),
                        ),
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
