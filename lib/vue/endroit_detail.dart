import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../modele/endroit.dart';

/// Page de détails d'un endroit favori.
/// Affiche la photo, le nom, l'adresse et la carte Google Maps si disponibles.
class EndroitDetail extends StatelessWidget {
  const EndroitDetail({super.key, required this.endroit});

  final Endroit endroit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(endroit.nom)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Photo de l'endroit en pleine largeur
          Image.file(
            endroit.image,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),

          // Nom de l'endroit
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              endroit.nom,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),

          // Adresse (affichée uniquement si disponible)
          if (endroit.adresse != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                endroit.adresse!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Carte Google Maps (uniquement si les coordonnées GPS sont disponibles)
          if (endroit.aLocalisation)
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(endroit.latitude!, endroit.longitude!),
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('endroit_marker'),
                    position: LatLng(endroit.latitude!, endroit.longitude!),
                    infoWindow: InfoWindow(title: endroit.nom),
                  ),
                },
                zoomControlsEnabled: true,
                myLocationButtonEnabled: false,
              ),
            ),
        ],
      ),
    );
  }
}
