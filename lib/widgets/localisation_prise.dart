import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Widget gérant l'obtention de la position GPS et l'affichage d'une mini-carte.
/// Utilise geolocator pour le GPS et geocoding pour convertir en adresse lisible.
class LocalisationPrise extends StatefulWidget {
  const LocalisationPrise({
    super.key,
    required this.onLocalisationSelectionnee,
  });

  /// Callback transmettant les coordonnées et l'adresse au widget parent.
  final void Function(double lat, double lng, String adresse)
  onLocalisationSelectionnee;

  @override
  State<LocalisationPrise> createState() => _LocalisationPriseState();
}

class _LocalisationPriseState extends State<LocalisationPrise> {
  double? _latitude;
  double? _longitude;
  String? _adresse;
  bool _chargement = false; // Indique si la récupération GPS est en cours

  /// Vérifie les permissions, récupère la position GPS puis convertit en adresse.
  Future<void> _obtenirLocalisation() async {
    // Vérification de la permission de localisation
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // L'utilisateur a refusé la permission
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Permission de localisation refusée.'),
            ),
          );
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Localisation désactivée définitivement. Activez-la dans les paramètres.',
            ),
          ),
        );
      }
      return;
    }

    setState(() => _chargement = true);

    try {
      // Récupération de la position GPS courante
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Conversion des coordonnées en adresse lisible (géocodage inverse)
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String adresseFormatee = 'Adresse inconnue';
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        // Construction de l'adresse : "Ville, Pays"
        adresseFormatee = '${p.locality ?? ''}, ${p.country ?? ''}'
            .trim()
            .replaceAll(RegExp(r'^,|,$'), '');
      }

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _adresse = adresseFormatee;
        _chargement = false;
      });

      // Transmission des données au formulaire parent
      widget.onLocalisationSelectionnee(_latitude!, _longitude!, _adresse!);
    } catch (e) {
      setState(() => _chargement = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur GPS : $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget contenu;

    if (_chargement) {
      // Indicateur de chargement pendant la récupération GPS
      contenu = const Center(child: CircularProgressIndicator());
    } else if (_latitude != null && _longitude != null) {
      // Affichage de la mini-carte avec un marqueur à la position détectée
      contenu = Column(
        children: [
          SizedBox(
            height: 180,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(_latitude!, _longitude!),
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('position_actuelle'),
                  position: LatLng(_latitude!, _longitude!),
                ),
              },
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _adresse ?? '',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      // État initial : bouton pour déclencher la récupération GPS
      contenu = TextButton.icon(
        onPressed: _obtenirLocalisation,
        icon: const Icon(Icons.location_on),
        label: const Text('Obtenir ma localisation'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Localisation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        contenu,
      ],
    );
  }
}
